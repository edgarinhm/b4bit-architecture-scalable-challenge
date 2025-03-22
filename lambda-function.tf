data "archive_file" "python_processing_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/processing_data_lambda_function.py"
  output_path = "${path.module}/processing_data_lambda_function.zip"
}

resource "aws_lambda_function" "data-processing-function-tf" {
  function_name    = "DataProcessingFunction"
  runtime          = var.aws_python_version
  handler          = "processing_data_lambda_function.lambda_handler"
  role             = aws_iam_role.lambda_role_tf.arn
  timeout          = 300
  memory_size      = 128
  source_code_hash = data.archive_file.python_processing_lambda_package.output_base64sha256
  filename         = data.archive_file.python_processing_lambda_package.output_path
  s3_bucket        = aws_s3_bucket.data_lake.bucket
  s3_key           = "processing_data_lambda_function.zip"

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      KINESIS_STREAM_NAME = aws_kinesis_stream.temperature-data-stream-tf.name
      BUCKET_NAME         = aws_s3_bucket.data_lake.id
    }
  }

}

resource "aws_lambda_event_source_mapping" "kinesis-processing-data-stream-event-source-tf" {
  event_source_arn  = aws_kinesis_stream.temperature-data-stream-tf.arn
  function_name     = aws_lambda_function.data-processing-function-tf.arn
  starting_position = "LATEST"
  batch_size        = 100
}

#defines a log group to store log messages from your Lambda function for 30 days. By convention, Lambda stores logs in a group with the name /aws/lambda/<Function Name>.
resource "aws_cloudwatch_log_group" "lambda-s3-processing-log-group" {
  name = "/aws/lambda/${aws_lambda_function.data-processing-function-tf.function_name}"

  retention_in_days = 30
  kms_key_id        = aws_kms_key.lambda_log_group_kms_key.arn
}

#Lambda function to store dynamodb data
data "archive_file" "python_processing_dynamodb_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/processing_dynamodb_data_lambda_function.py"
  output_path = "${path.module}/processing_dynamodb_data_lambda_function.zip"
}

resource "aws_lambda_function" "data-processing-dynamodb-function-tf" {
  function_name    = "DataProcessingDynamodbFunction"
  runtime          = var.aws_python_version
  handler          = "processing_dynamodb_data_lambda_function.lambda_handler"
  role             = aws_iam_role.lambda_role_tf.arn
  timeout          = 300
  memory_size      = 128
  source_code_hash = data.archive_file.python_processing_dynamodb_lambda_package.output_base64sha256
  filename         = data.archive_file.python_processing_dynamodb_lambda_package.output_path
  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      KINESIS_STREAM_NAME = aws_kinesis_stream.temperature-data-stream-tf.name
      dynamodb_table_name = aws_dynamodb_table.dynamodb_data_lake.name
    }
  }
}

resource "aws_lambda_event_source_mapping" "kinesis-processing-dynamodb-data-stream-event-source-tf" {
  event_source_arn  = aws_kinesis_stream.temperature-data-stream-tf.arn
  function_name     = aws_lambda_function.data-processing-dynamodb-function-tf.arn
  starting_position = "LATEST"
  batch_size        = 100

}

resource "aws_cloudwatch_log_group" "lambda-dynamodb-processing-log-group" {
  name = "/aws/lambda/${aws_lambda_function.data-processing-dynamodb-function-tf.function_name}"

  retention_in_days = 30
  kms_key_id        = aws_kms_key.lambda_log_group_kms_key.arn
}
