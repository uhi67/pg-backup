#! /bin/bash
# Required environment variables:
#      APP_DB_HOST
#      APP_DB_PORT
#      APP_DB_NAME
#      APP_DB_USER
#      APP_DB_PASSWORD or APP_DB_PASSWORD_FILE
#      APP_BACKUP_DIR

if [ "$APP_DB_PASSWORD" == "" ]; then
  export APP_DB_PASSWORD=$(cat $APP_DB_PASSWORD_FILE)
fi
if [ "$APP_DB_PASSWORD" == "" ]; then
  echo "Warning: no password is set in APP_DB_PASSWORD neither APP_DB_PASSWORD_FILE ($APP_DB_PASSWORD_FILE)"
fi

echo "$APP_DB_HOST:*:*:$APP_DB_USER:$APP_DB_PASSWORD" > ~/.pgpass

if [ "$APP_DB_NAME" == "" ]; then
  echo "Error: No database name defined !"
  exit 1
fi

export PGPASSWORD="$APP_DB_PASSWORD"

if [ "$1" == "" ]; then
  echo "Usage: restore.sh <filename>"
  echo "Available files:"
  ls "$APP_BACKUP_DIR"
  exit 2
else
  if [ ! -f "$APP_BACKUP_DIR"/$1 ]; then
    echo "File $APP_BACKUP_DIR/$1 not found"
    exit 3
  fi
  echo "Restoring database $1..."
  gzip -d "$APP_BACKUP_DIR"/$1 | psql -h $APP_DB_HOST -p $APP_DB_PORT -U $APP_DB_USER -d $APP_DB_NAME -w
fi