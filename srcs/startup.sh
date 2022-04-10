#!/bin/bash

openssl req -newkey rsa:4096 \
		-x509 \
		-sha256 \
		-days 365 \
		-nodes \
		-out /etc/ssl/certs/localhost.crt \
		-keyout /etc/ssl/private/localhost.key

apt install postfix
cp /root/srcs/master.cf /etc/postfix/master.cf
cp /root/srcs/main.cf /etc/postfix/main.cf
/etc/init.d/postfix start
/etc/init.d/postfix reload

sudo adduser dovecot mail
cp /root/srcs/dovecot.conf /etc/dovecot/dovecot.conf
cp /root/srcs/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
cp /root/srcs/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
cp /root/srcs/10-master.conf /etc/dovecot/conf.d/10-master.conf
cp /root/srcs/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf
/etc/init.d/dovecot restart

rm -rf /etc/nginx/sites-enabled/*
cp /root/srcs/localhost.conf /etc/nginx/sites-enabled/

mkdir /var/www/localhost/

wget -O /root/srcs/roundcubemail-1.5.2.tar.gz https://github.com/roundcube/roundcubemail/releases/download/1.5.2/roundcubemail-1.5.2-complete.tar.gz
tar -xf /root/srcs/roundcubemail-1.5.2.tar.gz -C /root/srcs/
cp -r /root/srcs/roundcubemail-1.5.2/* /var/www/localhost/

## Install Composer
bash /root/srcs/composer.sh

cd /var/www/localhost/
composer require guzzlehttp/guzzle

chown www-data:www-data /var/www
chown www-data:www-data -R /var/www/*

find /var/www/* -type d -exec chmod 755 {} \;
find /var/www/* -type f -exec chmod 644 {} \;

/etc/init.d/mariadb start
/etc/init.d/mariadb status

echo "CREATE DATABASE roundcube;" | mysql -u root
echo "CREATE USER 'roundcubeuser'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "GRANT ALL PRIVILEGES ON roundcube.* TO 'roundcubeuser'@'localhost';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root
sudo mysql roundcube < /var/www/localhost/SQL/mysql.initial.sql

/etc/init.d/php7.4-fpm start
/etc/init.d/php7.4-fpm status

/etc/init.d/nginx start
/etc/init.d/nginx reload
/etc/init.d/nginx status

/bin/bash
