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

dnf install -y python3-pip gcc python3-devel mariadb105-devel
dnf groupinstall "Development Tools" -y
dnf install bzip2-devel libffi-devel -y
aws s3 cp s3://ktd-0426/django-community-board-main/ ./ --recursive
pip install --no-cache-dir -r ./requirements.txt
pip install django
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:8080
