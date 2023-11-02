#!/bin/bash
# ------------------------------------------------------------------
# [hassabdo] 
# This script is used to import a wordpress backup
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=wp-migrator
USAGE="Usage: import.sh -f <filename:required> -d <backup_domain_name:optional>"

# --- Options processing -------------------------------------------
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

domain=$APP_DOMAIN

while getopts ":f:d:vh" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "f") filename=${OPTARG}
        ;;
      "d") domain=${OPTARG}
        ;;
      "h")
        echo $USAGE
        exit 0;
        ;;
      "?")
        echo "Unknown option $OPTARG"
        exit 0;
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        exit 0;
        ;;
      *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done

export PATH=$PATH:/usr/local/mysql/bin

GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
NC=$'\e[0m'

WORDPRESS_PATH="/var/www/html"
BACKUP_DIR="/home/backups"

# Create a temporary directory.
TEMPD=$(mktemp -d)

# Exit if the temp directory wasn't created successfully.
if [ ! -e "$TEMPD" ]; then
    >&2 echo "${RED}Failed to create temp directory${NC}"
    exit 1
fi

filepath="${BACKUP_DIR}/${filename}"

if [ -e $filepath ]; then
  echo "Backup file exists."

  echo "Unzipping backup file..."
  unzip ${filepath} -d $TEMPD

  dump="${TEMPD}/db_dump.sql"
  if [ -f $db_dump ]; then
    echo "Importing db dump..."
    wp db import $dump --path=${WORDPRESS_PATH} --allow-root
    if [ $domain != $APP_DOMAIN ]; then
      echo "Backup App URL is different from current App URL !"
      echo "Updating App Url..."
      wp search-replace $domain $APP_DOMAIN --path=${WORDPRESS_PATH} --allow-root --all-tables
    fi
    
    echo "Recovering admin informations..."
    echo "Changing admin_email..."
    wp option update admin_email $APP_ADMIN_EMAIL --path=${WORDPRESS_PATH} --allow-root

    echo "Changing admin_name and admin_password..."
    wp user update 1 --user_email="$APP_ADMIN_EMAIL" --user_pass="$APP_ADMIN_PASSWORD" --path=${WORDPRESS_PATH} --allow-root

    echo "Copying app..."
    cp -afr $TEMPD/app/. $WORDPRESS_PATH
    chown -R www-data:www-data $WORDPRESS_PATH
    echo "${GREEN}Backup succeded !${NC}"
  else
    echo "${RED}DB dump file doesn't exists.${NC}"
    exit 1
  fi
else
  echo "${RED}Backup file doesn't exists.${NC}"
  exit 1
fi

# Make sure the temp directory gets removed on script exit.
trap "exit 1"           HUP INT PIPE QUIT TERM
trap 'rm -rf "$TEMPD"'  EXIT