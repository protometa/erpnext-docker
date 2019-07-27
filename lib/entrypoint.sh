#!/bin/bash -e

runuser -mu frappe /new-site.sh

exec supervisord --configuration /etc/supervisor/conf.d/supervisord.conf --nodaemon
