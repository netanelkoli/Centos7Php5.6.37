#!/bin/bash

#This script will install php 5.6.X on CentOS7
#Please wait Patiently while its finish all its configurations. The 'make' part should take a while...

##---------------Check if there's a network connection-----------##
ping 8.8.8.8 -c1 -w1 &>/dev/null
if [[ "$?" != 0 ]]; then
        echo " No active connection. Please check"
        exit
fi
##---------------Installing necessary packages--------------------##
sudo yum -y install make autoconf httpd httpd-devel php-pear gcc wget libxml2-devel openssl openssl-devel openssl-libs curl libcurl-devel libjpeg-turbo-devel libpng-devel freetype-devel libmcrypt libmcrypt-devel libxslt libxslt-devel
##------------------Download and install php------------------##
sleep 1
cd /tmp
wget http://ca1.php.net/get/php-5.6.37.tar.gz/from/this/mirror

tar -xf mirror

echo "extension=apc.so" > /etc/php.d/apc.ini
cd php-5.6.37

./buildconf --force
./configure --with-apxs2=/usr/bin/apxs --with-mysql
 
make -j $[$(lscpu |grep "CPU(s):"|head -1|tr -dc [0-9])*2]

sudo make install -j $[$(lscpu |grep "CPU(s):"|head -1|tr -dc [0-9])*2]

cp php.ini-development /usr/local/lib/php.ini

##================Check if httpd conf file is set================##
isIn=$(sudo cat /etc/httpd/conf/httpd.conf | grep -c "SetHandler application/x-httpd-php")


if [ $isIn -eq 0 ]; then
	sudo echo '<FilesMatch \.php$>'  >> /etc/httpd/conf/httpd.conf
	sudo echo  ' SetHandler application/x-httpd-php' >> /etc/httpd/conf/httpd.conf
	sudo echo '</FilesMatch>'>> /etc/httpd/conf/httpd.conf
fi
##===============================================================##
sudo systemctl restart httpd
##-------------------Set Firewall settings-----------------------##
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload



