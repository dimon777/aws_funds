variable "env" {}
variable "region" {}
variable "sftp-dropzone" {}
variable "trusted_networks" { type = list(string) }

locals {
  env="${terraform.workspace}"
}
