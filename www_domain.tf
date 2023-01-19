# Get data for the pre-purchased domain.
data "aws_route53_zone" "domain" {
  name = var.domain_name
}

locals {
  record_types = toset(["A", "AAAA"])
}

resource "aws_route53_record" "bare_record" {
  zone_id  = data.aws_route53_zone.domain.zone_id
  name     = var.domain_name
  for_each = local.record_types
  type     = each.value

  alias {
    name                   = aws_cloudfront_distribution.web_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.web_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_record" {
  zone_id  = data.aws_route53_zone.domain.zone_id
  name     = "www.${var.domain_name}"
  for_each = local.record_types
  type     = each.value

  alias {
    name                   = aws_cloudfront_distribution.web_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.web_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
