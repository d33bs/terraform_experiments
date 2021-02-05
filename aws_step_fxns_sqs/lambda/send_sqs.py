import logging
import os

import boto3

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

queue_name = os.getenv("queue_name")
sqs = boto3.client("sqs")


def get_queue_url(queue_name):
    # gather sqs queue url
    queue_url = sqs.get_queue_url(QueueName=queue_name).get("QueueUrl")
    logger.debug("Queue URL is %s", queue_url)
    return queue_url


def record(event, context):
    # lambda handler
    logger.debug("Recording with event %s", event)

    # commenting event data capture for demo purposes
    # data = event.get("data")

    data = "hello cloud"

    try:
        logger.debug("Recording %s", data)
        queue_url = get_queue_url(queue_name)
        logging.debug("Got queue URL %s", queue_url)
        
        resp = sqs.send_message(QueueUrl=queue_url, MessageBody=data)
        logger.debug("Send result: %s", resp)

    except Exception as e:

        raise Exception("Something terrible happened: %s" % e)