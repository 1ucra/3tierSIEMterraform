#!/bin/bash
# Amazon Linux 2에 Nginx 설치


# 필요한 패키지 설치

yum install -y python3-pip gcc python3-devel mariadb105-devel 
yum groupinstall "Development Tools" -y 
yum install -y bzip2-devel libffi-devel 

# Git 설정

export HOME=/root
git config --global credential.helper '!aws codecommit credential-helper $@' 
git config --global credential.UseHttpPath true 

# 디렉터리 이동 및 리포지토리 클론

cd / 
git clone "https://git-codecommit.us-east-2.amazonaws.com/v1/repos/hellowaws" 

cd /hellowaws/django-community-board-main/ 

# 호스트네임 설정 및 템플릿 변환
echo "Setting hostname and processing template..."
export hostname=$(hostname)
envsubst < ./templates/index.html.template > ./templates/index.html

# Python 패키지 설치
echo "Installing Python packages..."
pip install --no-cache-dir -r ./requirements.txt 
pip install django 
pip install django-redis 

# SSM 파라미터 가져오기
echo "Fetching SSM parameters..."
db_user_id=$(aws ssm get-parameter --name "/config/account/admin/ID" --with-decryption --query "Parameter.Value" --output text)
db_user_pwd=$(aws ssm get-parameter --name "/config/account/admin/PWD" --with-decryption --query "Parameter.Value" --output text) 
aurora_endpoint=$(aws ssm get-parameter --name "/config/system/db-cluster-endpoint" --with-decryption --query "Parameter.Value" --output text)
redis_endpoint=$(aws ssm get-parameter --name "/config/system/redis-cluster-endpoint" --with-decryption --query "Parameter.Value" --output text) 

export db_user_id
export db_user_pwd
export aurora_endpoint
export redis_endpoint

# Django 설정 파일 템플릿 변환

envsubst < ./templates/settings.py.template > ./community_board_project/settings.py 

# Nginx 재시작 (Nginx가 설치되어 있어야 함)

systemctl restart nginx 

# Django 마이그레이션 및 서버 실행
echo "Running Django migrations and starting server..."
python3 manage.py makemigrations 
python3 manage.py migrate 
python3 manage.py runserver 0.0.0.0:8080 


