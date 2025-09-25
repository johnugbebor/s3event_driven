import boto3
from PIL import Image
from io import BytesIO

s3_client = boto3.client('s3')
def lambda_handler(event, context):
    # Retrieve the S3 bucket and key from the event
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    source_key = event['Records'][0]['s3']['object']['key']

    # Download the image from S3
    response = s3_client.get_object(Bucket=source_bucket, Key=source_key)
    img_data = response['Body'].read()

    # Open the image
    img = Image.open(BytesIO(img_data))

    # Remove EXIF metadata
    img_data_cleaned = BytesIO()
    img.save(img_data_cleaned, format="JPEG", exif=None)
    img_data_cleaned.seek(0)

    # Save the sanitized image to the destination bucket
    destination_bucket = "sanitized-images-bucket"
    destination_key = source_key  # keep the same path in the destination bucket

    s3_client.put_object(
        Bucket=destination_bucket,
        Key=destination_key,
        Body=img_data_cleaned,
        ContentType='image/jpeg'
    )

    return {
        'statusCode': 200,
        'body': f"Successfully processed {source_key}"
    }
