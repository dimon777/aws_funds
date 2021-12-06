locals { env="${terraform.workspace}" }

variable "region" {}
variable "additional_tags" { 
    type=map(string)
    default = {}
}
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "az_count" { default = 2 }
variable "nat_count" { default = 1 }
variable "public_subnet_cidrs" { 
    type=list(string)
    default = [] 
}
variable "public_subnet_cidr_count" { default = 0 }
variable "private_subnet_cidrs" { 
    type=list(string)
    default = [] 
}
variable "private_subnet_cidr_count" { default = 0 }
variable "data_subnet_cidrs" { 
    type=list(string)
    default = [] 
}
variable "data_subnet_cidr_count" { default = 0 }

