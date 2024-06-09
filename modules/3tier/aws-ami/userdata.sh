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
yum install amazon-cloudwatch-agent -y
systemctl start amazon-cloudwatch-agent
systemctl enable amazon-cloudwatch-agent

wget https://aws-codedeploy-ca-central-1.s3.ca-central-1.amazonaws.com/latest/install
chmod +x ./install
./install auto
systemctl start codedeploy-agent
systemctl enable codedeploy-agent