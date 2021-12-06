# Separate roles for each SFTP client

#####################################################################
# S3 bucket for storage
#####################################################################
resource "aws_s3_bucket" "sftp-dropzone" {
  bucket = "${var.sftp-dropzone}"
  acl    = "private"

  versioning {
    enabled = true
  }

}

#####################################################################
# IAM role for access 
#####################################################################
resource "aws_iam_role" "sftp-role" {
    name = "sftp-role"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}



#####################################################################
# CloudWatch logging for SFTP service
#####################################################################
resource "aws_iam_role_policy" "sftp-logging-policy" {
    name = "sftp-logging-policy"
    role = "${aws_iam_role.sftp-role.id}"
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "AllowFullAccesstoCloudWatchLogs",
        "Effect": "Allow",
        "Action": [
		  "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
        }
    ]
}
POLICY
}

#####################################################################
# SFTP service 
#####################################################################
resource "aws_transfer_server" "sftp-server" {
  logging_role = "${aws_iam_role.sftp-role.arn}"
  # (resource arguments)
}


#####################################################################
# SFTP testuser
#####################################################################
resource "aws_iam_role" "sftp-testuser-role" {
	name = "sftp-testuser-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

# note s3:ListBucket is needed otherwise user won't be able to do `ls` in its home folder.
resource "aws_iam_role_policy" "sftp-testuser-rp" {
    name = "sftp-testuser-rp"
    role = "${aws_iam_role.sftp-testuser-role.id}"
		#"s3:ListBucket"
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": [
					"s3:GetObject", "s3:GetObjectAcl", "s3:PutObject", "s3:PutObjectAcl", "s3:DeleteObject"
        ],
        "Resource": "arn:aws:s3:::${var.sftp-dropzone}/testuser/*"
        },
				{
        "Effect": "Allow",
        "Action": [
            "s3:ListBucket"
        ],
        "Resource": "arn:aws:s3:::${var.sftp-dropzone}"
        }
    ]
}
POLICY
}

resource "aws_transfer_user" "testuser" {
    server_id      = "${aws_transfer_server.sftp-server.id}"
    user_name      = "testuser"
    role           = "${aws_iam_role.sftp-testuser-role.arn}"
		home_directory = "/${var.sftp-dropzone}/testuser"
}

resource "aws_transfer_ssh_key" "testuser-key" {
    server_id = "${aws_transfer_server.sftp-server.id}"
    user_name = "${aws_transfer_user.testuser.user_name}"
    body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWGPrvfDPN/6gFrnH8H3CEhFwfdLlxqwAq0hJzYAGAfqTBQa2fsiCaNLUGpaApLbdLcsnRlTo30w0SewUilQrL/48jUUidNxtZyzcRwEJd+q4hS5n7U0v5asuBZGxBuSMtUD4ccbIi3FZpMpzgm2Nf5mOLq5JiqD6e0CGIaFHdN/AlIT4PoxYOe5hai5qCSxHfqR+lbepWf8Iilrlx98cPds3Nrmh7VHyQgroQ4dvyTbbqqjSbjhf+k1gxA+O7OZbGZsdxdf+fdETeysdsrqu6O2BTdPJcO3IFAwTvBgzqLGep37jRGAN8DeKuAnybDK4ALB726JbX+bapaLLMgI4z testuser@BUZOLIND-NYL0"
}

resource "aws_s3_bucket_object" "testuser_dev" {
    bucket = "${aws_s3_bucket.sftp-dropzone.id}"
    acl    = "private"
    key    = "testuser/dev/"
    source = "nul"
}

resource "aws_s3_bucket_object" "testuser_incoming" {
    bucket = "${aws_s3_bucket.sftp-dropzone.id}"
    acl    = "private"
    key    = "testuser/incoming/"
    source = "nul"
}
