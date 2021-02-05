resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = var.obj_prefix
  role_arn = aws_iam_role.step_function.arn

  definition = <<EOF
{
    "Comment": "Example",
    "StartAt": "Send SQS",
    "States": {
        "Send SQS": {
            "Type": "Task",
            "Resource": "${aws_lambda_function.send_sqs_lambda.arn}",
            "Next": "Wait 3 Seconds"
        },
        "Wait 3 Seconds": {
            "Type": "Wait",
            "Seconds": 3,
            "Next": "Recveive SQS"
        },
        "Recveive SQS": {
            "Type": "Task",
            "Resource": "${aws_lambda_function.recv_sqs_lambda.arn}",
            "End": true
        }
    }
}
  EOF
}