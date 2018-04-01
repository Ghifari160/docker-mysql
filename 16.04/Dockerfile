FROM ghifari160/ubuntu:16.04

MAINTAINER Ghifari160 <ghifari160@ghifari160.com>

# Disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# Install MySQL server
RUN apt update && apt install -y mysql-server && apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create MySQL socket / lockfile
RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld

# Custom MySQL configuration to disable bind-address
ADD mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
RUN chown mysql:mysql /etc/mysql/mysql.conf.d/mysqld.cnf

# Change root password to $MYSQL_ROOT_PASSWORD and open access to all hosts
RUN service mysql start && \
    mysql -uroot -e 'CREATE USER "root"@"%";' && \
    mysql -uroot -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"localhost" WITH GRANT OPTION;' && \
    mysql -uroot -e 'GRANT ALL PRIVILEGES ON *.* TO "root"@"%" WITH GRANT OPTION;' && \
    mysql -uroot -e 'FLUSH PRIVILEGES;'

# Symlink MySQL logs to stdio
RUN ln -sf /proc/self/fd/1 /var/log/mysql/error.log

VOLUME ["/var/lib/mysql"]

CMD ["mysqld_safe"]
