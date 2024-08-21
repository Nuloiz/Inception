#!/bin/bash

# Define the URL for the WordPress download
WORDPRESS_URL="http://wordpress.org/latest.tar.gz"

# Create the installation directory if it doesn't exist
if [ -f ./wp-config.php ]; then
    echo "Platzhalter"
else

# Download WordPress
curl -o wordpress.tar.gz -SL "$WORDPRESS_URL"

# Extract WordPress
tar -xzf wordpress.tar.gz
mv wordpress/* .

# Clean up the tar.gz file
rm wordpress.tar.gz
rm -rf wordpress


sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php\

cp wp-config-sample.php wp-config.php


fi

exec "$@"