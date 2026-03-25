#!/bin/bash
set -e

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "[Inception] Generating SSL certificates..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=FR/ST=PACA/L=Nice/O=42/OU=ltcherep/CN=ltcherep.42.fr"
fi

echo "[Inception] NGINX is starting..."

exec nginx -g "daemon off;"
