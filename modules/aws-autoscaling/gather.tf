data "aws_security_group" "web-sg" {
  filter {
    name   = "tag:Name"
    values = [var.web-sg-name]
  }
  filter {
    name = "group-id"
    values = [var.web-sg-id]
  }
}

data "aws_subnet" "private-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.private-subnet-name1]
  }
}

data "aws_subnet" "private-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.private-subnet-name2]
  }
}

data "aws_iam_instance_profile" "instance-profile" {
  name = var.instance-profile-name
}
