

resource "aws_instance" "DBbastion" {
  ami           = var.ami-id # 아마존 2 ami
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.db-subnet1.id
  iam_instance_profile   = var.instance_profile_name
  vpc_security_group_ids = [var.bastion_securityGroup_id]
  
  user_data = file("${path.module}/userdata.sh")

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_instance/bastion"
    owner = "ktd-admin"
  }
}
