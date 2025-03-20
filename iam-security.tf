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
      }
    ]
  })

  tags = {
    Name = "lambda-role-tf"
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "processing-data-lambda-policy"
  role = aws_iam_role.lambda_role_tf.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "${aws_s3_bucket.data_lake.arn}",
          "arn:aws:logs:*:*:*"
        ]
      }
    ]
  })
}
