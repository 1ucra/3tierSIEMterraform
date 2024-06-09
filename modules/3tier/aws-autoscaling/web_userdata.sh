#!/bin/bash
# Amazon Linux 2에 Nginx 설치

sudo su

aws s3 cp s3://ktd-0426/django-community-board-main/templates/default.conf.template /etc/nginx/conf.d/
app_lb_dns=$(aws ssm get-parameter --name "/config/system/alb_dns_name" --with-decryption --query "Parameter.Value" --output text  --region "ca-central-1")
export app_lb_dns

envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
aws s3 cp s3://ktd-0426/django-community-board-main/static /usr/share/nginx/html/static --recursive
systemctl restart nginx