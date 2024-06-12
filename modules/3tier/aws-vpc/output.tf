output "vpc-id" {
  value = aws_vpc.hellowaws-vpc.id
}

output "private-subnet1-id" {
  value = aws_subnet.private-subnet1.id
}

output "private-subnet2-id" {
  value = aws_subnet.private-subnet2.id
}