# environment variables

variable "aws_region" {
  description = "The AWS region to use."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
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
variable "aws_dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "data-table-aggregation-lake"

}

# # vpc variables
# variable "vpc_cidr" {
#   description = "vpc cidr block"
#   type        = string
# }

# variable "public_subnet_az1_cidr" {
#   description = "public subnet az1 cidr block"
#   type        = string
# }

# variable "public_subnet_az2_cidr" {
#   description = "public subnet az2 cidr block"
#   type        = string
# }

# variable "private_app_subnet_az1_cidr" {
#   description = "private app subnet az1 cidr block"
#   type        = string
# }

# variable "private_app_subnet_az2_cidr" {
#   description = "private app subnet az2 cidr block"
#   type        = string
# }
