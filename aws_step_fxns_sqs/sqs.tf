resource "aws_sqs_queue" "queue" {
  name                      = var.obj_prefix
  max_message_size          = 2048
  message_retention_seconds = 86400
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter_queue.arn
    maxReceiveCount     = 1
  })
}

resource "aws_sqs_queue" "deadletter_queue" {
  name                      = "${var.obj_prefix}-deadletter"
  max_message_size          = 2048
  message_retention_seconds = 86400
}