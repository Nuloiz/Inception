# Dockerfile for WordPress with PHP-FPM
FROM php:8.0-fpm

# Set environment variables for PHP and WordPress
ENV WORDPRESS_VERSION 5.8.1
ENV WORDPRESS_SHA1 5056a65e09145c3c1e39e032c8a2f07e4a027e57

# Install necessary PHP extensions and tools
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mbstring zip mysqli pdo pdo_mysql \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and verify WordPress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
    && echo "${WORDPRESS_SHA1} *wordpress.tar.gz" | sha1sum -c - \
    && tar -xzf wordpress.tar.gz -C /var/www/html --strip-components=1 \
    && rm wordpress.tar.gz

# Set ownership and permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port for PHP-FPM
EXPOSE 9000

# Start PHP-FPM service
CMD ["php-fpm"]
