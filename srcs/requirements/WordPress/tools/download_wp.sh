#!/bin/bash

# Define the URL for the WordPress download
WORDPRESS_URL="http://wordpress.org/latest.tar.gz"

# Create the installation directory if it doesn't exist
if [ -f ./wp-config.php ]; then
    echo "worpress already installed"
fi

# Download WordPress
echo "Downloading WordPress"
curl -o wordpress.tar.gz -SL "$WORDPRESS_URL"

# Extract WordPress
echo "Extracting WordPress"
tar -xzf wordpress.tar.gz
mv wordpress/* .

# Clean up the tar.gz file
echo "Cleaning up..."
rm wordpress.tar.gz
rm -rf wordpress


echo "WordPress downloaded and installed"