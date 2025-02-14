# Use Debian Buster as the base image
FROM debian:bullseye

# Set the WordPress version
ENV WORDPRESS_VERSION 5.8.1

# Install PHP, PHP-FPM, and necessary PHP extensions
    
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /run/php

# Create the /var/www/html directory
WORKDIR /var/www/html/ 

COPY ./tools/download_wp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/download_wp.sh
ENTRYPOINT ["/usr/local/bin/download_wp.sh"]

# Copy custom www.conf to the correct directory
COPY /conf/www.conf /etc/php/7.4/fpm/pool.d/

# Only for testing begin
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
# Only for testing end
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM
CMD ["/usr/sbin/php-fpm7.4", "-F"]
