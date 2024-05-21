data "aws_subnet" "DB_SUBNET1" {
  filter {
    name   = "tag:Name"
    values = [var.db-subnet-name1]
  }
}

data "aws_subnet" "DB_SUBNET2" {
  filter {
    name   = "tag:Name"
    values = [var.db-subnet-name2]
  }
}

data "aws_security_group" "db-sg" {
  filter {
    name   = "tag:Name"
    values = [var.DB_SG_NAME]
  }
  filter {
    name = "group-id"
    values = [var.db-sg-id]
  }
}