#!/bin/bash
# Amazon Linux 2에 Nginx 설치

sudo su

dnf install -y python3-pip gcc python3-devel mariadb105-devel
dnf groupinstall "Development Tools" -y
dnf install bzip2-devel libffi-devel -y
aws s3 cp s3://ktd-0426/django-community-board-main/ ./ --recursive
export hostname=$(hostname)
envsubst < /templates/index.html.template > /templates/index.html
pip install --no-cache-dir -r ./requirements.txt
pip install django
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:8080
