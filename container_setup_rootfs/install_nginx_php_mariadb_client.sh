#!/usr/bin/qemu-arm-static /bin/sh

apt-get -y purge apache2 apache2-utils
apt-get -y autoremove

apt-get -y install mariadb-client
apt-get -y install php-fpm php-mysql php-xml php-zip php-curl php-imap php-gd
apt-get -y install nginx

# This is used to run both nginx and php-fpm using a single CMD (docker main process)
apt-get -y install supervisor

# By default, supervisor is enabled as a system service, but in the docker container
# it is only started manually by the docker ENTRYPOINT, so stop and disable the system service.

# This gives an error anyway... guess it isn't needed:  systemctl stop supervisor
systemctl disable supervisor