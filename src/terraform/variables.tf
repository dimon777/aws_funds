#variable "region" {
# description = "AWS Region where environment will be deployed"
#}
variable "trusted_networks" {
  default = ["0.0.0.0/0", "32.209.63.198/32", "175.1.14.0/25","175.1.14.128/25"]
}

locals {
  env="${terraform.workspace}" # this is taken from AWS_PROFILE

###############################################################################
# Environmnet artifacts
###############################################################################
  my-aws-acc-id = {
    aws-dev  = "470123266753"
    aws-test = ""
    aws-prod = ""
  }
  aws-acc-id = "${local.my-aws-acc-id[local.env]}"

  my-region = {
    aws-dev  = "us-west-2"
    aws-test = "us-west-2"
    aws-prod = "us-west-2"
  }
  region = "${local.my-region[local.env]}"

  my-ev = {
    aws-dev = "sand"
    aws-test = "test"
    aws-prod = "prod"
  }
  ev = "${local.my-ev[local.env]}"

###############################################################################
# RDS artifacts
###############################################################################
  my-rds-instance-class = {
    aws-dev   = "db.r4.large"
    aws-test  = "db.r4.large"
    aws-prod  = "db.r4.large"
  }
  rds-instance-class = "${local.my-rds-instance-class[local.env]}"

  my-rds-cluster-indentifier = {
    aws-dev  = "rds-cluster-dev"
    aws-test  = "rds-cluster-test"
    aws-prod  = "rds-cluster-prod"
  }
  rds-cluster-indentifier = "${local.my-rds-cluster-indentifier[local.env]}"

  my-rds-sec-group = {
    aws-dev  = "rds-sg-dev"
    aws-test  = "rds-sg-test"
  }


###############################################################################
# S3 artifacts
###############################################################################


  my-sftp-dropzone = {
    aws-dev   = "dev.sftp.fundsperf"
    aws-test  = "test.sftp.fundsperf"
    aws-prod  = "prod.sftp.fundsperf"
  }
  sftp-dropzone = "${local.my-sftp-dropzone[local.env]}"

  my-fund-perf-bucket = {
    aws-dev    = "dev.fundsperf"
    aws-test   = "test.fundsperf"
    aws-prod   = "prod.fundsperf"
  }



###############################################################################
# KMS artifacts
###############################################################################
  my-datalake-s3-alias = {
    aws-dev = "datalake-sandbox-s3-key"
    aws-test = "datalake-test-s3-key"
  }
  datalake-s3-alias = "${local.my-datalake-s3-alias[local.env]}"

  my-datalake-s3-key = {
    aws-dev  = "d8636f1e-504b-4cb0-a33f-460a44abf387"
    aws-test = "fbf63dcc-567d-11ec-bf63-0242ac130002"
    aws-prod = "b72e9ce3-b729-40ae-b70e-c1b1dae6c22f"
  }
  datalake-s3-key = "${local.my-datalake-s3-key[local.env]}"

###############################################################################
# Secrets artifacts
###############################################################################
  my-rds-secret = {
    aws-dev = "dev/rds/creds2"
    aws-test = "test/rds/creds2"
    aws-prod = ""
  }
  rds-secret = "${local.my-rds-secret[local.env]}"


###############################################################################
# Statically coded resources until TF codebase is unified
###############################################################################

#########################################
# VPC
#########################################
  my-vpc_name = {
    aws-dev = "funds-dev"
    aws-test = "funds-test"
    aws-prod = "funds-prod"
  }
  vpc_name = "${local.my-vpc_name[local.env]}"


  my-vpc_cidr = {
     aws-dev    = "175.1.0.0/16"
     aws-test    = "175.2.0.0/16"
     aws-prod    = "175.3.0.0/16"
  }
  vpc_cidr = "${local.my-vpc_cidr[local.env]}"

  my-public_subnet_cidrs = {
     aws-dev  = ["175.1.1.0/26","175.1.2.0/26"]
     aws-test = ["175.2.1.0/26","175.2.2.0/26"]
     aws-prod = ["175.3.1.0/26","175.3.2.0/26"]
  }
  public_subnet_cidrs = "${local.my-public_subnet_cidrs[local.env]}"

  my-public_subnet_ids = {
     aws-dev     = ["subnet-pub-dev1", "subnet-pub-dev2"]
     aws-test    = ["subnet-pub-test1", "subnet-pub-test2"]
     aws-prod    = ["subnet-pub-prod1", "subnet-pub-prod2"]
  }
  public_subnet_ids = "${local.my-public_subnet_ids[local.env]}"

  my-private_subnet_cidrs = {
     aws-dev  = ["175.1.14.0/25","175.1.14.128/25"]
     aws-test = ["175.2.14.0/25","175.2.14.128/25"]
     aws-prod = ["175.3.14.0/25","175.3.14.128/25"]
  }
  private_subnet_cidrs = "${local.my-private_subnet_cidrs[local.env]}"

  my-private_subnet_ids = {
     aws-dev     = ["subnet-pri-dev1", "subnet-pri-dev2"]
     aws-test    = ["subnet-pri-test1", "subnet-pri-test2"]
     aws-prod    = ["subnet-pri-prod1", "subnet-pri-prod2"]
  }
  private_subnet_ids = "${local.my-private_subnet_ids[local.env]}"

	my-data_subnet_ids = {
     aws-dev     = ["subnet-dat-dev1", "subnet-dat-dev2"]
     aws-test    = ["subnet-dat-test1", "subnet-dat-test2"]
     aws-prod    = ["subnet-dat-prod1", "subnet-dat-prod2"]
  }
  data_subnet_ids = "${local.my-data_subnet_ids[local.env]}"


  my-data_subnet_cidrs = {
     aws-dev  = ["175.1.64.0/26","175.1.64.128/26"]
     aws-test = ["175.2.64.0/26","175.2.64.128/26"]
     aws-prod = ["175.3.64.0/26","175.3.64.128/26"]
  }
  data_subnet_cidrs = "${local.my-data_subnet_cidrs[local.env]}"


#################################################
# Enable Triggers per Env
#################################################
  my-lambda_enabled = {
    aws-dev = false
    aws-test = false
    aws-prod = true
  }

  lambda_enabled = "${local.my-lambda_enabled[local.env]}"

}
