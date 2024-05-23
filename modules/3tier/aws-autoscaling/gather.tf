# data "aws_ssm_parameter" "db_id"{
#   name = "/config/account/admin/ID"
# }

# data "aws_ssm_parameter" "db_pwd"{
#   name = "/config/account/admin/PWD"
# }


data "aws_subnet" "private_subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name1]
  }
}

data "aws_subnet" "private_subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name2]
  }
}
