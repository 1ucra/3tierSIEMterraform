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

db_user_id=$(aws ssm get-parameter --name "/config/account/admin/ID" --with-decryption --query "Parameter.Value" --output text)
db_user_pwd=$(aws ssm get-parameter --name "/config/account/admin/PWD" --with-decryption --query "Parameter.Value" --output text)
aurora_endpoint=$(aws ssm get-parameter --name "/config/system/db-cluster-endpoint" --with-decryption --query "Parameter.Value" --output text)
export db_user_id
export db_user_pwd
export aurora_endpoint
aws s3 cp s3://ktd-0426/django-community-board-main/templates/settings.py.template /community_board_project/
envsubst < /community_board_project/settings.py.template > /community_board_project/settings.py
systemctl restart nginx
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:8080
