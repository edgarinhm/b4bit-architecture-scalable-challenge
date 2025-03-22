import json
import boto3
import os

client = boto3.client("dynamodb")
table_name = 'data-table-aggregation-lake'  # Replace with your table name

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

            #get current average temperature
            response = client.query(
                TableName=table_name,
                Limit=15,
            )

            #extract temperature
            if "Item" in response:
                average_temperature = int(response.get('Item',{}).get('average_temperature',{}).get('N'))

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