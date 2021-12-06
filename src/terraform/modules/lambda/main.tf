

###############################################################################
# IAM for Lambda
###############################################################################
resource "aws_iam_role" "funds-iam-for-lambda" {
  name = "funds-iam-for-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
		"lambda.amazonaws.com",
		"apigateway.amazonaws.com"
	]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Attach VPC policy for RDS
resource "aws_iam_role_policy_attachment" "rds_lambda_vpc-attch" {
  role       = "${aws_iam_role.funds-iam-for-lambda.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "funds-lambda-access" {
  name = "funds-lambda-access"
#  path = "/"
  description = "IAM policy for lambda access"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RunTask"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
	      "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
	      "s3:*"
      ],
      "Resource": [
		    "arn:aws:s3:::${var.sftp-dropzone}/*","arn:aws:s3:::${var.sftp-dropzone}"
		  ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:ListKeys",
        "kms:Encrypt",
        "kms:DescribeKey",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:DescribeKey",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*"
      ],
      "Resource": [
        "arn:aws:kms:${var.region}:${var.aws-acc-id}:alias/${var.datalake-s3-alias}",
        "arn:aws:kms:${var.region}:${var.aws-acc-id}:key/${var.datalake-s3-key}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
	      "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
	      "xray:PutTelemetryRecords",
        "xray:PutTraceSegments"
      ],
      "Resource": [
        "*"
      ]
    },
		{
      "Effect": "Allow",
      "Action": [
	       "sqs:DeleteMessage",
         "sqs:GetQueueUrl",
         "sqs:SendMessage"
      ],
      "Resource": [ "*" ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "athena:StartQueryExecution"
      ],
      "Resource": [ "*" ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "glue:GetDatabase"
      ],
      "Resource": [ "*" ]
    }

  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "funds-policy-attach-lambda_access" {
  role = "${aws_iam_role.funds-iam-for-lambda.name}"
  policy_arn = "${aws_iam_policy.funds-lambda-access.arn}"
}


#############################################################
# CloudWatch logging
#############################################################

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "funds-lambda-logging" {
  name = "funds-lambda-logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "funds-lambda-logs-attch" {
  role = "${aws_iam_role.funds-iam-for-lambda.name}"
  policy_arn = "${aws_iam_policy.funds-lambda-logging.arn}"
}

###############################################################################
# Lambda function
###############################################################################
locals {
	lambda_pkg = "../python/lambda/.bin/archive_files/system_pi.zip"
}

resource "aws_lambda_function" "system_pi" {
  filename         = "${local.lambda_pkg}"
	#source_code_hash = "${base64sha256(file("${local.lambda_pkg}"))}"
  function_name    = "system_pi"
  role             = "${aws_iam_role.funds-iam-for-lambda.arn}"
  handler          = "system_pi.api_handler"
  runtime          = "python3.6"
	timeout          = 900
  layers           = [ "arn:aws:lambda:us-west-2:470123266753:layer:python36_deps:1" ]
	vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = var.lambda-sg #["${aws_security_group.lambda-sg.id}"]
  }

  environment {
    variables = {
			API = "system_pi"
      ENV = "${local.env}"
      SFTP_BUCKET = "${var.sftp-dropzone}"
      RDS_SECRET = "${var.rds-secret}"
      LOG_LEVEL = "INFO"
    }
  }
}

/* Log */
resource "aws_cloudwatch_log_group" "funds-cw-loggroup-lambda" {
  name              = "/aws/lambda/${aws_lambda_function.system_pi.function_name}"
  retention_in_days = 30 
}


/* CW Triggers */
resource "aws_cloudwatch_event_rule" "funds-event-rule-system_pi" {
    name = "funds-event-rule-system_pi"
    description = "Fires fires everyday at 9pm UTC"
    schedule_expression = "${var.lambda_schedule}"
		is_enabled = "${var.lambda_enabled}"
}

resource "aws_cloudwatch_event_target" "funds-event-target-system_pi" {
    rule = "${aws_cloudwatch_event_rule.funds-event-rule-system_pi.name}"
    target_id = "system_pi"
    arn = "${aws_lambda_function.system_pi.arn}"
}


###############################################################################
# CW Permissions
###############################################################################
resource "aws_lambda_permission" "funds-allow-cw-system_pi" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.system_pi.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.funds-event-rule-system_pi.arn}"
}

###############################################################################
# S3 Permissions
###############################################################################
resource "aws_lambda_permission" "allow-dropzone-for-lambda" {
  statement_id  = "AllowExecOnDropZoneS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.system_pi.function_name}"
  principal     = "s3.amazonaws.com"
	source_arn    = "arn:aws:s3:::${var.sftp-dropzone}"
}



output "lambda_func" {
  value = "${aws_lambda_function.system_pi.arn}"
}
