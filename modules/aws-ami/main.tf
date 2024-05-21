# 기존 보안 그룹 데이터 소스
resource "aws_instance" "bastion" {
  ami           = "ami-0ddda618e961f2270" # 아마존 2023 ami
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.subnet.id
  iam_instance_profile   = var.instance_profile_name
  vpc_security_group_ids = [var.bastion_securityGroup_id]
  
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "bastion"
  }
}

locals {
  ami_name = "amz-nginx-${formatdate("YYYYMMDD-HHmm", timestamp())}"
}

# AMI 생성
resource "aws_ami_from_instance" "my_ami" {
  name               = local.ami_name
  source_instance_id = aws_instance.bastion.id
  description        = "A instance created for a short time to create an AMI"

  tags = {
    Name = "my-ami"
  }
}

resource "null_resource" "terminate_instance" {
  depends_on = [aws_ami_from_instance.my_ami]

  provisioner "local-exec" {
    command = "aws ec2 stop-instances --instance-ids ${aws_instance.bastion.id}"
  }
}