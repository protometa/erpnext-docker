#!/usr/bin/env bash

bench set-mariadb-host $DB_HOST

bench new-site site1.local --force \
  --mariadb-root-password "$DB_ROOT_PASSWORD" \
  --admin-password "$ADMIN_PASSWORD"

bench --site site1.local set-config db_name $DB_NAME 
bench --site site1.local set-config db_password "$DB_PASSWORD"
# bench --site site1.local set-config db_password "$ENCRYPTION_KEY"

bench --site site1.local install-app erpnext
