output "web_elb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.Web-elb.dns_name)
}

output "app_elb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.App-elb.dns_name)
}

output "app_tg_arn" {
  description = "The name of the target group of elb"
  value = try(aws_lb_target_group.app-tg.arn)
}

output "web_tg_arn" {
  description = "The name of the target group of elb"
  value = try(aws_lb_target_group.web-tg.arn)
}

output "app_tg_name" {
  description = "The name of the target group of elb"
  value = try(aws_lb_target_group.app-tg.name)
}

output "web_tg_name" {
  description = "The name of the target group of elb"
  value = try(aws_lb_target_group.web-tg.name)
}

output "web_elb" {
  value = try(aws_lb.Web-elb)
}