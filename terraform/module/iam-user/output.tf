output "user_name" {
  value = aws_iam_user.user.name
}

output "user_arn" {
  value = aws_iam_user.user.arn
}

output "user_policy_arn" {
  value = aws_iam_policy.user_policy.arn
}
