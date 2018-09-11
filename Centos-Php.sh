#!/bin/bash

#This script will install php 5.6.X on CentOS7
#Please Run this script as root
#Please wait Patiently while its finish all its configurations. The 'make' part should take a while...

##---------------Check if there's a network connection-----------##
ping 8.8.8.8 -c1 -w1 &>/dev/null
if [[ "$?" == 1 ]]; then
        echo " No active connection. Please check"
        exit
fi
##---------------Installing necessary packages--------------------##
yum -y install make autoconf httpd httpd-devel php-pear gcc wget libxml2-devel openssl openssl-devel openssl-libs curl libcurl-devel libjpeg-turbo-devel libpng-devel freetype-devel libmcrypt libmcrypt-devel libxslt libxslt-devel

sleep 1
cd /tmp
wget http://ca1.php.net/get/php-5.6.37.tar.gz/from/this/mirror

tar -xvf mirror

echo "extension=apc.so" > /etc/php.d/apc.ini
cd php-5.6.37

./buildconf --force
./configure --with-apxs2=/usr/bin/apxs --with-mysql

make

make install

#echo "extension=apc.so" > etc/php.d/apc.ini
cp php.ini-development /usr/local/lib/php.ini


echo '<FilesMatch \.php$>'  >> /etc/httpd/conf/httpd.conf
echo  ' SetHandler application/x-httpd-php' >> /etc/httpd/conf/httpd.conf
echo '</FilesMatch>'>> /etc/httpd/conf/httpd.conf

systemctl restart httpd
#systemctl restart php-fpm 

firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload



