data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.module}/mocks/mock_data_lambda_function.py"
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
