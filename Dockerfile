# Use a suitable base image (e.g., Ubuntu, Debian, etc.)
FROM php:8.1.6-apache

# Install necessary packages
RUN apt-get update -y && apt-get install -y \ 
    wget \
    zip \
    unzip \
    default-mysql-client \
    libmariadb-dev \
    && docker-php-ext-install mysqli \ 
    && docker-php-ext-install pdo_mysql

# Install WordPress 6.3.1
RUN wget https://wordpress.org/wordpress-6.3.1.tar.gz && \
    tar -xvzf wordpress-6.3.1.tar.gz -C /var/www/html && \
    rm wordpress-6.3.1.tar.gz
WORKDIR /var/www/html
RUN mv -f wordpress/* .
RUN rm -rf wordpress

RUN chown -R www-data:www-data .

# Set up wordpress configuration
COPY ./config/wp-config.php /var/www/html/wp-config.php
COPY ./config/.htaccess /var/www/html/.htaccess

# Install wp-cli
RUN cd /usr/local && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Set up Apache configuration
ARG ServerName

COPY ./config/apache.conf /etc/apache2/sites-available/000-default.conf
COPY ./config/apache-ssl.conf /etc/apache2/sites-available/default-ssl.conf

RUN sed -i '/SSLCertificateFile.*snakeoil\.pem/c\SSLCertificateFile \/etc\/ssl\/certs\/server.crt' /etc/apache2/sites-available/default-ssl.conf && sed -i '/SSLCertificateKeyFile.*snakeoil\.key/cSSLCertificateKeyFile /etc/ssl/private/server.key\' /etc/apache2/sites-available/default-ssl.conf
RUN echo "ServerName ${ServerName}" >> /etc/apache2/apache2.conf && \
    a2enmod rewrite && \
    a2enmod ssl && \
    service apache2 restart
    
COPY ./config/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
COPY ./config/cron.conf /etc/crontabs/www-data

RUN a2ensite default-ssl

COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY ./scripts/install.sh /usr/bin/install.sh
COPY ./scripts/export.sh /usr/bin/export.sh
COPY ./scripts/import.sh /usr/bin/import.sh

RUN chmod +x /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/install.sh
RUN chmod +x /usr/bin/export.sh
RUN chmod +x /usr/bin/import.sh

ENTRYPOINT [ "entrypoint.sh" ]