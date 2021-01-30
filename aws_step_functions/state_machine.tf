resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = var.obj_prefix
  role_arn = aws_iam_role.step_function.arn

  definition = <<EOF
{
    "Comment": "Example",
    "StartAt": "Task 1",
    "States": {
        "Task 1": {
            "Type": "Task",
            "Resource": "${aws_lambda_function.lambda.arn}",
            "Next": "Wait 3 Seconds"
        },
        "Wait 3 Seconds": {
            "Type": "Wait",
            "Seconds": 3,
            "Next": "Task 2"
        },
        "Task 2": {
            "Type": "Task",
            "Resource": "${aws_lambda_function.lambda.arn}",
            "End": true
        }
    }
}
  EOF
}