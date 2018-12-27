#!/usr/bin/qemu-arm-static /bin/sh

# Note: The main php package is NOT installed here because it is bundled with
# the Apache2 web server.  This setup will use nginx + php-fpm _instead_ of Apache2

apt-get -y install mariadb-client
apt-get -y install php-fpm php-mysql php-xml php-zip php-curl php-imap php-gd
apt-get -y install nginx

pi_php_ini_file=/etc/php/7.0/fpm/conf.d/90-pi-custom.ini
echo "cgi.fix_pathinfo=0" > $pi_php_ini_file
echo >> $pi_php_ini_file
echo "upload_max_filesize=64m" >> $pi_php_ini_file
echo "post_max_size=64m" >> $pi_php_ini_file
echo "max_execution_time=600" >> $pi_php_ini_file

docker_php_ini_file=/etc/php/7.0/fpm/conf.d/91-docker-custom.ini
echo "error_log = /dev/stderr" > $docker_php_ini_file

# Leaving this out may result in an error like:
#    ERROR: unable to bind listening socket for address '/run/php/php7.0-fpm.sock': No such file or directory (2)
mkdir -p /run/php