import json
import boto3
import os
import time

s3 = boto3.client('s3')
bucket = os.environ['BUCKET_NAME']

def lambda_handler(event, context):
    # Get the HTTP method and path
    route = event.get("rawPath", "") 
    method = event.get("requestContext", {}).get("http", {}).get("method", "")


    if route == "/dev/presigned-url" and method == "GET":
        return get_presigned_url()
    elif route == "/dev/list" and method == "GET":
        return list_voice_notes()
    else:       
        return response(404, {"error": f"Not Found. Path requested: {route}"})

def get_presigned_url():
    key = f"voice_{int(time.time())}.webm"
    url = s3.generate_presigned_url(
        'put_object',
        Params={'Bucket': bucket, 'Key': key, 'ContentType': 'audio/webm'},
        ExpiresIn=60
    )
    return response(200, {"upload_url": url})

def list_voice_notes():
    try:
        resp = s3.list_objects_v2(Bucket=bucket)
        files = resp.get("Contents", [])
        urls = []
        for obj in files:
            url = s3.generate_presigned_url(
                'get_object',
                Params={'Bucket': bucket, 'Key': obj["Key"]},
                ExpiresIn=3600
            )
            urls.append(url)
        return response(200, {"files": urls})
    except Exception as e:
        return response(500, {"error": str(e)})

def response(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET,OPTIONS",
        },
        "body": json.dumps(body)
    }