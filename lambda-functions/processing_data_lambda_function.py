import os
import json
import base64
import boto3
import datetime

s3 = boto3.client('s3')
bucket_name =  os.environ.get("BUCKET_NAME")  # 'data-aggregation-lake'  # Replace with your bucket name

def process_temperature_data(records):
    # Calculate the average temperature from the records
    total_temp = 0
    count = 0
    for record in records:
        payload = base64.b64decode(record["kinesis"]["data"])
        data = json.loads(payload)
        total_temp += data['temperature']
        count += 1
    average_temp = total_temp / count if count else 0
    return {'average_temperature': average_temp}

def lambda_handler(event, context):
    processed_data = process_temperature_data(event['Records'])

    # Convert the processed data to JSON
    output_data = json.dumps(processed_data)

    # Generate a key for the S3 object
    key =  'processed_data/average_temperature_{date:%Y-%m-%d-%H-%M-%S}.json'.format( date=datetime.datetime.now() )

    # Put the processed average temperature data into the S3 bucket
    s3.put_object(Bucket=bucket_name, Key=key, Body=output_data)
    
    return 'Successfully processed {} records. Average Temperature: {}'.format(len(event['Records']), processed_data['average_temperature']) 