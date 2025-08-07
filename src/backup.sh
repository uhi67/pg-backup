#! /bin/bash
# Required environment variables:
#      APP_DB_HOST
#      APP_DB_PORT
#      APP_DB_NAME
#      APP_DB_USER
#      APP_DB_PASSWORD
#      APP_BACKUP_DIR

echo "$APP_DB_HOST:*:*:$APP_DB_USER:$APP_DB_PASSWORD" > ~/.pgpass

if [ "$APP_DB_NAME" == "" ]
then
 echo "Error: No database defined !"
 exit 1
fi
TIMESTAMP=`date "+%Y-%m-%d_%H-%M-%S"`
export PGPASSWORD="$APP_DB_PASSWORD"

echo "Starting backup into: $APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.gz"
pg_dump -h $APP_DB_HOST -p $APP_DB_PORT -U $APP_DB_USER -w $APP_DB_NAME 2> "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.log" | gzip -c > "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.tmp"
mv "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.tmp" "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.gz"
cp "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.log" "$APP_BACKUP_DIR/$APP_DB_NAME-last.log"
echo "Backup finished successfully."
exit 0

# Restore
# gzip -d "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP".gz | psql -h $APP_DB_HOST -p $APP_DB_PORT -u $APP_DB_USER -w
