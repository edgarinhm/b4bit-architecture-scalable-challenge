provider "aws" {
  region = var.aws_region
}

# KMS key for encryption
resource "aws_kms_key" "data_key" {
  description             = "KMS key for data encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
} 
