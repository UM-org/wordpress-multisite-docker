# Apache Reverse Proxy Configuration

## Prerequisites

Before you begin, ensure that you have the following software installed on your system:

- Apache2 with Reverse Proxy

## Steps

### Adapt container for reverse proxy mode

In order to access the application in reverse proxy mode, some modifications are needed in docker-compose.yml

1. Modify the docker-compose.yml file to expose port 8000 over ports 80 and 443.

2. Rebuild the container with port 8000 exposed as application's port.

    ```bash
    docker-compose down
    ```
    ```bash
    docker-compose up -d --build
    ```

### Configure Apache to serve the application in reverse proxy mode

Assuming the domain name is mydomain.com, the steps are:

1. Open the project directory :
    ```bash
    cd wordpress-multisite-docker
   ```

2. Copy VirtualHost config files :
    ```bash
    cp example.conf ./vhosts/mydomain.com.conf 
    ```
    ```bash
    cp example-ssl.conf ./vhosts/mydomain.com-ssl.conf 
    ```

3. Create site DocumentRoot :
    ```bash
    sudo mkdir -p /var/www/mydomain.com
    ```

4. Modify vhosts/mydomain.com.conf and vhosts/mydomain.com-ssl.conf content with your domain name.

5. Create new Virtual Host configuration files

    For RHEL-based distributions :
    ```bash
    sudo cp vhosts/mydomain.com.conf /etc/httpd/conf.d/
    ```
    ```bash
    sudo cp vhosts/mydomain.com-ssl.conf /etc/httpd/conf.d/
    ```
    
    For Debian-based distributions :
    ```bash
    sudo cp vhosts/mydomain.com.conf /etc/apache2/sites-available/
    ```
    ```bash
    sudo cp vhosts/mydomain.com.conf /etc/apache2/sites-available/
    ```

6. Add SSL certificate :
    ```bash
    sudo ln -s /home/$USER/wordpress-multisite-docker/certs/server.crt /etc/ssl/certs/server.crt
    ```
    ```bash
    sudo mkdir -p /etc/ssl/private
    ```
    ```bash
    sudo ln -s /home/$USER/wordpress-multisite-docker/certs/server.key /etc/ssl/private/server.key
    ```

7. Enable Apache mod_ssl

8. Enable Apache mod_proxy

9. Restart apache service

    For RHEL-based distributions :
    ```bash
    sudo systemctl restart httpd
    ```
    
    For Debian-based distributions :

    ```bash
    sudo a2ensite vhosts/mydomain.com.conf
    ```
    ```bash
    sudo a2ensitevhosts/mydomain.com-ssl.conf
    ```

    ```bash
    sudo service apache2 restart
    ```

10. Your application should be available at https://mydomain.com.