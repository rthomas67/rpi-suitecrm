FROM raspbian/stretch
#FROM jsurf/rpi-raspbian

ENV LANG C.UTF-8
ENV TZ America/Denver

COPY rpi_bin/qemu-arm-static /usr/bin/
RUN chmod +x /usr/bin/qemu-arm-static

ARG DEBIAN_FRONTEND=noninteractive

COPY container_setup_rootfs/* ./

RUN chmod +x \
    update_package_manager.sh \
    install_base_packages.sh \
    install_nginx_php_mariadb_client.sh \
    setup_php.sh \
    install_suitecrm.sh

RUN ./update_package_manager.sh
RUN ./install_base_packages.sh
RUN ./install_nginx_php_mariadb_client.sh
RUN ./setup_php.sh
RUN ./install_suitecrm.sh

ENV ALLOW_EMPTY_PASSWORD="no" \
    NGINX_HTTPS_PORT_NUMBER="443" \
    NGINX_HTTP_PORT_NUMBER="80" \
    MARIADB_HOST="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_USER="root" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_SUITECRM_USER="" \
    MARIADB_SUITECRM_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    SUITECRM_DATABASE_NAME="suitecrm" \
    SUITECRM_CREATE_DATABASE="1" \
    SUITECRM_DROP_TABLES="1" \
    SUITECRM_EMAIL="user@example.com" \
    SUITECRM_HOST="127.0.0.1" \
    SUITECRM_HTTP_TIMEOUT="120" \
    SUITECRM_LAST_NAME="Name" \
    SUITECRM_SITE_NAME="SuiteCRM - Powered by Raspberry Pi and Docker" \
    SUITECRM_SMTP_HOST="" \
    SUITECRM_SMTP_PASSWORD="" \
    SUITECRM_SMTP_PORT="" \
    SUITECRM_SMTP_PROTOCOL="" \
    SUITECRM_SMTP_USER="" \
    SUITECRM_ADMIN_USERNAME="admin" \
    SUITECRM_ADMIN_PASSWORD="admin" \
    SUITECRM_VALIDATE_USER_IP="yes"
    
EXPOSE 80
EXPOSE 443

COPY container_startup/* ./

RUN chmod +x suitecrm-entrypoint.sh

ENTRYPOINT ["/suitecrm-entrypoint.sh"]
