#!/bin/sh
# https://www.raspberrypi.org/learning/lamp-web-server-with-wordpress/worksheet/

sudo apt-get install apache2 -y
# default page is at /var/www/html/index.html

# php
sudo apt-get install php5 libapache2-mod-php5 -y

cd /var/www/html
sudo rm index.html
sudo echo "<?php echo date('Y-m-d H:i:s'); ?>" > index.php

# mysql
# THIS IS INTERACTIVE
sudo apt-get install mysql-server php5-mysql -y

cd /var/www/html/
sudo chown pi: .
sudo rm *
wget http://wordpress.org/latest.tar.gz

tar xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz

mysql -uroot -p

#mysql> create database wordpress;