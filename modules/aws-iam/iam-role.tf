resource "aws_iam_role" "iam_role" {
  name               = var.iam_role
  assume_role_policy = file("${path.module}/iam-role.json")
}