#!/bin/bash

# Terminate execution if any command fails
set -e

# Replace cron schedule from environment
if [ "$CRON_SCHEDULE" = "" ]; then
    CRON_SCHEDULE="21 1 * * *"
fi
sed -i "s/\$CRON_SCHEDULE/$CRON_SCHEDULE/g" /etc/cron.d/postgres-backup
cat /etc/cron.d/postgres-backup

echo "*** starting cron"
crontab /etc/cron.d/postgres-backup
exec cron -f
