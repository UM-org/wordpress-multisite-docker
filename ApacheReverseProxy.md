# Configuration

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

Assuming the domain name is example.com, the steps are:

1. Open the project directory :
    ```bash
    cd wordpress-multisite-docker
   ```

2. Create site DocumentRoot :
    ```bash
    sudo mkdir -p /var/www/example.com
    ```

3. Modify example-site/example.conf and example-site/example-ssl.conf with your custom domain name.

4. Create new Virtual Host configuration files

    For RHEL-based distributions :
    ```bash
    sudo cp example-site/example.conf /etc/httpd/conf.d/example.com.conf
    ```
    ```bash
    sudo cp example-site/example-ssl.conf /etc/httpd/conf.d/example.com-ssl.conf
    ```
    
    For Debian-based distributions :
    ```bash
    sudo cp example-site/example.conf /etc/apache2/sites-available/example.com.conf
    ```
    ```bash
    sudo cp example-site/example-ssl.conf /etc/apache2/sites-available/example.com-ssl.conf
    ```

5. Add SSL certificate :
    ```bash
    sudo ln -s /home/$USER/wordpress-multisite-docker/certs/server.crt /etc/ssl/certs/server.crt
    ```
    ```bash
    sudo mkdir -p /etc/ssl/private
    ```
    ```bash
    sudo ln -s /home/$USER/wordpress-multisite-docker/certs/server.key /etc/ssl/private/server.key
    ```

6. Enable Apache mod_ssl

7. Enable Apache mod_proxy

8. Restart apache service

    For RHEL-based distributions :
    ```bash
    sudo systemctl restart httpd
    ```
    
    For Debian-based distributions :

    ```bash
    sudo a2ensite example.com.conf
    ```
    ```bash
    sudo a2ensite example.com-ssl.conf
    ```

    ```bash
    sudo service apache2 restart
    ```

9. Your application should be available at https://example.com.