variable "bucket_name" {
  description = "The name of the bucket"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to use."
  type        = string
  default     = "us-east-1"
}
