FROM ghifari160/ubuntu:18.04

LABEL MAINTAINER "Ghifari160 <ghifari160@ghifari160.com>"

# Disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# Install MySQL server
RUN apt update && apt install -y mysql-server && apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/mysql/conf.d/mysqld_safe_syslog.cnf

# Custom MySQL configuration to disable bind-address
ADD mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
RUN chown mysql:mysql /etc/mysql/mysql.conf.d/mysqld.cnf

# Create MySQL socket / lock directory
RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld

# Add init script
ADD init.sh /etc/g16/init.sh
RUN chown root:root /etc/g16/init.sh && \
    chmod 755 /etc/g16/init.sh

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

ENTRYPOINT ["/etc/g16/init.sh"]
