# data "aws_ami" "ami" {
#   most_recent = true
#   owners      = ["amazon"]
 
#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.*-x86_64"]
#   }
 
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
 
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# data "aws_ami" "ami" {
#   most_recent = true
#   owners      = ["self"]
 
#   filter {
#     name   = "name"
#     values = ["project-ami"]
#   }

#    filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
  
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

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