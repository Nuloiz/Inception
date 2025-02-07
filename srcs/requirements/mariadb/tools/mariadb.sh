#!/bin/bash

# Initialize MariaDB data directory if not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

# Start MariaDB in the background
echo "Starting MariaDB..."
mysqld_safe --skip-networking &
sleep 5  # Give the server time to start

# Run SQL commands directly instead of using an init.sql file
echo "Creating WordPress database and user..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Stop MariaDB so it can be started properly by the container
echo "Shutting down MariaDB..."
mysqladmin -u root shutdown

# Restart MariaDB in foreground
echo "Restarting MariaDB..."
exec mysqld_safe