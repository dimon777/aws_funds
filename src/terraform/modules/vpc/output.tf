# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------
output "all_azs" {
  value = ["${data.aws_availability_zones.all_azs.names}"]
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_cidr"{
  value = "${aws_vpc.main.cidr_block}"
}

output "internet_gateway" {
  value = "${aws_internet_gateway.int_gw.id}"
}

output "private_gateway" {
  value = "${aws_vpn_gateway.private_gateway.id}"
}


output "selected_azs" {
  value = [
    "${data.aws_availability_zones.all_azs.names[0]}",
    "${data.aws_availability_zones.all_azs.names[1]}"
  ]
}


# ---------------------------------------------------------------------------------------------------------------------
# Public
# ---------------------------------------------------------------------------------------------------------------------
output "public_subnets" {
  value = [ "${aws_subnet.public_subnet.*.id}"]
}

output "nat_gateway" {
  value = "${aws_nat_gateway.nat_gw.*.id}"
}

output "public_az" {
  value = "${aws_subnet.public_subnet.*.availability_zone}"
}
