

resource "aws_kms_key" "funds_cmk" {
  description             = "funds_cmk"
  enable_key_rotation     = true
  deletion_window_in_days = 30
}


