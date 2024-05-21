output "web_alb_securityGroup_id" {
  value = aws_security_group.web-alb-sg.id
}

output "app_alb_securityGroup_id" {
  value = aws_security_group.app-alb-sg.id
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

