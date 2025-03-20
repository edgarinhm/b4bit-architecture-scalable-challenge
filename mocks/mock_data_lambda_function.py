import json
import random

def lambda_handler(event, context):
    temperature = random.uniform(20.0, 30.0)  # Random temperature between 20 and 30
    return {
        'statusCode': 200,
        'body': json.dumps({'temperature': temperature})
    } 