data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/mock_data_lambda_function.py"
  output_path = "${path.module}/mock_data_lambda_function.zip"
}

resource "aws_lambda_function" "data-generator-function" {
  function_name    = "DataGeneratorFunction"
  runtime          = var.aws_python_version
  handler          = "mock_data_lambda_function.lambda_handler"
  role             = aws_iam_role.lambda_role_tf.arn
  timeout          = 300
  memory_size      = 128
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  filename         = data.archive_file.python_lambda_package.output_path
  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data-generator-function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.data-generator-lambda-event.arn
}

resource "aws_cloudwatch_event_rule" "data-generator-lambda-event" {
  name                = "run-lambda-function"
  description         = "Schedule lambda function"
  schedule_expression = "rate(2 minutes)"
}

resource "aws_cloudwatch_event_target" "data-generator-lambda-function-target" {
  target_id = "lambda-function-target"
  rule      = aws_cloudwatch_event_rule.data-generator-lambda-event.name
  arn       = aws_lambda_function.data-generator-function.arn
}

resource "aws_lambda_event_source_mapping" "kinesis-data-stream-event-source-tf" {
  event_source_arn  = aws_kinesis_stream.temperature-data-stream-tf.arn
  function_name     = aws_lambda_function.data-generator-function.arn
  starting_position = "LATEST"
  batch_size        = 100
}


#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "lambda-data-generator-temperature-log-group" {
  name              = "/aws/lambda/${aws_lambda_function.data-generator-function.function_name}"
  retention_in_days = 30
  lifecycle {
    prevent_destroy = false
  }
}
