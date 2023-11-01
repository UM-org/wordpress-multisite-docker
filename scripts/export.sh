#!/bin/bash
# ------------------------------------------------------------------
# [hassabdo] 
# This script is used to create a wordpress backup
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=wp-migrator

export PATH=$PATH:/usr/local/mysql/bin

WORDPRESS_PATH="/var/www/html"
OUTPUT="/home/backups"

EXPORTNAME=wp-backup-$(date +%Y%m%d%H%M%S)
# Create a temporary directory.
TEMPD=$(mktemp -d -t ${EXPORTNAME}-XXXX)

# Exit if the temp directory wasn't created successfully.
if [ ! -e "$TEMPD" ]; then
    >&2 echo "Failed to create temp directory"
    exit 1
fi

if [ -d $OUTPUT ]; then
  echo "Output Directory exists."
  echo "Exporting to ${OUTPUT}..."
  echo "Creating db dump..."
  wp db export $TEMPD/db_dump.sql --path=${WORDPRESS_PATH} --allow-root
  echo "Copying app..."
  cp -afr $WORDPRESS_PATH $TEMPD/app
  cd $TEMPD
  zip -r ${OUTPUT}/${EXPORTNAME}.zip ./*
  echo "Backup file successuffly created !"
  echo "File Path : $BACKUP_DIR/${EXPORTNAME}.zip"
else
  echo "Output Directory doesn't exists."
  exit 1
fi

# Make sure the temp directory gets removed on script exit.
trap "exit 1"           HUP INT PIPE QUIT TERM
trap 'rm -rf "$TEMPD"'  EXIT