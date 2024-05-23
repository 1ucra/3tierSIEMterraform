output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "private-subnet1-id" {
  value = aws_subnet.private_subnet1.id
}

output "private-subnet2-id" {
  value = aws_subnet.private_subnet2.id
}