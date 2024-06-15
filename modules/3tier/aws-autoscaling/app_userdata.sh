#!/bin/bash

cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen       8080 default_server;
    listen       [::]:8080 default_server;
    
    root         /usr/share/nginx/html;
    location / {
        try_files $uri $uri/ =404;
    }

    location /healthcheck {
    access_log off;
    return 200 'OK';
    add_header Content-Type text/plain;

    # 오류 페이지 설정
    error_page 404 /404.html;
    location = /404.html {
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
    }
}
EOF


# Nginx 재시작
systemctl restart nginx