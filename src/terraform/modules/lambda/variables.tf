variable "region" {}
variable "aws-acc-id" {}
variable "sftp-dropzone" {}
variable "datalake-s3-alias" {}
variable "datalake-s3-key" {}
variable "rds-secret" {}
variable "vpc-id" {}
variable lambda-sg {}
variable "private_subnet_ids" { type = list(string) }
variable "lambda_enabled" {}

# Schedule for each API
variable "lambda_schedule" {
  default = "cron(0/30 00 * * ? *)"
}
locals {
  env="${terraform.workspace}"
}

#variable "rparams" {type = "map" default = {"integration.request.header.X-Amz-Invocation-Type" = "'Event'"}}
#variable "mparams" {type = "map" default = {"X-Amz-Invocation-Type" = true}}
