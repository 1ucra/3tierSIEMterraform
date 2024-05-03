data "aws_ssm_parameter" "db_id"{
  name = "/config/account/admin/ID"
}

data "aws_ssm_parameter" "db_pw"{
  name = "/config/account/admin/PW"
}

data "aws_subnet" "db-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.db-subnet-name1]
  }
}

data "aws_subnet" "db-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.db-subnet-name2]
  }
}

data "aws_security_group" "db-sg" {
  filter {
    name   = "tag:Name"
    values = [var.db-sg-name]
  }
  filter {
    name = "group-id"
    values = [var.db-sg-id]
  }
}