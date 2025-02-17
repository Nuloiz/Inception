FROM debian:bullseye

ENV WORDPRESS_VERSION 5.8.1

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

WORKDIR /var/www/html/

RUN mkdir -p /run/php

COPY ./tools/download_wp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/download_wp.sh

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/download_wp.sh"]

CMD ["/usr/sbin/php-fpm7.4", "-F"]