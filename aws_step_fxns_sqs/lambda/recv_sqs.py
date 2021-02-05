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

    try:
        queue_url = get_queue_url(queue_name)
        logging.debug("Got queue URL %s", queue_url)

        resp = sqs.receive_message(
            QueueUrl=queue_url, MaxNumberOfMessages=1, WaitTimeSeconds=15
        )
        logger.debug("Receive result: %s", resp)

    except Exception as e:

        raise Exception("Something terrible happened: %s" % e)  