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

# Copy the download script into the container
COPY /tools/download_wp.sh /usr/local/bin/download_wp.sh

# Make the script executable
RUN chmod +x /usr/local/bin/download_wp.sh

# Run the script to download and set up WordPress
RUN /usr/local/bin/download_wp.sh

#ENTRYPOINT [ "/tools/download_wp.sh" ]

# Copy custom www.conf to the correct directory
COPY /conf/www.conf /etc/php/7.3/fpm/pool.d/

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM
CMD ["/usr/sbin/php-fpm7.4", "-F"]
