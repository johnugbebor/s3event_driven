output "lambda_function_arn" {
  value = aws_lambda_function.exif_removal.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}
