#!/bin/bash
export PATH=$PATH:/usr/local/mysql/bin
#Configuring Wordpress

# Run WP-CLI Info
wp --info

retVal=$?

PLUGINS_PATH="/home/default-plugins"
WORDPRESS_PATH="/var/www/html"

retries=1
DB_CONNECTED=false

while [ $retries -lt 4 ]; do
  echo "Trying to connect to DB..."
  echo "Attempt ${retries}"
  DB_CHECK=$(wp db check --path=${WORDPRESS_PATH} --allow-root)
  echo "Checking DB..."
  echo $DB_CHECK
  if [[ $DB_CHECK == *"Success: Database checked." ]]; then
    DB_CONNECTED=true
    echo "Connected to DB."
    break
  else
    retries=$(($retries + 1))
    sleep 10
  fi
done

if [ $DB_CONNECTED = true ]; then
  wp core is-installed --path=${WORDPRESS_PATH} --network --allow-root
  IS_INSTALLED=$(($retVal))
  echo "Wordpress multisite is installed : ${IS_INSTALLED}"
  if [ $IS_INSTALLED -eq 0 ]; then
    #Creating wordpress installation
    echo "Installing wordpress..."
    echo "App URL : ${APP_URL}"
    wp core multisite-install --path=${WORDPRESS_PATH} \
      --title="${APP_NAME}" \
      --url="${APP_URL}" \
      --admin_user="${APP_ADMIN_NAME}" \
      --admin_email="${APP_ADMIN_EMAIL}" \
      --admin_password="${APP_ADMIN_PASSWORD}" \
      --skip-email \
      --allow-root
  fi

  chown -R www-data:www-data $WORDPRESS_PATH
  echo "Wordpress is ready."
  echo "App URL : ${APP_URL}"
else
  echo "Failed to connect to DB!"
fi