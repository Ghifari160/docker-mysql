#!/bin/bash

set -m
set -e

function mysql_init()
{
  # Change root password to MYSQL_ROOT_PASSWORD
  mysqladmin -u root password $MYSQL_ROOT_PASSWORD

  # Create root user for host %
  mysql -uroot -p$MYSQL_ROOT_PASSWORD -e 'CREATE USER "root"@"%" IDENTIFIED BY "'${MYSQL_ROOT_PASSWORD}'"'

  # Grant all privileges to both root users
  mysql -uroot -p$MYSQL_ROOT_PASSWORD -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"localhost" WITH GRANT OPTION;'
  mysql -uroot -p$MYSQL_ROOT_PASSWORD -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%" WITH GRANT OPTION;'
  mysql -uroot -p$MYSQL_ROOT_PASSWORD -e 'FLUSH PRIVILEGES;'

  # Store g16 metadata
  mkdir -p /etc/g16
  touch /var/lib/mysql/g16_mysql_init
  echo "true" > /var/lib/mysql/g16_mysql_init
}

function macOS_fixPerms()
{
  if [ ! -f "/etc/g16/mysql_macOS_fix" ]; then
    echo "=============================="
    echo "=  Fixing macOS Permissions  ="
    echo "=============================="

    # Reassign UID and GID in macOS
    usermod -u 1000 mysql
    groupdel staff
    groupmod -g 50 mysql

    # Reconfigure file permissions
    chown -fR mysql:mysql /var/lib/mysql* /var/log/mysql* /var/run/mysqld
    chmod -fR 777 /var/lib/mysql* /var/log/mysql*

    # Store g16 metadata
    touch /etc/g16/mysql_macOS_fix
    echo "true" > /etc/g16/mysql_macOS_fix
  fi
}

if [ "$G16_MACOS" = "yes" ]; then
  macOS_fixPerms
fi

if [ ! -f "/var/lib/mysql/g16_mysql_setup" ]; then
  echo "=============================="
  echo "=      Setting up MySQL      ="
  echo "=============================="

  # Initialize MySQL installation
  mysqld --initialize-insecure > /dev/null 2>&1

  # Store g16 metadata
  touch /var/lib/mysql/g16_mysql_setup
  echo "true" > /var/lib/mysql/g16_mysql_setup
fi

echo "=============================="
echo "=       Starting MySQL       ="
echo "=============================="
mysqld_safe > /dev/null 2>&1 &
tail -F /var/log/mysql/error.log &

echo "=============================="
echo "=      Waiting for MySQL     ="
echo "=============================="
sleep 30s

if [ ! -f "/var/lib/mysql/g16_mysql_init" ]; then
  echo "=============================="
  echo "=      Initiating MySQL      ="
  echo "=============================="
  mysql_init
fi

echo "=============================="
echo "=        Ready to Use!       ="
echo "=============================="

fg
