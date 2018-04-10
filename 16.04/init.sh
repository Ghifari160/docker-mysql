#!/bin/bash

function mysql_init_perms()
{
  service mysql start
  mysql -uroot -e 'CREATE USER "root"@"%";'
  mysql -uroot -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"localhost" WITH GRANT OPTION;'
  mysql -uroot -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%" WITH GRANT OPTION;'
  mysql -uroot -e 'FLUSH PRIVILEGES;'
  touch /etc/g16/mysql.state
}

if [ ! -f "/etc/g16/mysql.state" ]; then
  mysql_init_perms
fi

echo $MYSQL_ROOT_PASSWORD
