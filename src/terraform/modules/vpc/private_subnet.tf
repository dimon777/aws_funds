resource "aws_subnet" "private_subnet" {
  count             = "${var.az_count}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${coalesce(var.private_subnet_cidrs[count.index],cidrsubnet(var.vpc_cidr, 8, 2))}"
  availability_zone = "${element(data.aws_availability_zones.all_azs.names,count.index)}"
  tags              =  merge(var.additional_tags, tomap({Name = "Private-${count.index}"}))
}

resource "aws_route_table" "private_route_table" {
  count            = "${var.nat_count}"
  vpc_id           = "${aws_vpc.main.id}"
  propagating_vgws = ["${aws_vpn_gateway.private_gateway.id}"]
  tags             = merge(var.additional_tags, tomap({Name = "Private"}))
}

resource "aws_route" "private_route_internet" {
  count                  = var.nat_count
  depends_on             = [aws_route_table.private_route_table, aws_nat_gateway.nat_gw] # https://github.com/hashicorp/terraform/issues/7527
  route_table_id         = "${element(aws_route_table.private_route_table.*.id,count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat_gw.*.id,count.index)}"
}


# ---------------------------------------------------------------------------------------------------------------------
# Private
# ---------------------------------------------------------------------------------------------------------------------
output "private_subnets" {
  value = aws_subnet.private_subnet.*.id
}

output "private_route_tables" {
  value = [
    "${aws_route_table.private_route_table.*.id}",]
}

output "public_route_tables" {
  value = [
    "${aws_route_table.public_route_table.*.id}",]
}

output "data_route_tables" {
  value = [
    "${aws_route_table.data_route_table.*.id}",]
}
output "private_az" {
  value = "${aws_subnet.private_subnet.*.availability_zone}"
}
