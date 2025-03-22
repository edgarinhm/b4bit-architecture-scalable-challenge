####################### HTTP API GATEWAY #####################

resource "aws_apigatewayv2_api" "api-lambda-get-average-temperature" {
  name          = "${var.project_name}-${var.environment}-api-lambda-get-average-temperature"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "stage-lambda-get-average-temperature" {
  api_id = aws_apigatewayv2_api.api-lambda-get-average-temperature.id

  name        = var.environment
  auto_deploy = true
}

#integration
resource "aws_apigatewayv2_integration" "api-lambda-integration" {
  api_id                 = aws_apigatewayv2_api.api-lambda-get-average-temperature.id
  integration_uri        = aws_lambda_function.api-get-average-temperature-function-tf.invoke_arn
  payload_format_version = "2.0"
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
}

#route
resource "aws_apigatewayv2_route" "api-visitor-get-average-temperature-route" {
  api_id = aws_apigatewayv2_api.api-lambda-get-average-temperature.id

  route_key = "GET /api/v1/temperature"
  target    = "integrations/${aws_apigatewayv2_integration.api-lambda-integration.id}"
}

#permissions
resource "aws_lambda_permission" "apigw-lambda-permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api-get-average-temperature-function-tf.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api-lambda-get-average-temperature.execution_arn}/*/*/*"
}
