FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    vim \
    && rm -rf /var/lib/apt/lists/*

COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf


CMD ["/usr/local/bin/mariadb.sh"]
