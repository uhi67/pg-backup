pg-backup
=========

A side-car container to backup PostgreSQL database

Example usage
-------------

```yml
  backup:
    image: uhi67/pg-backup:latest
    restart: unless-stopped
    volumes:
      - ./docker-data/backup:/var/backup
    environment:
      APP_DB_HOST: db
      APP_DB_PORT: 5432
      APP_DB_USER: $APP_DB_USER
      APP_DB_PASSWORD: $APP_DB_PASSWORD
      APP_DB_NAME: $APP_DB_NAME
      APP_BACKUP_DIR: /var/backup
      CRON_SCHEDULE: "*\\/15 * * * *" # Note: slashes must be escaped
    networks:
      - app
```

Development informations
-------------------------

1. The image is automatically built on GitHub triggered by push operations.
