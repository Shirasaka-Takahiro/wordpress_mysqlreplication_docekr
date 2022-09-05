#!/bin/bash

until mysqladmin ping -h primary_db --silent; do
    sleep 1
done

MYSQL_ROOT_PASSWORD='root'
log_file=`mysql -u root -p${MYSQL_ROOT_PASSWORD} -h primary_db -e 'SHOW MASTER STATUS \G' | grep File: | awk '{print $2}'`
pos=`mysql -u root -h primary_db -p${MYSQL_ROOT_PASSWORD} -e 'SHOW MASTER STATUS \G' | grep Position: | awk '{print $2}'`

mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CHANGE MASTER TO MASTER_HOST='primary_db', MASTER_USER='wordpress', MASTER_PASSWORD='wordpress', MASTER_LOG_FILE='${log_file}', MASTER_LOG_POS=${pos}"

mysql -u root -p${MYSQL_ROOT_PASSWORD} -e 'START SLAVE'
