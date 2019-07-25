#!/bin/bash -e

su --preserve-environment -lc /new-site.sh frappe

exec supervisord --configuration /etc/supervisor/conf.d/supervisord.conf --nodaemon
