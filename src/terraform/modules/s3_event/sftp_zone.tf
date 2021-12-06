########################################################################
# DROP Zone: all notifications go here
########################################################################

resource "aws_s3_bucket_notification" "sftp-notifications" {
  bucket                = "${var.sftp-dropzone}"

  lambda_function {
		id                  = "system_pi"
    lambda_function_arn = "${var.lambda_arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "source%3Dsystem_pi/"
    filter_suffix       = ".csv"
  }

}

resource "aws_lambda_permission" "allow-dropzone-for-lambda" {
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.sftp-dropzone}"
}

