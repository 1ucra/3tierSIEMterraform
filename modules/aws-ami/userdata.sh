#!/bin/bash
# Amazon Linux 2에 Nginx 설치
sudo su

dnf update -y
dnf install -y nginx
dnf cache
# Nginx 서비스 시작 및 부팅 시 자동 실행 설정
systemctl start nginx
systemctl enable nginx
sudo dnf install -y ruby
sudo dnf install -y wget
sudo dnf install -y mariadb105
wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent
sudo systemctl enable codedeploy-agent