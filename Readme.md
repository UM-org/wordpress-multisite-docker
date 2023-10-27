# Docker Installation Guide

This guide provides step-by-step instructions for setting up and running the application using Docker.

## Prerequisites

Before you begin, ensure that you have the following software installed on your system:

- Docker: [Install Docker](https://docs.docker.com/get-docker/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

## Steps to Install and Run

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/UM-org/wordpress-multisite-docker
   cd wordpress-multisite-docker

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

5. **Access the Wordpress container:**
   
   ```bash
   docker-compose exec wordpress bash
   ```
   
6. **Access the Application's Dashboard:**
   
   You can now access the application's dashboard in your browser at https://localhost/wp-admin with the app credentials set in your .env file.

7. **Access phpMyAdmin:**
   
   You can now access phpMyAdmin in your browser at https://localhost:8080 with the database credentials set in your .env file.

   (If you're using this in production enivrement please make sure that port 8080 is open for inbound trafic.)  

8. **Stopping the Containers:**
   
   ```bash
   docker-compose down
   ```

## Steps to Set SSL Certificate

1. Copy your server.crt and server.key files to certs folder.

2. Restart Apache service in Wordpress Container:
   
    ```bash
   docker-compose exec wordpress service apache2 reload 
   ```

## Steps to Import Backup using WP All in one migration

1. Copy wpress file (***.wpress) to folder /var/lib/docker/volumes/wordpress-multisite-docker_wordpress/_data/wp-content/ai1wm-backups

2. Open https://localhost/wp-admin/network/admin.php?page=ai1wm_backups (You should see the ***.wpress file.)

3. Run Restore Action

Import may take long time. Just wait until it is finished.

## Additional Notes

- Modify the docker-compose.yml file to adjust container configurations as needed.
- Remember to secure sensitive information in your .env file.
- If you need to modify any wordpress configuration (enable WP_DEBUG for example) you can modify config/wp-config.php directly.
- If you need to modify php configuration (increase memory_limit for example) you can modify config/uploads.php directly then restart Apache service.
  
- For production deployment, make sure to follow Docker and Wordpress best practices.