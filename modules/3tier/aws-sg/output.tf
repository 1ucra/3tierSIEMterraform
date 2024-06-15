output "web_elb_securityGroup_id" {
  value = aws_security_group.web-elb-sg.id
}

output "app_elb_securityGroup_id" {
  value = aws_security_group.app-elb-sg.id
}

output "web-tier-sg-id" {
  value = aws_security_group.web-tier-sg.id
}

output "app-tier-sg-id" {
  value = aws_security_group.app-tier-sg.id
}

output "database_securityGroup_id" {
  value = aws_security_group.database-sg.id
}

output "bastion_securityGroup_id" {
  value = aws_security_group.bastion-sg.id
}

output "redis_securityGroup_id" {
  value = aws_security_group.redis-sg.id
}

output "cloudfront_prefix_list" {
  value = data.aws_ec2_managed_prefix_list.cloudfront
}
