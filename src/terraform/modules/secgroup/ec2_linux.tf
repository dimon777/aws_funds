resource "aws_security_group" "ec2-ssh-allow" {
# better way to manage lifecycle:  name_prefix = "sg-"
  name          = "ec2-ssh-allow"
  description   = "allow-ssh-acess" #"allow connections from internal networks"
  vpc_id        = "${var.vpc_id}" #"${aws_vpc.main.id}"

  ingress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    self            = true
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = "${var.trusted_networks}"
#    security_groups = ["${aws_security_group.test-instance.id}"] # allowing access from test instance
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
#    self = true
  }

}



resource "aws_security_group" "ec2-instance-all" {
  name          = "ec2-instance-all"
  description   = "allow-acess" #"allow connections from internal networks"
  vpc_id        = "${var.vpc_id}" #"${aws_vpc.main.id}"

  ingress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    self            = true
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = "${var.trusted_networks}"
#    security_groups = ["${aws_security_group.test-instance.id}"] # allowing access from test instance
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = "${var.trusted_networks}"
#    security_groups = ["${aws_security_group.test-instance.id}"] # allowing access from test instance
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = "${var.trusted_networks}"
#    security_groups = ["${aws_security_group.test-instance.id}"] # allowing access from test instance
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = "${var.public_subnets}"
#    security_groups = ["${aws_security_group.test-instance.id}"] # allowing access from test instance
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
#    self = true
  }

}

