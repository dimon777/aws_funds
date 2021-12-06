##########################################################
# Main module file
##########################################################

# KMS module
module "kms" {
  source                = "./modules/kms"
}

# S3 module
module "s3" {
  source           = "./modules/s3"
  fund-perf-bucket = "${local.my-fund-perf-bucket[local.env]}"
}



module "s3_events" {
  source         = "./modules/s3_event/"
	sftp-dropzone  = "${local.sftp-dropzone}"
	lambda_arn     = "${module.lambda.lambda_func}"
}

# VPC module
module "vpc" {
  source               = "./modules/vpc/"
  region               = "${local.region}"
  vpc_name             = "${local.vpc_name}"
	vpc_cidr             = "${local.vpc_cidr}"
	public_subnet_cidrs  = "${local.public_subnet_cidrs}"
  private_subnet_cidrs = "${local.private_subnet_cidrs}"
  data_subnet_cidrs    = "${local.data_subnet_cidrs}"
}

output "vpc_module" {  
  value = module.vpc  
}

module "secgroup" {
  source                = "./modules/secgroup/"
  env                   = local.env
  vpc_id                = module.vpc.vpc_id
  trusted_networks      = var.trusted_networks
  data_subnets          = local.data_subnet_cidrs
  public_subnets        = local.public_subnet_cidrs
}

module "rds-mysql" {
  source               = "./modules/rds/"
  instance-class       = local.rds-instance-class
  cluster-identifier   = local.rds-cluster-indentifier
  vpc_id               = module.vpc.vpc_id
  lambda_sg            = module.vpc.lambda_sg
  trusted_networks     = var.trusted_networks
  subnet_ids           = module.vpc.private_subnets
}


module "sftp" {
  source                = "./modules/sftp/"
	env                   = local.env
  region                = local.region
  sftp-dropzone         = local.sftp-dropzone
	trusted_networks      = var.trusted_networks
}


module "lambda" {
  source                  = "./modules/lambda/"
  aws-acc-id              = "${local.aws-acc-id}"
  region                  = "${local.region}"
  sftp-dropzone           = "${local.sftp-dropzone}"
  datalake-s3-alias       = "${local.datalake-s3-alias}"
  datalake-s3-key         = "${local.datalake-s3-key}"
  rds-secret              = "${local.rds-secret}"
  vpc-id                  = module.vpc.vpc_id
  lambda-sg               = [module.vpc.lambda_sg]
  private_subnet_ids      = module.vpc.private_subnets
  lambda_enabled          = "${local.lambda_enabled}"
}

output "lambda_module" {  
  value = module.lambda  
}