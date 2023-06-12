# Use a suitable base image (e.g., Ubuntu, Debian, etc.)
FROM php:8.1.6-apache

# Install necessary packages
RUN apt-get update -y && apt-get install -y \ 
    wget \
    libmariadb-dev \
    && docker-php-ext-install mysqli \ 
    && docker-php-ext-install pdo_mysql

# Install WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz -C /var/www/html && \
    rm latest.tar.gz
WORKDIR /var/www/html

RUN mv -f wordpress/* .
# Set up custom plugins and themes (optional)
# COPY plugins/ /usr/src/wordpress/wp-content/plugins/
# COPY themes/ /usr/src/wordpress/wp-content/themes/

# Set up wordpress configuration
COPY ./config/wp-config.php /var/www/html/wp-config.php
COPY ./config/.htaccess /var/www/html/.htaccess
COPY ./config/install.php /var/www/html/wp-admin/install.php

# Install wp-cli
RUN cd /usr/local && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Set up Apache configuration
COPY ./config/apache.conf /etc/apache2/sites-available/000-default.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    service apache2 restart

COPY ./config/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
COPY ./config/cron.conf /etc/crontabs/www-data

# Expose port 80 for web traffic
EXPOSE 80

COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]