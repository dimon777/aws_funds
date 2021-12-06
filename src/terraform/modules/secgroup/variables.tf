#variable "region" {}
variable "env" {}
variable "vpc_id" {}
variable "trusted_networks" { type = list(string) }
variable "data_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
