resource "aws_iam_role" "lambda_role" {
  name = "lambda-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-s3-policy"
  description = "Lambda policy for accessing S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:PutObject"]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.source_bucket}/*",
          "arn:aws:s3:::${var.destination_bucket}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "exif_removal" {
  function_name = "exif-removal-lambda"

  s3_bucket = var.lambda_bucket
  s3_key    = var.lambda_s3_key

  handler = "exif_cleaner.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      SOURCE_BUCKET      = var.source_bucket
      DESTINATION_BUCKET = var.destination_bucket
    }
  }

  timeout     = 60
  memory_size = 512
}




