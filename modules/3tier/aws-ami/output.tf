output "my-ami-id" {
  value = aws_ami_from_instance.hellowaws-ami.id
}