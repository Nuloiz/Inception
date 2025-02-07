FROM debian:bullseye

# Install MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Copy only the init script (no need for init.sql)
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

# Set permissions
RUN chmod +x /usr/local/bin/mariadb.sh

# Expose MariaDB port
EXPOSE 3306

# Start MariaDB with the init script
CMD ["/usr/local/bin/mariadb.sh"]
