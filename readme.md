Dockerfile Notes for RaspberryPi SuiteCRM

Derived from the docker build for mariadb from jsurf
* https://github.com/JSurf/docker-rpi-mariadb/blob/master/Dockerfile
* Uses the same base container
  * https://github.com/JSurf/docker-rpi-raspbian
    * which is forked from https://github.com/balena-io-library/armv7hf-debian-qemu

SuiteCRM install parts based on bitnami-docker-suitecrm
* https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/7/debian-9/Dockerfile

# nginx pgp-fpm
* The servername in the nginx config must match the public host.domain name used
to access SuiteCRM or the PHP scripts/browser will complain about XSRF issues.
There is probably not really a Cross Site Request Forgery (and Cross doesn't really
start with X) but the site header seems to get crossed up at the php-fpm layer.

# Editing Notes
* ALWAYS convert scripts to UNIX format with LF instead of CR/LF
* ALWAYS check for (and remove) whitespace characters after line continuation slash character
