# Lambda Bucket
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.s3_bucket_prefix}-lambda-bucket"
  tags = merge(local.tags, {
    access = "private"
  })


}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket                  = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Log Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.s3_bucket_prefix}-log-bucket"
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}
