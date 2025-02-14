#!/bin/bash

# Define the URL for the WordPress download
WORDPRESS_URL="http://wordpress.org/latest.tar.gz"

# Function to check database connection
check_db() {
    echo "Checking database connection..."
    until mariadb-admin ping --protocol=tcp --host="$MYSQL_HOSTNAME" -u"$MYSQL_USER" --password="$MYSQL_PASSWORD" --wait >/dev/null 2>/dev/null; do
        echo "Waiting for MariaDB to be ready..."
        sleep 10
    done
    echo "Database is ready!"
}

# Check if WordPress is already installed
if [ -f ./wp-config.php ] && wp core is-installed --allow-root; then
    echo "WordPress is already installed."
else
    echo "Downloading and setting up WordPress..."

    # Wait for the database to be ready
    check_db

    # Download and extract WordPress
    curl -o wordpress.tar.gz -SL "$WORDPRESS_URL"
    tar -xzf wordpress.tar.gz
    mv wordpress/* .
    rm -rf wordpress wordpress.tar.gz

    # Configure wp-config.php
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
    sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
    sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
    cp wp-config-sample.php wp-config.php

    # Install WP-CLI (if not already installed in the image)
    if ! command -v wp &> /dev/null; then
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    # Run WordPress installation
    wp core install --url="https://localhost" \
        --title="My WordPress Site" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="admin@example.com" \
        --allow-root

    echo "WordPress installation complete."
fi

# Execute the container's CMD
exec "$@"
