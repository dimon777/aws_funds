# Below SG are assigned to resources in public subnet
resource "aws_security_group" "winrm-allow" {
  name        = "winrm-allow"
  description = "Allow access over WinRM for remote management."
	vpc_id = "${var.vpc_id}"

  # WinRM access from anywhere.
  ingress {
    from_port   = 3389 
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = "${var.trusted_networks}"
  }

  # Outbound internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Below SG are assigned to resources in data subnet
resource "aws_security_group" "rdp-data-subnet-allow" {
  name        = "rdp-data-subnet-allow"
  description = "Allow access over WinRM and SQL Server from bastion to data netowrk"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = "${var.public_subnets}"
  }

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = "${var.public_subnets}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.data_subnets}"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.data_subnets}"
  }
}

