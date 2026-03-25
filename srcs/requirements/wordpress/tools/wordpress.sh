#!/bin/bash
set -e

mkdir -p /run/php
chown www-data:www-data /run/php

MYSQL_PASSWORD="$(cat "$MYSQL_PASSWORD_FILE")"
WP_ADMIN_PASSWORD="$(cat /run/secrets/admin_password)"
WP_USER_PASSWORD="$(cat /run/secrets/admin_password)"
MYSQL_HOST="${MYSQL_HOSTNAME:-mariadb}"
MYSQL_PORT="${MYSQL_PORT:-3306}"

echo "[Inception] Waiting for MariaDB..."
until mariadb -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1;" > /dev/null 2>&1; do
    echo "Waiting for database... (Current user: ${MYSQL_USER})"
    sleep 2
done
echo "[Inception] MariaDB is ready."

cd /var/www/wordpress

if [ ! -f /var/www/wordpress/wp-load.php ]; then
    echo "[Inception] Downloading WordPress..."
    wp core download --allow-root --path=/var/www/wordpress
fi

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "[Inception] Configuring WordPress..."
    wp config create --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="${MYSQL_HOST}:${MYSQL_PORT}" \
        --path=/var/www/wordpress
fi

if ! wp core is-installed --allow-root --path=/var/www/wordpress; then

    echo "[Inception] Installing WordPress..."
    wp core install --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path=/var/www/wordpress

fi

if ! wp user get "$WP_USER" --allow-root --path=/var/www/wordpress > /dev/null 2>&1; then
    echo "[Inception] Creating second user..."
    wp user create --allow-root \
        "$WP_USER" "$WP_USER_EMAIL" \
        --role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --path=/var/www/wordpress
fi

chown -R www-data:www-data /var/www/wordpress
echo "[Inception] WordPress setup complete."
# Find the correct php-fpm binary (version-agnostic)
PHP_FPM=$(find /usr/sbin -name 'php-fpm*' | head -1)

echo "[Inception] Starting php-fpm..."
exec "$PHP_FPM" -F
