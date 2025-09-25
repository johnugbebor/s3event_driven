variable "user_name" {
  description = "IAM user name"
  type        = string
}

variable "bucket_name" {
  description = "Bucket name the user will have access to"
  type        = string
}

variable "permissions" {
  description = "List of S3 permissions for the user"
  type        = list(string)
}
