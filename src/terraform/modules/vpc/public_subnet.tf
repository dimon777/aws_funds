resource "aws_subnet" "public_subnet" {
  count                   = "${var.az_count}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${coalesce(var.public_subnet_cidrs[count.index],cidrsubnet(var.vpc_cidr, 8, 2))}"
  availability_zone       = "${element(data.aws_availability_zones.all_azs.names,count.index)}"
  map_public_ip_on_launch = true
  tags                    = merge(var.additional_tags, tomap({Name = "Public-${count.index}"}))
}

resource "aws_eip" "nat" {
  count = "${var.nat_count}"
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  count         = "${var.nat_count}"
  depends_on    = [aws_internet_gateway.int_gw]
  allocation_id = "${element(aws_eip.nat.*.id,count.index)}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id,count.index)}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id           = "${aws_vpc.main.id}"
  propagating_vgws = [ aws_vpn_gateway.private_gateway.id ]
  tags             = merge(var.additional_tags, tomap({Name = "Public"}))
}

resource "aws_route" "public_route" {
  depends_on             = [aws_internet_gateway.int_gw, aws_route_table.public_route_table]
  route_table_id         = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.int_gw.id}"
}

resource "aws_route_table_association" "public_route_table_assoc" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.public_route_table.*.id,count.index)}"
}

