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
        }, {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "lambda-role-tf"
  }
}

resource "aws_iam_role_policy" "role_kinesis_policy" {
  name = "lambda-kinesis-policy"
  role = aws_iam_role.lambda_role_tf.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:ListShards",
          "kinesis:ListStreams",
        ]
        Resource = [
          "${aws_kinesis_stream.temperature-data-stream-tf.arn}"
        ]
      }
    ]
  })
}
