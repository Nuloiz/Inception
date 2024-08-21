# Use Debian Buster as the base image
FROM debian:buster

# Set the WordPress version
ENV WORDPRESS_VERSION 5.8.1

# Install PHP, PHP-FPM, and necessary PHP extensions
RUN apt-get update && apt-get install -y \
    php7.3 \
    php7.3-fpm \
    php7.3-mysql \
    php7.3-zip \
    php7.3-gd \
    php7.3-mbstring \
    php7.3-curl \
    php7.3-xml \
    php7.3-json \
    php7.3-opcache \
    curl \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create the /var/www/html directory
WORKDIR /var/www/html/ 

# Copy the download script into the container
COPY /tools/download_wp.sh /usr/local/bin/download_wp.sh

# Make the script executable
RUN chmod +x /usr/local/bin/download_wp.sh

# Run the script to download and set up WordPress
RUN /usr/local/bin/download_wp.sh

# Copy custom www.conf to the correct directory
COPY /conf/www.conf /etc/php/7.3/fpm/pool.d/

# Download WordPress without checksum verification
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
    && tar -xzf wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm wordpress.tar.gz

# Set correct permissions for the WordPress files
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm7.3"]
