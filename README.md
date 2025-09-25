
# S3 Event-Driven Lambda Project

This project is a **serverless architecture** that utilizes **AWS Lambda** to process images uploaded to an **S3 source bucket** and save the processed images to a **destination bucket**. It also demonstrates the use of **IAM roles** and **policies** to manage access to AWS resources and ensure secure interactions between Lambda and S3.

## Overview

### Flow:
1. **Source Bucket**: Images are uploaded to the **`source-images-bucket`**.
2. **Lambda**: Lambda is triggered on new object creation in the source bucket, processes the image (e.g., removes EXIF data), and stores the processed image in the **destination bucket**.
3. **Destination Bucket**: Processed images are saved to the **`sanitized-images-bucket`**.

### Key Features:
- **Lambda** function that reads from an S3 source bucket and writes to an S3 destination bucket.
- **IAM Roles** and **Policies** to ensure **least privilege access** for Lambda and IAM users.
- **S3 Event Notification** to trigger the Lambda function when a new image is uploaded to the source bucket.

## Resources

- **Source Bucket**: `source-images-bucket`
  - **Permissions**: Read and Write access.
  - Used for storing the original images.
  
- **Destination Bucket**: `sanitized-images-bucket`
  - **Permissions**: Read-Only for IAM User B, Write-Only for Lambda.
  - Used for storing the processed images.

- **IAM Users**:
  - **User A**: Full access (read/write) to the **source bucket**.
  - **User B**: Read-only access to the **destination bucket**.

## Getting Started

### Prerequisites
- An **AWS account** with the necessary permissions to create IAM roles, S3 buckets, and Lambda functions.
- **Terraform** installed for provisioning the infrastructure.

### Setting Up the Project
1. **Clone the repository**:
   ```bash
   git clone https://github.com/johnugbebor/s3event_driven.git
   cd s3event_driven


Install dependencies (if applicable):

If you have any dependencies for the Lambda function, install them via pip or another package manager.

Ensure boto3 and pillow (if needed) are listed in the requirements.txt.

Configure AWS credentials:

Make sure your AWS CLI is configured with the necessary permissions:

aws configure


Deploy the infrastructure:

Use Terraform to deploy the necessary AWS resources (S3 buckets, Lambda, IAM roles, etc.):

terraform init
terraform plan
terraform apply (Push triggers the pipeline to build)

Lambda Trigger

The Lambda function will be triggered automatically when a new image is uploaded to source-images-bucket.

Testing the Setup

Upload an image to source-images-bucket.

Check the destination bucket (sanitized-images-bucket) for the processed image.

Monitor logs in CloudWatch to ensure Lambda is processing the image correctly.

Troubleshooting

Lambda not triggered: Check the S3 event notification setup and ensure Lambda has permission to be invoked by S3.

Permission issues: Verify that IAM policies for both Lambda and IAM users are correctly configured.

Clean Up

To delete the resources created by Terraform, run:

terraform destroy

Additional Notes:

This project can be expanded to add more complex image processing tasks.

You can configure the Lambda function to perform other actions like resizing, format conversion, etc.

Steps to Push the Project to GitHub:

Initialize your Git repository:
If you haven't done so already, initialize a new Git repository in your project folder:

git init

Add all files to the staging area:

git add .


Commit the changes:

git commit -m "Initial commit"

git push 


Summary:

This project demonstrates a simple serverless architecture with AWS Lambda triggered by S3 events to process and store images, with IAM roles and S3 bucket policies ensuring secure and efficient interactions.

