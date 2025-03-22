resource "aws_dynamodb_table" "dynamodb_data_lake" {
  name         = var.aws_dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.data-dynamodb-lambda-key.arn
  }

  # Store the DynamoDB items for the last 35 days.
  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = var.aws_dynamodb_table_name
  }
}

# # Data source to dynamically fetch the service name for DynamoDB
# data "aws_vpc_endpoint_service" "dynamodb" {
#   service      = "dynamodb"
#   service_type = "Gateway"
# }

# # VPC Endpoint for DynamoDB
# resource "aws_vpc_endpoint" "dynamodb" {
#   vpc_id            = aws_vpc.vpc.id
#   service_name      = data.aws_vpc_endpoint_service.dynamodb.service_name
#   vpc_endpoint_type = "Gateway"
#   route_table_ids = [
#     aws_route_table.private_route_table_az1.id,
#     aws_route_table.private_route_table_az2.id
#   ]
# }
