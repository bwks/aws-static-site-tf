resource "aws_cloudfront_origin_access_control" "web_bucket_access_policy" {
  name                              = "allow_to_s3_from_cloud_front"
  description                       = "Allows access to an S3 web bucket from CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "web_distribution" {
  origin {
    domain_name              = aws_s3_bucket.web_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.web_bucket_access_policy.id
    origin_id                = aws_s3_bucket.web_bucket.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for our Website"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "log.www.${var.domain_name}.net.s3.amazonaws.com"
  }

  aliases = [var.domain_name, "www.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.web_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      # locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"

  }

  tags = {
    project     = var.project_name
    environment = var.environment
  }

}
