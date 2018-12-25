#!/usr/bin/qemu-arm-static /bin/sh

# The list of base library packages comes from:
#  https://github.com/bitnami/bitnami-docker-suitecrm/blob/master/7/debian-9/Dockerfile

# Find packages using google search
#    site:www.raspberryconnect.com/raspbian-packages-list thepackagename
# Most libraries are found here:
# http://www.raspberryconnect.com/raspbian-packages-list/item/110-raspbian-libs

# ALERT.  If the \ at the end of a line is followed by ANY whitespace character(s),
# the next line will not be part of the same command and Docker build will 
# report something like   --> libssl1.1 not found.
# This isn't a failure of apt-get.  It is an indication that the package
# name is being interpreted as the next command.

# ls /etc/apt/apt.conf.d

apt-get -y install --no-install-recommends \
    ca-certificates \
    libbz2-1.0 \
    libc6 \
    libcomerr2 \
    libcurl3 \
    libexpat1 \
    libffi6 \
    libfreetype6 \
    libgcc1 \
    libgcrypt20 \
    libgmp10 \
    libgnutls30 \
    libgpg-error0 \
    libgssapi-krb5-2 \
    libhogweed4 \
    libicu57 \
    libidn11 \
    libidn2-0 \
    libjpeg62-turbo \
    libk5crypto3 \
    libkeyutils1 \
    libkrb5-3 \
    libkrb5support0 \
    libldap-2.4-2 \
    liblzma5 \
    libmcrypt4 \
    libmemcached11 \
    libmemcachedutil2 \
    libncurses5 \
    libnettle6 \
    libnghttp2-14 \
    libp11-kit0 \
    libpng16-16 \
    libpq5 \
    libpsl5 \
    libreadline7 \
    librtmp1 \
    libsasl2-2 \
    libssl1.0.2 \
    libssl1.1 \
    libstdc++6 \
    libsybdb5 \
    libtasn1-6 \
    libtidy5 \
    libtinfo5 \
    libunistring0 \
    libxml2 \
    libxslt1.1 \
    zlib1g \
    libssh2-1 \
    libpcre3 \
    libsqlite3-0

apt-get -y install --no-install-recommends \
    wget \
    cron \
    vim \
    less \
    net-tools \
    gettext-base \
    unzip
