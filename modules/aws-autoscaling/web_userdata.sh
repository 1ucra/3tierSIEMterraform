#!/bin/bash
# Amazon Linux 2에 Nginx 설치
sudo su

dnf update -y
dnf install -y nginx
dnf cache
# Nginx 서비스 시작 및 부팅 시 자동 실행 설정
systemctl start nginx
systemctl enable nginx
export PS1="[\u@\h \w]\$ "
source ~/.bashrc

aws s3 cp s3://ktd-0426/default.conf.template /etc/nginx/conf.d/

export app_lb_dns="${app_lb_dns}"
export app_lb_dns2="${app_lb_dns2}"
export app_lb_dns3="${app_lb_dns3}"
cd /etc
touch aa
echo "${app_lb_dns}" >> aa
echo "${app_lb_dns2}" >> aa
echo "${app_lb_dns3}" >> aa
envsubst '${app_lb_dns}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf
aws s3 cp s3://ktd-0426/django-community-board-main/static /usr/share/nginx/html/static --recursive
systemctl restart nginx