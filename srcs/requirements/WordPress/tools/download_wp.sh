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

set_permissions() {
    echo "Setting correct ownership and permissions..."

    # Ensure /var/www/html directory and its contents are owned by www-data
    chown -R www-data:www-data /var/www/html

    # Ensure wp-config.php has the correct permissions (644)
    if [ -f /var/www/html/wp-config.php ]; then
        chmod 644 /var/www/html/wp-config.php
    fi

    # Ensure the wp-content directory is also owned by www-data
    chown -R www-data:www-data /var/www/html/wp-content
    chmod -R 755 /var/www/html/wp-content

    # Set the proper directory permissions for /var/www/html
    chmod -R 755 /var/www/html

    # Ensure proper permissions for the socket directory
    chown -R www-data:www-data /run/php
    chmod 755 /run/php

    echo "Permissions set!"
}

# Check if WordPress is already installed
sleep 10
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
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="My WordPress Site" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="admin@example.com" \
        --allow-root

    if ! wp user get "$WORDPRESS_USER" --allow-root > /dev/null 2>&1; then
            wp user create "$WORDPRESS_USER" --role=author --user_pass="$WORDPRESS_PASSWORD" --allow-root
        fi

    echo "WordPress installation complete."
fi

# Stop any existing PHP-FPM process (if running)
#pkill -9 php-fpm7.4 2>/dev/null || true

# Ensure no stale PHP-FPM processes are running for Testing
#rm -f /run/php/php7.4-fpm.sock

# Set correct ownership and permissions after WordPress setup
set_permissions
echo "WordPress setup complete."

# Start PHP-FPM for Testing
#php-fpm7.4 -D

# Execute the container's CMD
exec "$@"
