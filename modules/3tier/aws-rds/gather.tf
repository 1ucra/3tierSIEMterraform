data "aws_subnet" "db_subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.db_subnet_name1]
  }
}

data "aws_subnet" "db_subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.db_subnet_name2]
  }
}

data "aws_security_group" "db-sg" {
  filter {
    name   = "tag:Name"
    values = [var.dbTier_securityGroup_name]
  }
  filter {
    name = "group-id"
    values = [var.db_securityGroup_id]
  }
}