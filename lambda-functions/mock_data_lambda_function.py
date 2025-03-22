import boto3
import json
import random

# Initialize a Kinesis client with the boto3 library
kinesis_client = boto3.client('kinesis')

def lambda_handler(event, context):
    temperature = random.uniform(20.0, 30.0)  # Random temperature between 20 and 30
    data = json.dumps({'temperature': temperature})
    
    # Send the data to Kinesis
    response = kinesis_client.put_record(
        StreamName='TemperatureDataStream',
        Data=data,
        PartitionKey='temp_partition_key'  # This can be any string like 'temp'
    )
    
    return response 