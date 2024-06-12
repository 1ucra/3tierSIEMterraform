data "aws_subnet" "public-subnet1" {
  filter {
    name   = "tag:Name"
    values = ["aws_subnet/public-subnet1"]
  }
}

data "aws_subnet" "public-subnet2" {
  filter {
    name   = "tag:Name"
    values = ["aws_subnet/public-subnet2"]
  }
}

data "aws_subnet" "private-subnet1" {
  filter {
    name   = "tag:Name"
    values = ["aws_subnet/private-subnet1"]
  }
}

data "aws_subnet" "private-subnet2" {
  filter {
    name   = "tag:Name"
    values = ["aws_subnet/private-subnet2"]
  }
}

data "aws_security_group" "web-elb-sg" {
  filter {
    name = "group-id"
    values = [var.web_elb_securityGroup_id]
  }
}

data "aws_security_group" "app-elb-sg" {

  filter {
    name = "group-id"
    values = [var.app_elb_securityGroup_id]
  }
}


data "aws_vpc" "hellowaws-vpc" {
  filter {
    name   = "tag:Name"
    values = ["aws_vpc/hellowaws-vpc"]
  }
}