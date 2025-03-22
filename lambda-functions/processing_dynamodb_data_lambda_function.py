import json
import base64
import boto3

#create a dynamodb client
client = boto3.client('dynamodb')
table_name = 'data-table-aggregation-lake'  # Replace with your table name

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
    return { 'id': { 'S': record['eventID']}, 'average_temperature': { 'N': str(average_temp)} }

def lambda_handler(event, context):
    item = process_temperature_data(event['Records'])

    # write the processed average temperature data into the dynamodb table
    client.put_item(TableName=table_name, Item = item)
    
    return 'Successfully processed {} records. Average Temperature: {}'.format(len(event['Records']), item['average_temperature']['N']) 