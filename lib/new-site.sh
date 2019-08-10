#!/bin/bash -e

export HOME=/home/frappe
export PATH=/home/frappe/.local/bin:$PATH

cd ~/frappe-bench

bench set-mariadb-host $DB_HOST

bench set-config -g redis_cache $REDIS_CACHE
bench set-config -g redis_queue $REDIS_QUEUE
bench set-config -g redis_socketio $REDIS_SOCKETIO

# if sites/site1.local/site_config.json doesn't exist 
if [ ! -f sites/site1.local/site_config.json ]; then
  bench new-site site1.local \
    --mariadb-root-password "$DB_ROOT_PASSWORD" \
    --admin-password "$ADMIN_PASSWORD" \
    --install-app erpnext
fi
