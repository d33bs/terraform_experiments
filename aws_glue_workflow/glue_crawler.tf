provider "aws" {
  profile = var.awsprofile
  region  = var.region
}

resource "aws_iam_role" "glue_role" {
  name = var.obj_prefix
  assume_role_policy = file("glue_role.json")
}

resource "aws_iam_policy" "glue_policy" {
  name        = var.obj_prefix
  path        = "/"
  policy = file("glue_policy.json")
}

resource "aws_iam_role_policy_attachment" "glue_policy_attch" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}

resource "aws_s3_bucket" "glue_data_bucket" {
  bucket = "${var.obj_prefix}-data"
  force_destroy = true
}

resource "aws_s3_bucket_object" "glue_data_source" {
  bucket = aws_s3_bucket.glue_data_bucket.bucket
  key    = "iris.parquet"
  source = "iris.parquet"
  etag   = filemd5("iris.parquet")
}

resource "aws_s3_bucket" "glue_code_bucket" {
  bucket = "${var.obj_prefix}-code"
  force_destroy = true
}

resource "aws_s3_bucket_object" "glue_code_part1" {
  bucket = aws_s3_bucket.glue_code_bucket.bucket
  key    = "glue_job_iris_part1.py"
  source = "glue_job_iris_part1.py"
  etag   = filemd5("glue_job_iris_part1.py")
}

resource "aws_s3_bucket_object" "glue_code_part2" {
  bucket = aws_s3_bucket.glue_code_bucket.bucket
  key    = "glue_job_iris_part2.py"
  source = "glue_job_iris_part2.py"
  etag   = filemd5("glue_job_iris_part2.py")
}

resource "aws_glue_catalog_database" "glue_catalog_db" {
  name = var.obj_prefix
}

resource "aws_glue_crawler" "glue_crawler" {
  name = var.obj_prefix
  database_name = aws_glue_catalog_database.glue_catalog_db.name
  role = aws_iam_role.glue_role.arn
  schedule = "cron(0 0 * * ? *)"
  configuration = file("glue_crawler_config.json")
  schema_change_policy {
    delete_behavior = "DELETE_FROM_DATABASE"
  }
  s3_target {
    path = "s3://${aws_s3_bucket.glue_data_bucket.bucket}/"
  }
}

