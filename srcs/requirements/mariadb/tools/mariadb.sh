#!/bin/bash
set -e

MYSQL_ROOT_PASSWORD="$(cat "$MYSQL_ROOT_PASSWORD_FILE")"
MYSQL_PASSWORD="$(cat "$MYSQL_PASSWORD_FILE")"

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "[Inception] Initializing MariaDB data directory..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

echo "[Inception] Starting temporary MariaDB server..."
mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
pid="$!"

for i in $(seq 1 30); do
	if mariadb -u root -e "SELECT 1" > /dev/null 2>&1 || \
		mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1; then
		break
	fi
	sleep 1
done

if [ "$i" -eq 30 ]; then
	echo "[Inception] MariaDB temporary startup failed."
	exit 1
fi

if mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1; then
	ROOT_AUTH=(-u root -p"${MYSQL_ROOT_PASSWORD}")
else
	ROOT_AUTH=(-u root)
fi

echo "[Inception] Ensuring database and users exist..."
mariadb "${ROOT_AUTH[@]}" <<-EOSQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
	CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
	FLUSH PRIVILEGES;
EOSQL

echo "[Inception] Shutting down temporary server..."
kill "$pid"
wait "$pid"
echo "[Inception] MariaDB initialization complete."

echo "[Inception] Starting MariaDB..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --console
