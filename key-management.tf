# KMS key for encryption
resource "aws_kms_key" "data_key" {
  description             = "KMS key for data encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_key" "data-kinesis-lambda-key" {
  description             = "KMS key for data kinesis lambda encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

