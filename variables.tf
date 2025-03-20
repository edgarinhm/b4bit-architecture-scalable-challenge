variable "aws_region" {
  description = "The AWS region to use."
  type        = string
  default     = "us-east-1"
}

variable "aws_python_version" {
  description = "The Python version to use."
  type        = string
  default     = "python3.13"
}

variable "aws_s3_bucket_data_lake_name" {
  description = "The name of the S3 bucket."
  type        = string
  default     = "data-aggregation-lake"

}
