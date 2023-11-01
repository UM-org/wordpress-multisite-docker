# Installation Guide

This guide provides step-by-step instructions for setting up and running the application using Docker.

## Prerequisites

Before you begin, ensure that you have the following software installed on your system:

- Git
- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

## Steps to Install and Run

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/UM-org/wordpress-multisite-docker
   cd wordpress-multisite-docker
   ```

2. **Copy Environment Variables:**
   
   ```bash
   cp .env.example .env
   ```

3. **Configure Environment Variables:**
   
   Open the .env file and set the necessary environment variables, such as database connection details and application settings.

4. **Build and Start the Docker Containers:**
   
   ```bash
   docker-compose up -d --build
   ```

5. **Access the Application's Dashboard:**
   
   After build is finished, you should wait until the wordpress app is installed before you can access the application's dashboard in your browser at https://localhost/wp-admin with the app credentials set in your .env file.

6. **Access phpMyAdmin:**
   
   You can now access phpMyAdmin in your browser at https://localhost:8080 with the database credentials set in your .env file.

   (If you're using this in production environnement please make sure that port 8080 is open for inbound trafic.)  

7. **Stopping the Containers:**
   
   ```bash
   docker-compose down
   ```

## Steps to Set SSL Certificate

1. Copy your server.crt and server.key files to certs folder.

2. Restart Apache service in Wordpress Container:
   
    ```bash
   docker-compose exec wordpress service apache2 reload 
   ```

## Steps to Export/Import Backup

Make sure your containers are running.

- Export :
  
    ```bash
   docker-compose exec wordpress /usr/bin/export.sh
   ```
   If the export was successfully executed, you should see a new wp-backup-XXXXXXXXXXX.zip file created in your BACKUP_DIR (./backups by default).

- Import :
  
    ```bash
   docker-compose exec wordpress /usr/bin/import.sh -f wp-backup-XXXXXXXXXXX.zip
   ```
   where wp-backup-XXXXXXXXXXX.zip is the backup file in your BACKUP_DIR (./backups by default).


## Apache Reverse Proxy Configuration

For production deployment using reverse proxy mode see [Apache Reverse Proxy Configuration](ApacheReverseProxy.md).

## Additional Notes

- Modify the docker-compose.yml file to adjust container configurations as needed.
- Remember to secure sensitive information in your .env file.
- If you need to modify any wordpress configuration (enable WP_DEBUG for example) you can modify config/wp-config.php directly.
- If you need to modify php configuration (increase memory_limit for example) you can modify config/uploads.php directly then restart Apache service.
- For production deployment, make sure to follow Docker and Wordpress best practices.