resource "aws_subnet" "data_subnet" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = coalesce(var.data_subnet_cidrs[count.index],cidrsubnet(var.vpc_cidr, 8, 2))
  availability_zone = "${element(data.aws_availability_zones.all_azs.names,count.index)}"
  tags = merge(var.additional_tags, tomap({Name = "Data-${count.index}"}))
  count = "${var.az_count}"
}

resource "aws_route_table" "data_route_table" {
  vpc_id = "${aws_vpc.main.id}"
  tags = merge(var.additional_tags, tomap({Name = "Data"}))
}

resource "aws_route_table_association" "data_route_table_assoc" {
  subnet_id      = "${element(aws_subnet.data_subnet.*.id,count.index)}"
  route_table_id = "${element(aws_route_table.data_route_table.*.id,count.index)}"
  count = "${var.az_count}"
}

resource "aws_network_acl" "data_nacl" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_subnet.data_subnet]

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "deny"
    cidr_block = "${aws_subnet.public_subnet.0.cidr_block}"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "deny"
    cidr_block = "${aws_subnet.public_subnet.1.cidr_block}"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "deny"
    cidr_block = "${aws_subnet.public_subnet.0.cidr_block}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "deny"
    cidr_block = "${aws_subnet.public_subnet.1.cidr_block}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.additional_tags, tomap({Name = "DataNacl-${var.vpc_name}"}))
}


output "data_subnets" {
  value = aws_subnet.data_subnet.*.id
}

output "data_az" {
  value = "${aws_subnet.data_subnet.*.availability_zone}"
}

