#!/bin/bash
# ------------------------------------------------------------------
# [hassabdo] 
# This script is used to import a wordpress backup
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=wp-migrator
USAGE="Usage: ./import.sh -fhv args"

# --- Options processing -------------------------------------------
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

while getopts ":f:vh" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "f") filename=${OPTARG}
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

while getopts f: flag
do
    case "${flag}" in
        f) filename=${OPTARG};;
    esac
done

filepath="${BACKUP_DIR}/${filename}"

if [ -e $filepath ]; then
  echo "Backup file exists."

  echo "Unzipping backup file..."
  unzip ${filepath} -d $TEMPD

  dump="${TEMPD}/db_dump.sql"

  if [ -f $db_dump ]; then
    echo "Importing db dump..."
    wp db import $dump --path=${WORDPRESS_PATH} --allow-root
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