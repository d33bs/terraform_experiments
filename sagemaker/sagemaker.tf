provider "aws" {
  profile = var.awsprofile
  region  = var.region
}

resource "aws_iam_role" "role" {
  name = var.obj_prefix

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "sagemaker.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "sagemaker_s3_policy" {
  name        = "sagemaker_s3_policy"
  path        = "/"
  description = "Policy for using specific s3 bucket with Sagemaker"

  policy = file("sagemaker_s3_policy.json")
}

resource "aws_iam_role_policy_attachment" "sagemaker_s3_policy_attch" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.sagemaker_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "sagemaker_policy_attch" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_s3_bucket" "sagemaker_bucket" {
  bucket = var.obj_prefix
  force_destroy = true
}

resource "aws_s3_bucket_object" "sagemaker_data_source" {
  bucket = aws_s3_bucket.sagemaker_bucket.bucket
  key    = "sample.txt"
  source = "sample.txt"
  etag   = filemd5("sample.txt")
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "lc" {
  name      = "notebook-idle-stop"
  on_start  = filebase64("sagemaker-lifecycle_on-start.sh")
}
	
resource "aws_sagemaker_notebook_instance" "ni" {
  name          = var.obj_prefix
  role_arn      = aws_iam_role.role.arn
  instance_type = "ml.t2.medium"
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.lc.name
}