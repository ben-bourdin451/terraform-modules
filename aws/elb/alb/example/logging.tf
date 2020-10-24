resource "aws_s3_bucket" "access_logs" {
  bucket = "elb-access-logs"

  lifecycle_rule {
    id      = "Log retention"
    prefix  = local.access_logs_prefix
    enabled = true

    expiration {
      days = 7
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.bucket

  block_public_acls       = true
  block_public_policy     = true
}
