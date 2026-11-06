#!/bin/bash
# Core3's /run.sh starts MariaDB only during first boot (firstboot/functions, core3_mysql_setup),
# so after a container restart the database is down and `run` cannot connect. Start it here on
# every boot that follows a first boot, then hand over to Core3's own entrypoint unchanged.

HOME_DIR=${HOME_DIR:-/home/swgemu}

# mysql_install_db creates the "mysql" system database; before first boot it does not exist yet
if [ -d "${HOME_DIR}/mysql/mysql" ]; then
    if ! /etc/init.d/mariadb start; then
        echo "core3-docker: WARNING: MariaDB did not start; see /var/log/mysql in the container" >&2
    fi
fi

exec /run.sh "$@"
