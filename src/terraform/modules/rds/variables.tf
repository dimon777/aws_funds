variable vpc_id {}
variable lambda_sg {}
variable cluster-identifier {}
variable instance-class {}
variable engine { default = "aurora-mysql" }
variable engine_version { default = "5.7.12" }
variable db_name { default = "funds" }

variable subnet_ids { type = list(string) }

variable "trusted_networks" { type = list(string) }

