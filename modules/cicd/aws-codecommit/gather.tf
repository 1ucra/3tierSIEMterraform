data "aws_codecommit_repository" "hellowaws-sourcecode" {
  repository_name = var.repository_name
}