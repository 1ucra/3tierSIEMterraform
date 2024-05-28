#!/bin/bash
# Amazon Linux 2에 Nginx 설치

# 로그 파일 설정
LOG_FILE="/var/log/user_data.log"
exec > >(tee -a ${LOG_FILE} | logger -t user-data) 2>&1

echo "User Data Script Started"

# 필요한 패키지 설치
echo "Installing packages..."
yum install -y python3-pip gcc python3-devel mariadb105-devel || { echo "Package installation failed"; exit 1; }
yum groupinstall "Development Tools" -y || { echo "Development tools installation failed"; exit 1; }
yum install -y bzip2-devel libffi-devel || { echo "Additional packages installation failed"; exit 1; }

# Git 설정
echo "Configuring Git..."
export HOME=/root
git config --global credential.helper '!aws codecommit credential-helper $@' || { echo "Git credential helper configuration failed"; exit 1; }
git config --global credential.UseHttpPath true || { echo "Git HTTP path usage configuration failed"; exit 1; }

# 디렉터리 이동 및 리포지토리 클론
echo "Cloning repository..."
cd / || { echo "Directory change failed"; exit 1; }
git clone "https://git-codecommit.us-east-2.amazonaws.com/v1/repos/hellowaws" || { echo "Git clone failed"; exit 1; }

cd /hellowaws/django-community-board-main/ || { echo "Directory change failed"; exit 1; }

# 호스트네임 설정 및 템플릿 변환
echo "Setting hostname and processing template..."
export hostname=$(hostname)
envsubst < ./templates/index.html.template > ./templates/index.html || { echo "Template processing failed"; exit 1; }

# Python 패키지 설치
echo "Installing Python packages..."
pip install --no-cache-dir -r ./requirements.txt || { echo "Python package installation from requirements.txt failed"; exit 1; }
pip install django || { echo "Django installation failed"; exit 1; }
pip install django-redis || { echo "Django-redis installation failed"; exit 1; }

# SSM 파라미터 가져오기
echo "Fetching SSM parameters..."
db_user_id=$(aws ssm get-parameter --name "/config/account/admin/ID" --with-decryption --query "Parameter.Value" --output text) || { echo "Fetching db_user_id failed"; exit 1; }
db_user_pwd=$(aws ssm get-parameter --name "/config/account/admin/PWD" --with-decryption --query "Parameter.Value" --output text) || { echo "Fetching db_user_pwd failed"; exit 1; }
aurora_endpoint=$(aws ssm get-parameter --name "/config/system/db-cluster-endpoint" --with-decryption --query "Parameter.Value" --output text) || { echo "Fetching aurora_endpoint failed"; exit 1; }
redis_endpoint=$(aws ssm get-parameter --name "/config/system/redis-cluster-endpoint" --with-decryption --query "Parameter.Value" --output text) || { echo "Fetching redis_endpoint failed"; exit 1; }

export db_user_id
export db_user_pwd
export aurora_endpoint
export redis_endpoint

# Django 설정 파일 템플릿 변환
echo "Processing Django settings template..."
envsubst < ./templates/settings.py.template > ./community_board_project/settings.py || { echo "Django settings template processing failed"; exit 1; }

# Nginx 재시작 (Nginx가 설치되어 있어야 함)
echo "Restarting Nginx..."
systemctl restart nginx || { echo "Nginx restart failed"; exit 1; }

# Django 마이그레이션 및 서버 실행
echo "Running Django migrations and starting server..."
python3 manage.py makemigrations || { echo "Django makemigrations failed"; exit 1; }
python3 manage.py migrate || { echo "Django migrate failed"; exit 1; }
python3 manage.py runserver 0.0.0.0:8080 || { echo "Django runserver failed"; exit 1; }

echo "User Data Script Completed"
