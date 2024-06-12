# We have created one rule where any user if try to access our Application through TOR browser or any VPN, then the user will not be able to access the Application
resource "aws_wafv2_web_acl" "waf" {
  name  = var.web_acl_name
  scope = "CLOUDFRONT"
  description = "There are no rules in the initial state"

  default_action {
    allow {}
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "BlockIPRuleMetrics"
    sampled_requests_enabled   = true
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_wafv2_web_acl/waf"
    owner = "ktd-admin"
  }
}