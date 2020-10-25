resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "${module.origin.site_bucket}.s3.amazonaws.com"
    origin_id   = "originS3"
  }

  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2"
  comment         = "${var.project} (${var.environment})"

  price_class = var.cloudfront_price_class
  aliases     = ["data.${var.r53_public_hosted_zone}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "originS3"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    # Only applies if the origin adds Cache-Control headers. The CloudFront
    # default is also 0.
    min_ttl = 0

    # One week, and only applies when the origin DOES NOT supply
    # Cache-Control headers.
    default_ttl = 604800

    # Only applies if the origin adds Cache-Control headers. The CloudFront
    # default is also 31536000 (one year).
    max_ttl = 31536000
  }

  logging_config {
    include_cookies = false
    bucket          = "${module.origin.logs_bucket}.s3.amazonaws.com"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = module.cert.arn
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
  }

  tags = {
    Project     = var.project,
    Environment = var.environment
  }
}
