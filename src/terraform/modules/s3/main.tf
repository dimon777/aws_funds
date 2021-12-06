
#####################################################################
# S3 module
#####################################################################
resource "aws_s3_bucket" "fund-perf-bucket" {
  bucket = var.fund-perf-bucket
  acl    = "private"

  versioning {
    enabled = true
  }

#  logging {
#    target_bucket = "${aws_s3_bucket.data-admin-log.id}"
#    target_prefix = "tfstate/"
#  }

}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.fund-perf-bucket.id

  block_public_acls   = true
  block_public_policy = true
}