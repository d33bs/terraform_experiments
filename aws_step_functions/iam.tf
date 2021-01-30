
resource "aws_iam_role" "lambda" {
  name               = "${var.obj_prefix}-lambda"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": "LambdaAssumeRole"
      }
    ]
  }
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "step_function" {
  name               = "${var.obj_prefix}-step-fxn"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "states.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": "StepFunctionAssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "step_function_policy" {
  name    = "${var.obj_prefix}-step-fxn-policy"
  role    = aws_iam_role.step_function.id

  policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Effect": "Allow",
        "Resource": "${aws_lambda_function.lambda.arn}"
      }
    ]
  }
  EOF
}