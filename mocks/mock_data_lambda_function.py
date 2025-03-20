import boto3
import json

# Initialize a Kinesis client with the boto3 library
kinesis_client = boto3.client('kinesis')

def lambda_handler(event, context):
    temperature = ... # Your code to generate the temperature reading
    data = json.dumps({'temperature': temperature})
    
    # Send the data to Kinesis
    response = kinesis_client.put_record(
        StreamName='TemperatureDataStream',
        Data=data,
        PartitionKey='partition_key'  # This can be any string like 'temp'
    )
    
    return response 