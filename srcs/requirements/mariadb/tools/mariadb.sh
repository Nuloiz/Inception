#!/bin/bash

# Wait for MariaDB to be ready
until mysqladmin ping -h localhost --silent; do
    echo "Waiting for database connection..."
    sleep 2
done

echo "Creating WordPress database and user..."

# Run the necessary SQL commands
mysql -u root -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "Database setup completed."