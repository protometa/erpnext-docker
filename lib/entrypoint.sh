#!/bin/bash -e

chown -R frappe /home/frappe/frappe-bench/sites

runuser -mu frappe /new-site.sh

exec supervisord --configuration /etc/supervisor/conf.d/supervisord.conf --nodaemon
