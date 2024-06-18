#!/bin/bash
# Amazon Linux 2에 Nginx 설치

systemctl restart amazon-cloudwatch-agent
export HOME=/root
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true




export app_lb_dns="${app_lb_dns}"

cat > /etc/nginx/default.d/default.conf << 'EOF'
location /static {
        root /usr/share/nginx/html;
    }

location / {
    proxy_pass http://${app_lb_dns}:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
EOF

export repository_name="${repository_name}"

git clone "https://git-codecommit.ca-central-1.amazonaws.com/v1/repos/${repository_name}"
mkdir ./${repository_name}/static/images/
aws s3 sync s3://hellowaws-image-bucket/ ./${repository_name}/static/images/
mv "./${repository_name}/static/" /usr/share/nginx/html/


systemctl restart nginxW