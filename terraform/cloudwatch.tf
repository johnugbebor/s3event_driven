resource "aws_s3_bucket" "source_images" {
  bucket = "source-images-bucket" 

  
  versioning {
    enabled = true
  }

  logging {
    target_bucket = "your-logs-bucket"  
    target_prefix = "s3-logs/"         
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_object_count_alarm" {
  alarm_name          = "S30ObjectCountAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "NumberOfObjects"
  namespace           = "AWS/S3"
  period              = "300"  
  statistic           = "Sum"
  threshold           = "100"  

  dimensions = {
    BucketName  = "source-images-bucket"  
    StorageType = "AllStorageTypes"
  }

  alarm_description = "Alarm when more than 100 objects are uploaded in 5 minutes"
  alarm_actions     = ["arn:aws:sns:us-east-1:123456789012:lambda-s3-alarms"] 
}

resource "aws_cloudwatch_metric_alarm" "s3_destination_object_count_alarm" {
  alarm_name          = "S3DestinationObjectCountAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "NumberOfObjects"
  namespace           = "AWS/S3"
  period              = "300"  
  statistic           = "Sum"
  threshold           = "100"  

  dimensions = {
    BucketName  = "sanitized-images-bucket" 
    StorageType = "AllStorageTypes"
  }

  alarm_description = "Alarm when more than 100 objects are uploaded in 5 minutes to the destination bucket"
  alarm_actions     = ["arn:aws:sns:us-east-1:123456789012:lambda-s3-alarms"] 
}

# SNS Topic for alarm notifications
resource "aws_sns_topic" "alarm_topic" {
  name = "lambda-s3-alarms"
}

# SNS Topic Subscription - Send notifications to your email
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = "johnugbebor@oxyhealth.com"  # Your email address
}

# CloudWatch Log Permission for Lambda
resource "aws_iam_role_policy" "lambda_cloudwatch_logs" {
  name = "lambda-cloudwatch-logs-policy"
  role = module.lambda_function.iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "logs:CreateLogGroup"
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = "logs:CreateLogStream"
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:log-group:/aws/lambda/*"
      },
      {
        Action = "logs:PutLogEvents"
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:log-stream:/aws/lambda/*"
      }
    ]
  })
}

# CloudWatch Metric for Lambda Errors
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "LambdaErrorAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60" 
  statistic           = "Sum"
  threshold           = "1"   

  dimensions = {
    FunctionName = module.lambda_function.lambda_function_name
  }

  alarm_description = "Alarm when Lambda function has errors"
  alarm_actions     = ["arn:aws:sns:us-east-1:123456789012:lambda-s3-alarms"]
}

# CloudWatch Logs for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${module.lambda_function.lambda_function_name}"
  retention_in_days = 7  
}

resource "aws_cloudwatch_log_stream" "lambda_log_stream" {
  log_group_name = aws_cloudwatch_log_group.lambda_logs.name
  name           = "log-stream"
}

# Lambda Permission to be invoked by S3
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::source-images-bucket" 
  function_name = module.lambda_function.lambda_function_name
}
