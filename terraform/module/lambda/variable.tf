variable "source_bucket" {
  description = "Source S3 bucket name"
  type        = string
}

variable "destination_bucket" {
  description = "Destination S3 bucket name"
  type        = string
}

variable "lambda_bucket" {
  description = "S3 bucket containing the Lambda zip file"
  type        = string
}

variable "lambda_s3_key" {
  description = "S3 key for the Lambda zip file"
  type        = string
}
