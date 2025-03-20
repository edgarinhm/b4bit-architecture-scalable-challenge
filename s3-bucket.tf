resource "aws_s3_bucket" "data_lake" {
  bucket = var.aws_s3_bucket_data_lake_name
  tags = {
    Name = "Data Lake bucket"
  }
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

# Block Public Access
resource "aws_s3_bucket_public_access_block" "data_lake_block_public_access" {
  bucket = aws_s3_bucket.data_lake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
