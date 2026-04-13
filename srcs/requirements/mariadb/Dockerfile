FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql
RUN rm -rf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/mariadb.conf /etc/mysql/my.cnf

COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/mariadb.conf
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

RUN chmod 777 /run/mysqld

ENTRYPOINT ["mariadb.sh"]
