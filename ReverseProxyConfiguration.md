# Configuration

## Prerequisites

Before you begin, ensure that you have the following software installed on your system:

- Apache

## Steps

1. sudo mkdir -p /var/www/example.local
2. sudo cp example-site/example.conf /etc/httpd/conf.d/example.local.conf
3. sudo cp example-site/example-ssl.conf /etc/httpd/conf.d/example.local-ssl.conf
4. sudo ln -s certs/server.crt /etc/ssl/certs/server.crt
5. sudo ln -s certs/server.key /etc/ssl/certs/server.key
6. Enable mod_ssl
7. Enable mod_proxy