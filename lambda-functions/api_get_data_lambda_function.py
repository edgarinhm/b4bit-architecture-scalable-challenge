import json
import boto3
import os

dynamodb  = boto3.resource("dynamodb")
table_name = 'data-table-aggregation-lake'  # Replace with your table name
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    body = None
    status_code = 200
    headers = {
        "Content-Type": "application/json"
    }
    
    average_temperature: int = 0
    try:
        route_key = event["routeKey"]
        
        if route_key == "GET /api/v1/temperature":
            
            response = table.scan()
            items = response['Items']
           
            while 'LastEvaluatedKey' in response:
                response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'])
                items.extend(response['Items'])

            #extract temperature            
            for item in items:
                 average_temperature = item['average_temperature']

            message = f"Average temperature is {average_temperature}"
            body = message
        
        else:
            raise ValueError(f"Unsupported route: {route_key}")
    except Exception as e:
        status_code = 400
        body = str(e)
    finally:
        body = json.dumps(body)
    return {
        "statusCode": status_code,
        "body": body,
        "headers": headers
    }