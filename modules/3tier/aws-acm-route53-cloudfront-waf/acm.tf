terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = [var.domain_name, "www.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_acm_certificate/cert"
    owner = "ktd-admin"
  }

}

# ACM certificate validation resource using the certificate ARN and a list of validation record FQDNs.
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert-validation : record.fqdn]
  
}