#!/bin/bash -e

export HOME=/home/frappe
export PATH=/home/frappe/.local/bin:$PATH

cd ~/frappe-bench

bench set-mariadb-host $DB_HOST

bench new-site site1.local --force \
  --mariadb-root-password "$DB_ROOT_PASSWORD" \
  --admin-password "$ADMIN_PASSWORD" \
  --db-name $DB_NAME \
  --install-app erpnext

bench set-config -g redis_cache $REDIS_CACHE
bench set-config -g redis_queue $REDIS_QUEUE
bench set-config -g redis_socketio $REDIS_SOCKETIO

# bench --site site1.local set-config db_name $DB_NAME 
# bench --site site1.local set-config encryption_key "$ENCRYPTION_KEY"
# bench --site site1.local set-config db_password "$DB_PASSWORD"
