resource "aws_s3_bucket" "log_bucket" {
  bucket        = "log.www.${var.domain_name}"
  force_destroy = true

  tags = {
    project     = var.project_name
    environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "private"
}
