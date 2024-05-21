resource "aws_iam_instance_profile" "instance-profile" {
  name = var.instance_profile_name
  role = aws_iam_role.iam_role.name
}