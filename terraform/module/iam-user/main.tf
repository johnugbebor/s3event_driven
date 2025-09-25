resource "aws_iam_user" "user" {
  name = var.user_name
}

resource "aws_iam_policy" "user_policy" {
  name        = "${var.user_name}-policy"
  description = "Policy for ${var.user_name} to access bucket ${var.bucket_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.permissions
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",      
          "arn:aws:s3:::${var.bucket_name}/*"    
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.user_policy.arn
}
