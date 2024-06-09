
resource "aws_instance" "bastion" {
  ami           = var.ami-id # 아마존 2 ami
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.subnet.id
  iam_instance_profile   = var.instance_profile_name
  vpc_security_group_ids = [var.bastion_securityGroup_id]
  
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "bastion"
  }
}

# AMI 생성
resource "aws_ami_from_instance" "my_ami" {
  name               = "amz-nginx-${formatdate("YYYYMMDD-HHmm", timestamp())}"
  source_instance_id = aws_instance.bastion.id
  description        = "A instance created for a short time to create an AMI"

  tags = {
    Name = "my-ami"
  }
  
  depends_on = [ aws_instance.bastion ]
}

# resource "null_resource" "stop_instance" {

#   provisioner "local-exec" {
#     when = create
#     command = "aws ec2 stop-instances --instance-ids '${aws_instance.bastion.id}'"
#   }

#   depends_on = [ aws_instance.bastion, aws_ami_from_instance.my_ami]
# }