output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.web-elb.dns_name)
}

output "alb_tg_arn" {
  description = "The name of the target group of alb"
  value = try(aws_lb_target_group.web-tg.arn)
}