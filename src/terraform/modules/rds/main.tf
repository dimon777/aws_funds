/*
resource "aws_security_group" "rds_sec_group" {
  name = "bi-rds-sg-prod"
  description = "SG for"
  vpc_id = "vpc-01bdc04ea15b9d0d5"
}
*/

data "aws_ssm_parameter" "db_user" {
  name = "rds_master_user"
}

data "aws_ssm_parameter" "db_pass" {
  name = "rds_master_pass"
}

resource "aws_db_subnet_group" "aurora_db_prv_subnet_group" {
  name       = "aurora_db_prv_subnet_group"
  subnet_ids = var.subnet_ids
}

resource "aws_kms_key" "rds-encryption-key" {
  description         = "Aurora Encryption Key"
  is_enabled          = true
  enable_key_rotation = true
}

resource "aws_rds_cluster" "aurora_db" {
  cluster_identifier      = "${var.cluster-identifier}"
  storage_encrypted       = true
  kms_key_id              = "${aws_kms_key.rds-encryption-key.arn}"
  vpc_security_group_ids  = ["${aws_security_group.rds-allow.id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.aurora_db_prv_subnet_group.name}"
  engine                  = "${var.engine}"
  engine_version          = "${var.engine_version}"
  database_name           = "${var.db_name}"
  master_username         = "${data.aws_ssm_parameter.db_user.value}"
  master_password         = "${data.aws_ssm_parameter.db_pass.value}"
  backup_retention_period = 3
  preferred_backup_window = "05:00-07:00"
  skip_final_snapshot     = true

}

#data "aws_security_group" "lambda_sg" {
#  name = "lambda-sg"
#}

resource "aws_security_group_rule" "allow_lambda" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = "${aws_security_group.rds-allow.id}"
  source_security_group_id = var.lambda_sg #"${data.aws_security_group.lambda_sg.id}"
}

resource "aws_rds_cluster_instance" "aurora_db_cluster_instance" {
  count                = "2"
  identifier           = "${var.cluster-identifier}-${count.index}"
  cluster_identifier   = "${aws_rds_cluster.aurora_db.id}"
  db_subnet_group_name = "${aws_db_subnet_group.aurora_db_prv_subnet_group.id}"
  instance_class       = "${var.instance-class}"
  publicly_accessible  = true
  engine               = "${var.engine}"
  engine_version       = "${var.engine_version}"
}

