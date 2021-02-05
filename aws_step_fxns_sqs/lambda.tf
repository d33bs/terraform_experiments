
data "archive_file" "send_sqs_lambda_zip" {
  source_file  = "./lambda/send_sqs.py"
  output_path = "./lambda_zip/send_sqs_lambda.zip"
  type        = "zip"
}

resource "aws_lambda_function" "send_sqs_lambda" {
  function_name    = "${var.obj_prefix}-send"
  filename         = data.archive_file.send_sqs_lambda_zip.output_path
  source_code_hash = data.archive_file.send_sqs_lambda_zip.output_base64sha256
  handler          = "send_sqs.record"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.7"
  timeout          = 10
  lifecycle {
    create_before_destroy = true
  }
  environment {
    variables = {
      queue_name = var.obj_prefix
    }
  }
}

data "archive_file" "recv_sqs_lambda_zip" {
  source_file  = "./lambda/recv_sqs.py"
  output_path = "./lambda_zip/recv_sqs_lambda.zip"
  type        = "zip"
}

resource "aws_lambda_function" "recv_sqs_lambda" {
  function_name    = "${var.obj_prefix}-recv"
  filename         = data.archive_file.recv_sqs_lambda_zip.output_path
  source_code_hash = data.archive_file.recv_sqs_lambda_zip.output_base64sha256
  handler          = "recv_sqs.record"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.7"
  timeout          = 20
  lifecycle {
    create_before_destroy = true
  }
  environment {
    variables = {
      queue_name = var.obj_prefix
    }
  }
}