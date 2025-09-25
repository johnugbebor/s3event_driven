variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "lambda_code_bucket" {
  description = "S3 bucket where Lambda zip code will be stored"
  type        = string
  default     = "lambda-code-bucket"
}
