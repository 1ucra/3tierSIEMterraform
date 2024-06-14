#!/bin/bash
# Amazon Linux 2에 Nginx 설치

sudo su
systemctl restart amazon-cloudwatch-agent

git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

cat > /etc/nginx/default.d/default.conf << 'EOF'
location /static {
        root /usr/share/nginx/html;
    }

location / {
    proxy_pass http://${app_lb_dns}:8080;
}
EOF

git clone "https://git-codecommit.ca-central-1.amazonaws.com/v1/repos/${repository_name}"
mv "./${repository_name}/static/" /usr/share/nginx/html/

systemctl restart nginx