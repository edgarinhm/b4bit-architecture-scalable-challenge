resource "aws_iam_role" "lambda_role_tf" {
  name = "lambda-role-tf"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        }, {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "lambda-role-tf"
  }
}

data "aws_iam_policy_document" "role_kinesis_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:PutRecord",
      "kms:GenerateDataKey",
    ]
    resources = [aws_kinesis_stream.temperature-data-stream-tf.arn]
  }
}

resource "aws_iam_role_policy" "role_kinesis_policy" {
  name = "lambda-kinesis-policy"
  role = aws_iam_role.lambda_role_tf.id

  policy = data.aws_iam_policy_document.role_kinesis_policy_document.json
}


data "aws_iam_policy_document" "role_dynamodb_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
      "dynamodb:ListTables"
    ]
    resources = [aws_dynamodb_table.dynamodb_data_lake.arn]
  }
}

# Policy for Lambda Task Role (Application-Level Permissions)
resource "aws_iam_role_policy" "lambda_task_policy" {
  name   = "${var.project_name}-${var.environment}-lambda-task-policy"
  role   = aws_iam_role.lambda_role_tf.id
  policy = data.aws_iam_policy_document.role_dynamodb_policy_document.json
}

resource "aws_iam_role_policy_attachment" "lambda_kms_roles" {
  role       = aws_iam_role.lambda_role_tf.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/ROSAKMSProviderPolicy"
}
