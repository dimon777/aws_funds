data "aws_availability_zones" "all_azs" {}

resource "aws_vpc" "main" {
    cidr_block           = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"
    tags                 = merge(var.additional_tags, tomap({Name = var.vpc_name}))
}

resource "aws_internet_gateway" "int_gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = merge(var.additional_tags, tomap({Name = var.vpc_name}))
}


resource "aws_vpn_gateway" "private_gateway" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = merge(var.additional_tags, tomap({Name = "PrivateGateway-${var.vpc_name}"}))
}




