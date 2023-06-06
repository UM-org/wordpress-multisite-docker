FROM wordpress:6.2.2
COPY ./data/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
COPY ./data/cron.conf /etc/crontabs/www-data
RUN chmod 600 /etc/crontabs/www-data
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN service apache2 restart
CMD ["apache2-foreground"]