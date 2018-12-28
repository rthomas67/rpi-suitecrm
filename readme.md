Dockerfile Notes for RaspberryPi SuiteCRM

Derived from the docker build for mariadb from jsurf
* https://github.com/JSurf/docker-rpi-mariadb/blob/master/Dockerfile
* Uses the same base container
  * https://github.com/JSurf/docker-rpi-raspbian
    * which is forked from https://github.com/balena-io-library/armv7hf-debian-qemu

SuiteCRM install parts based on bitnami-docker-suitecrm
* https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/7/debian-9/Dockerfile

# SuiteCRM "SilentInstall" Patches
Using SilentInstall with '''setup_db_create_database = 0''' _should_ leave the database alone.
However, the SuiteCRM install code is broken in several places.  The patch files that are
applied at the end of the container construction fix things enough that the setup
can initialize the config.php file without overwriting tables and data (including SuiteCRM users).

This has been reported to the SuiteCRM project in case they want to make it work right.
* https://github.com/salesagility/SuiteCRM/issues/6692

# nginx pgp-fpm
* The servername in the nginx config must match the public host.domain name used
to access SuiteCRM or the PHP scripts/browser will complain about XSRF issues.
There is probably not really a Cross Site Request Forgery (and Cross doesn't really
start with X) but the site header seems to get crossed up at the php-fpm layer.

# Editing Notes
* ALWAYS convert scripts to UNIX format with LF instead of CR/LF
* ALWAYS check for (and remove) whitespace characters after line continuation slash character

# TODO
* Map persistent volumes for uploaded data so it doesn't have to be extracted from the container and wouldn't be lost if the container crashed.
* Add scripts for backing up and restoring the static files (uploads) and the MariaDB database (assuming a high likelihood of starting with this container and migrating to a "real" installation later.)