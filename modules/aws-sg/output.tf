output "alb-sg-id" {
  value = aws_security_group.alb-sg.id
}

output "web-tier-sg-id" {
  value = aws_security_group.web-tier-sg.id
}

output "app-tier-sg-id" {
  value = aws_security_group.app-tier-sg.id
}

output "database-sg-id" {
  value = aws_security_group.database-sg.id
}


