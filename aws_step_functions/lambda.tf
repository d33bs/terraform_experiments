
resource "aws_lambda_function" "lambda" {
  function_name    = var.obj_prefix
  filename         = data.archive_file.lambda_zip_file.output_path
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  handler          = "example.handler"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.7"
  lifecycle {
    create_before_destroy = true
  }
}

data "archive_file" "lambda_zip_file" {
  source_dir  = "./lambda"
  output_path = "./lambda_zip/lambda.zip"
  excludes    = ["__init__.py", "*.pyc"]
  type        = "zip"
}