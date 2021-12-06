resource "aws_security_group" "lambda-sg" {
  name          = "lambda-sg"
  description   = "Lambda secgroup"
  vpc_id        = aws_vpc.main.id #var.vpc-id

#  ingress {
#    protocol    = -1
#    from_port   = 0
#    to_port     = 0
#    cidr_blocks = ["0.0.0.0/0"]
#    self = true
#  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
#    self = true
  }

}

output "lambda_sg" {
  value = "${aws_security_group.lambda-sg.id}"
}