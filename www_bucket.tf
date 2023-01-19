resource "aws_s3_bucket" "web_bucket" {
  bucket = "www.${var.domain_name}"

  tags = {
    project     = var.project_name
    environment = var.environment
  }
}

resource "aws_s3_bucket_website_configuration" "web_bucket_config" {
  bucket = aws_s3_bucket.web_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_object" "site" {
  bucket       = aws_s3_bucket.web_bucket.bucket
  for_each     = fileset("./_site/", "**")
  key          = each.value
  source       = "./_site/${each.value}"
  content_type = "text/html"
  etag         = filemd5("./_site/${each.value}")
}

resource "aws_s3_bucket_acl" "web_bucket_acl" {
  bucket = aws_s3_bucket.web_bucket.id
  acl    = "private"
}

data "aws_iam_policy_document" "allow_access_from_cloud_front" {
  version = "2012-10-17"

  statement {
    sid = "PolicyForCloudFrontPrivateContent"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.web_bucket.arn}/*",
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.web_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloud_front" {
  bucket = aws_s3_bucket.web_bucket.bucket
  policy = data.aws_iam_policy_document.allow_access_from_cloud_front.json
}
