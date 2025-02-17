#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

echo "Configuring MariaDB to bind on all interfaces..."
sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

echo "Starting MariaDB..."
mysqld_safe --skip-networking &
sleep 5

# Setting up Database and User
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;

-- Remove any existing users with the same name (to avoid conflicts)
DROP USER IF EXISTS '$MYSQL_USER'@'localhost';
DROP USER IF EXISTS '$MYSQL_USER'@'%';

-- Create user with access from any host
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

-- Grant privileges to the user
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;

-- Ensure changes are saved
FLUSH PRIVILEGES;
EOF

echo "Shutting down MariaDB..."
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

echo "Restarting MariaDB in foreground..."
exec mysqld_safe