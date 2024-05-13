#!/bin/bash
# Amazon Linux 2에 Nginx 설치
sudo su

dnf update -y
dnf install -y nginx
dnf cache
# Nginx 서비스 시작 및 부팅 시 자동 실행 설정
systemctl start nginx
systemctl enable nginx
