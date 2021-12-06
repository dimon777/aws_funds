
variable "region" {
  default = {
    aws-dev  = "us-west-2"
    aws-test  = "us-west-2"
    aws-prod  = "us-west-2"
  }
}

provider "aws" {
  region      = "${var.region[terraform.workspace]}"
  #assume_role = {
  #  role_arn  = "${var.workspace_iam_roles[terraform.workspace]}"
  #}
}

terraform {
  backend "local" {
    #path = "relative/path/to/terraform.tfstate"
  }
}
