#!/bin/bash
set -e

sleep 10


GITHUB_CLIENT_ID="${GITHUB_CLIENT_ID}"
GITHUB_CLIENT_SECRET="${GITHUB_CLIENT_SECRET}"
COOKIE_SECRET="${COOKIE_SECRET}"


PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
PUBLIC_URL="http://${PUBLIC_IP}"


apt update -y
apt upgrade -y


# INSTALL PACKAGES
apt install -y nginx curl unzip openssl


# ENABLE NGINX
systemctl enable nginx
systemctl start nginx


# CREATE PROTECTED WEBSITE
mkdir -p /var/www/protected-site

cat <<EOF > /var/www/protected-site/index.html
<h1>Protected Website</h1>
<p>OAuth2 via GitHub</p>
<a href="/oauth2/sign_out">Logout</a>
EOF

chown -R www-data:www-data /var/www/protected-site


# INSTALL OAUTH2-PROXY
cd /opt
curl -LO https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v7.6.0/oauth2-proxy-v7.6.0.linux-amd64.tar.gz
tar -xzf oauth2-proxy-v7.6.0.linux-amd64.tar.gz
mv oauth2-proxy-v7.6.0.linux-amd64 oauth2-proxy
chmod +x /opt/oauth2-proxy/oauth2-proxy


# OAUTH2-PROXY CONFIG
cat <<EOF > /opt/oauth2-proxy/oauth2-proxy.cfg
provider = "github"

client_id = "${GITHUB_CLIENT_ID}"
client_secret = "${GITHUB_CLIENT_SECRET}"

cookie_secret = "${COOKIE_SECRET}"
cookie_secure = false

email_domains = ["*"]

http_address = "127.0.0.1:4180"
redirect_url = "${PUBLIC_URL}/oauth2/callback"
EOF


# SYSTEMD SERVICE
cat <<EOF > /etc/systemd/system/oauth2-proxy.service
[Unit]
Description=OAuth2 Proxy (GitHub)
After=network.target

[Service]
ExecStart=/opt/oauth2-proxy/oauth2-proxy --config /opt/oauth2-proxy/oauth2-proxy.cfg
Restart=always
User=www-data

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable oauth2-proxy
systemctl start oauth2-proxy


# NGINX CONFIG
cat <<EOF > /etc/nginx/sites-available/protected-site
server {
    listen 80;
    server_name _;

    root /var/www/protected-site;
    index index.html;

    location / {
        auth_request /oauth2/auth;
        error_page 401 = /oauth2/sign_in;
        try_files \$uri \$uri/ =404;
    }

    location /oauth2/ {
        proxy_pass http://127.0.0.1:4180;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Scheme \$scheme;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

ln -sf /etc/nginx/sites-available/protected-site /etc/nginx/sites-enabled/protected-site
rm -f /etc/nginx/sites-enabled/default

nginx -t
systemctl reload nginx

echo "OAuth2 protected website deployed at ${PUBLIC_URL}"
