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
      "kinesis:ListStreams"
    ]
    resources = [aws_kinesis_stream.temperature-data-stream-tf.arn]
  }
}

resource "aws_iam_role_policy" "role_kinesis_policy" {
  name = "lambda-kinesis-policy"
  role = aws_iam_role.lambda_role_tf.id

  policy = data.aws_iam_policy_document.role_kinesis_policy_document.json
}
