# S3 Bucket Outputs
output "source_bucket_id" {
  value = module.source_bucket.bucket_id
}

output "source_bucket_arn" {
  value = module.source_bucket.bucket_arn
}

output "destination_bucket_id" {
  value = module.destination_bucket.bucket_id
}

output "destination_bucket_arn" {
  value = module.destination_bucket.bucket_arn
}

# IAM User Outputs
output "user_a_name" {
  value = module.user_a.user_name
}

output "user_a_arn" {
  value = module.user_a.user_arn
}

output "user_b_name" {
  value = module.user_b.user_name
}

output "user_b_arn" {
  value = module.user_b.user_arn
}

# Lambda Outputs
output "lambda_function_arn" {
  value = module.lambda_function.lambda_function_arn
}

output "lambda_role_arn" {
  value = module.lambda_function.lambda_role_arn
}
