resource "aws_s3_bucket" "data_lake" {
  bucket = var.aws_s3_bucket_data_lake_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake_encryption" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.data_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
