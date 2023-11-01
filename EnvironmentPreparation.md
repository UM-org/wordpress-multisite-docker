# Installation Guide

This guide provides step-by-step instructions for setting up the system environment.

## Steps

1. **Create new user:**

   ```bash
   sudo useradd <custom_user>
   ```
2. **Set new password for user:**

   ```bash
   sudo passwd <custom_user>
   ```

3. **Grant sudo access to into the administrative wheel group:**
   
   ```bash
   sudo usermod -aG wheel <custom_user>
   ```

4. **Login as the new user:**
   
   ```bash
   su <custom_user>
   ```

5. **Add the user to docker group:**

   Make sure docker is installed and has created docker group

   ```bash
   sudo usermod -aG docker <custom_user>
   ```

6. **Check if user was successfully added to docker group:**
   
   Logout and login again and run :

   ```bash
   sudo groups <custom_user>
   ```

   This command should return docker in group list

7. **Install httpd :**
   
   ```bash
   sudo yum update
   ```
   ```bash
   sudo yum install httpd
   ```