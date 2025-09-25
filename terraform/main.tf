module "source_bucket" {
  source      = "./modules/s3-bucket"
  bucket_name = "source-images-bucket"

  tags = {
    Environment = "dev"
    Purpose     = "source-images"
  }
}

module "destination_bucket" {
  source      = "./modules/s3-bucket"
  bucket_name = "sanitized-images-bucket"

  tags = {
    Environment = "dev"
    Purpose     = "sanitized-images"
  }
}

module "user_a" {
  source      = "./modules/iam-user"
  user_name   = "user_a"
  bucket_name = module.source_bucket.bucket_id
  permissions = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
}

module "user_b" {
  source      = "./modules/iam-user"
  user_name   = "user_b"
  bucket_name = module.destination_bucket.bucket_id
  permissions = ["s3:GetObject", "s3:ListBucket"]
}

module "lambda_function" {
  source             = "./modules/lambda"
  source_bucket      = module.source_bucket.bucket_id
  destination_bucket = module.destination_bucket.bucket_id
  lambda_bucket      = var.lambda_code_bucket
  lambda_s3_key      = "lambda_function.zip"
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = module.source_bucket.bucket_arn
  function_name = module.lambda_function.lambda_function_name
}

resource "aws_s3_bucket_notification" "image_upload_trigger" {
  bucket = module.source_bucket.bucket_id  

  lambda_function {
    events             = ["s3:ObjectCreated:*"]  
    filter_suffix      = ".jpg"  
    lambda_function_arn = module.lambda_function.lambda_function_arn 
  }

  depends_on = [aws_lambda_permission.allow_s3] 
}
