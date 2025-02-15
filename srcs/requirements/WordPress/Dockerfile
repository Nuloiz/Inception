# Use Debian Buster as the base image
FROM debian:bullseye

# Set the WordPress version
ENV WORDPRESS_VERSION 5.8.1

# Install PHP, PHP-FPM, and necessary PHP extensions + mariadb-client optionally
RUN apt-get update && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-zip \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-curl \
    php7.4-xml \
    php7.4-json \
    php7.4-opcache \
    curl \
    unzip \
    mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory (ensure it's set before copying files)
WORKDIR /var/www/html/

# Create necessary directories with correct permissions
RUN mkdir -p /run/php

# Copy the WordPress download script and make it executable
COPY ./tools/download_wp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/download_wp.sh

# Copy custom PHP-FPM pool configuration
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Expose PHP-FPM port
EXPOSE 9000

# Set entrypoint to download and install WordPress
ENTRYPOINT ["/usr/local/bin/download_wp.sh"]

# Start PHP-FPM in foreground
CMD ["/usr/sbin/php-fpm7.4", "-F"]