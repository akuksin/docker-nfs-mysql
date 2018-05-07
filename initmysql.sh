#!/bin/bash
set -e

echo '* Update "mysql" user to apply the same uid and gid as the host volume'
TARGET_UID=$(stat -c "%u" /var/lib/mysql)
echo '-- Setting mysql user to use uid '$TARGET_UID
usermod -o -u $TARGET_UID mysql || true
TARGET_GID=$(stat -c "%g" /var/lib/mysql)
echo '-- Setting mysql group to use gid '$TARGET_GID
groupmod -o -g $TARGET_GID mysql || true
echo '-- Setting /var/run/mysqld/ '
chown -R mysql:root /var/run/mysqld/
echo "chown -R mysql:root /var/run/mysqld/"
runuser -l mysql -c 'mkdir -p /var/lib/mysql'
runuser -l mysql -c 'rm -rf /var/lib/mysql/mysql'
echo `ls /var/lib/mysql`
echo "Initialize empty data volume and create MySQL user"
if [[ ! -d /var/lib/mysql/mysql ]]; then
	echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
	echo "=> Installing MySQL ..."
	runuser -l mysql -c 'mysql_install_db --user=mysql >/dev/null 2>&1'
	echo "=> Installing Done."
else
	echo "=> Using an existing volume of MySQL"
fi
echo "Start the MySQL daemon in the background."
/usr/bin/mysqld_safe
