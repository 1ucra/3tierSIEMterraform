#!/bin/bash

# 로그 파일 정의
LOG_FILE=/var/log/user-data.log

# 로그 파일로 모든 출력 리디렉션
exec > $LOG_FILE 2>&1

echo "Running user data script"

# 네트워크 준비 대기 (최대 2분)
count=0
max_retries=60
while ! curl -s http://example.com > /dev/null; do
    echo "Waiting for network..."
    count=$((count + 1))
    if [ $count -ge $max_retries ]; then
        echo "Network not ready after multiple retries, exiting."
        exit 1
    fi
    sleep 2
done

# 시스템 업데이트
echo "Updating system"
dnf update -y

# MySQL 리포지토리 추가
echo "Downloading MySQL repository package"
wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm

echo "Installing MySQL repository package"
dnf install mysql80-community-release-el9-1.noarch.rpm -y

# MySQL GPG 키 추가
echo "Importing MySQL GPG key"
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023

# MySQL 클라이언트 설치
echo "Installing MySQL client"
dnf install mysql-community-client -y

echo "User data script completed"
#cat /var/log/user-data.log 로그 확인