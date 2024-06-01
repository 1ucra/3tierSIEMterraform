#!/bin/bash
# Amazon Linux 2에 Nginx 설치
sudo su

yum update -y
amazon-linux-extras install nginx1 -y

# Nginx 서비스 시작 및 부팅 시 자동 실행 설정
systemctl start nginx
systemctl enable nginx
yum install -y ruby
yum install -y wget

wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
chmod +x ./install
./install auto
systemctl start codedeploy-agent
systemctl enable codedeploy-agent