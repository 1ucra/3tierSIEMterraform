resource "aws_cloudfront_distribution" "cloudfront-web-elb-distribution" {
  origin {
    domain_name = var.elb_dns_name
    origin_id   = var.web_elb.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    # 사용자 정의 헤더 추가
    custom_header {
      name  = var.header_name
      value = var.header_value
    }
  }

  aliases         = [var.domain_name, "www.${var.domain_name}"]
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.web_elb.id

    min_ttl         = 0
    default_ttl     = 300
    max_ttl         = 3600

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/attendance"
    target_origin_id = var.web_elb.id

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  web_acl_id = aws_wafv2_web_acl.waf.arn

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_cloudfront_distribution/cloudfront-web-elb-distribution"
    owner = "ktd-admin"
  }

  depends_on = [aws_acm_certificate_validation.cert]
}
