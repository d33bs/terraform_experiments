resource "aws_s3_bucket" "bucket" {
  bucket = var.obj_prefix
  force_destroy = true
}

resource "aws_s3_bucket_object" "data_targets" {
  for_each = fileset("./targets/", "*")
  bucket = aws_s3_bucket.bucket.bucket
  key    = each.value
  source = "./targets/${each.value}"
  etag   = filemd5("./targets/${each.value}")
}
