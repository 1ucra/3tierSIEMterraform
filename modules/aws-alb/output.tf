output "web_alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.Web-elb.dns_name)
}

output "app_alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.App-elb.dns_name)
}

output "app_tg_arn" {
  description = "The name of the target group of alb"
  value = try(aws_lb_target_group.app-tg.arn)
}

output "web_tg_arn" {
  description = "The name of the target group of alb"
  value = try(aws_lb_target_group.web-tg.arn)
}