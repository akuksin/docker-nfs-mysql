#!/bin/bash
set -e
NFSVOLUME="/var/lib/mysql"
echo '* Update "mysql" user to apply the same uid and gid as the host volume'
TARGET_UID=$(stat -c "%u" $NFSVOLUME)
echo '-- Setting mysql user to use uid '$TARGET_UID
usermod -o -u $TARGET_UID mysql || true
TARGET_GID=$(stat -c "%g" $NFSVOLUME)
echo '-- Setting mysql group to use gid '$TARGET_GID
groupmod -o -g $TARGET_GID mysql || true
echo '-- Setting /var/run/mysqld/ '
chown -R mysql:root /var/run/mysqld/ /var/log/
echo "chown -R mysql:root /var/run/mysqld/"
echo "Initialize empty data volume and create MySQL user"
if [[ ! -f $NFSVOLUME/mysql ]]; then
        echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
        echo "=> Installing MySQL ..."
        # for mysql 5.7 and higher mysql_install_db is depricated
        runuser -l mysql -c "mysql_install_db --user=mysql > $NFSVOLUME/install.log 2>&1"
        #mysql_install_db --user=mysql --datadir=$NFSVOLUME/mysql > $NFSVOLUME/install.log 2>&1
        #runuser -l mysql -c "mysqld --user=mysql  --datadir=$NFSVOLUME/mysql --initialize-insecure;"
        echo "=> Mysql database installation is Done."
else
        echo "=> Using an existing volume of MySQL"
fi
echo "Start the MySQL daemon in the background."
# As of MySQL 5.7.6, for MySQL installation using an RPM distribution,
# server startup and shutdown is managed by systemd on several Linux platforms.
# On these platforms, mysqld_safe is no longer installed because it is unnecessary.
# For more information, see Section 2.5.10, .Managing MySQL Server with systemd..
runuser -l mysql -c "/usr/bin/mysqld_safe"
# mysqld_safe
