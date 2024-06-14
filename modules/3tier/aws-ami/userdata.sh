#!/bin/bash
# Amazon Linux 2에 Nginx 설치
sudo su

yum update -y
amazon-linux-extras install nginx1 -y

sed -i '18,22d' /etc/nginx/nginx.conf

sed -i '18i \
 log_format json_logs escape=json '\''{\
     \"time_local\":\"\$time_local\",\
     \"request\":\"\$request\",\
     \"status\":\"\$status\",\
     \"body_bytes_sent\":\"\$body_bytes_sent\",\
     \"http_referer\":\"\$http_referer\",\
     \"connection\":\"\$connection\",\
     \"http_x_forwarded_for\":\"\$http_x_forwarded_for\",\
 }'\'';\
 access_log /var/log/nginx/access.log json_logs;\
 error_log /var/log/nginx/error.log;' /etc/nginx/nginx.conf

systemctl restart nginx
systemctl enable nginx

mkdir /hellowaws_init
cd /hellowaws_init

yum install -y git
yum install -y ruby
yum install -y wget
yum install -y amazon-cloudwatch-agent

systemctl restart amazon-cloudwatch-agent
systemctl enable amazon-cloudwatch-agent

wget https://aws-codedeploy-ca-central-1.s3.ca-central-1.amazonaws.com/latest/install
chmod +x ./install
./install auto
systemctl start codedeploy-agent
systemctl enable codedeploy-agent
