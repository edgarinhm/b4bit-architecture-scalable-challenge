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

#Enable versioning
resource "aws_s3_bucket_versioning" "data_lake_versioning" {
  bucket = aws_s3_bucket.data_lake.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "data_lake_log" {
  bucket = "${var.aws_s3_bucket_data_lake_name}-log-${random_string.suffix.result}"
  tags = {
    Name = "Log bucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_encryption" {
  bucket = aws_s3_bucket.data_lake_log.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "arn"
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_logging" "data_lake_logging" {
  bucket = aws_s3_bucket.data_lake.id

  target_bucket = aws_s3_bucket.data_lake_log.id
  target_prefix = "log/"
}

#Enable versioning
resource "aws_s3_bucket_versioning" "data_lake_log_versioning" {
  bucket = aws_s3_bucket.data_lake_log.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "data_lake_logs_block_public_access" {
  bucket = aws_s3_bucket.data_lake_log.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
