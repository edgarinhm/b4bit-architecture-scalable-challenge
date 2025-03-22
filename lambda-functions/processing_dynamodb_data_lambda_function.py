import json
import base64
import boto3

#create a dynamodb client
dynamodb = boto3.client('dynamodb')
table_name = 'data-table-aggregation-lake'  # Replace with your bucket name

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
    return {'average_temperature': average_temp, 'id': record['eventID']}

def lambda_handler(event, context):
    processed_data = process_temperature_data(event['Records'])
    #create table object
    table = dynamodb.Table(table_name)

    # Convert the processed data to JSON
    output_data = json.dumps(processed_data)

    # write the processed average temperature data into the dynamodb table
    table.put_item(Item = output_data)
    
    return 'Successfully processed {} records. Average Temperature: {}'.format(len(event['Records']), processed_data['average_temperature']) 