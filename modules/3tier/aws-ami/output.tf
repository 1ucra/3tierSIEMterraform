output "my-ami-id" {
  value = aws_ami_from_instance.ktd_ami.id
}