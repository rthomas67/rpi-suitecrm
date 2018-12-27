#!/bin/sh

echo "Checking required ENV variable values."
missing_required_fields=0
# Check vars that have to be set before the first time starting up
if [ -z "${MARIADB_HOST}" ]; then
    echo "ENV variable value for MARIADB_HOST is required."
    missing_required_fields=1
fi

if [ -z "${MARIADB_ROOT_PASSWORD}" ]; then
    echo "ENV variable value for MARIADB_ROOT_PASSWORD is required."
    missing_required_fields=1
fi

if [ "${missing_required_fields}" = 1 ]; then
    echo "Missing required ENV variables.  SuiteCRM initialization stopped.  Set and restart."
    exit 100
fi

if [ -z "${MARIADB_SUITECRM_USER}" ]; then
    echo "WARNING: No SuiteCRM DB user provided. Defaulting mariadb user for suitecrm to same as root mariadb user."
    export MARIADB_SUITECRM_USER="${MARIADB_ROOT_USER}"
fi
if [ -z "${MARIADB_SUITECRM_PASSWORD}" ]; then
    echo "WARNING: No SuiteCRM DB password provided. Defaulting mariadb password for suitecrm to same as root mariadb password."
    export MARIADB_SUITECRM_PASSWORD="${MARIADB_ROOT_PASSWORD}"
fi

# configure nginx with docker env params
if [ ! -f /etc/nginx/sites_available/suitecrm ]; then
    # Add defaults if they're missing from the env
    if [ ! -z "${NGINX_HTTPS_PORT_NUMBER}" ]; then
        export NGINX_HTTPS_PORT_NUMBER=443
    fi
    if [ ! -z "${NGINX_HTTPS_PORT_NUMBER}" ]; then
        export NGINX_HTTP_PORT_NUMBER=80
    fi
    
    envsubst '\$NGINX_HTTPS_PORT_NUMBER \$NGINX_HTTP_PORT_NUMBER' < suitecrm_nginx_template.conf > /etc/nginx/sites-available/suitecrm
    ln -s /etc/nginx/sites-available/suitecrm /etc/nginx/sites-enabled/suitecrm
    rm /etc/nginx/sites-enabled/default
fi

if [ ! -f /opt/suitecrm/config.php ]; then
    # This trick prevents substitution of the actual php var with blank
    # which is what happens if sugar_config_si is _not_ set in the env.
    export sugar_config_si=\$sugar_config_si
    
    envsubst < suitecrm_silent_install_template.php > /opt/suitecrm/config_si.php
    
    # Run PHP from the command line (since the actual nginx and php-fpm won't be running yet).
    # Running as www-data so that all the files created during setup are not owned by root
    # (as they would be if the PHP silent install were run without sudo).  This is to avoid
    # permissions problems later when SuiteCRM tries to create files in cache/modules/..., etc.
    cd /opt/suitecrm
    php_request_vars="\$_SERVER['SERVER_SOFTWARE'] = 'NGINX';"
    php_request_vars="$php_request_vars \$_SERVER['HTTP_HOST'] = 'localhost';"
    php_request_vars="$php_request_vars \$_SERVER['SERVER_PORT'] = '80';"
    php_request_vars="$php_request_vars \$_SERVER['SERVER_NAME'] = 'suitecrm';"
    php_request_vars="$php_request_vars \$_SERVER['REQUEST_URI'] = 'install.php';"
    php_request_vars="$php_request_vars \$_REQUEST = array('goto' => 'SilentInstall', 'cli' => true);"
    php_request_vars="$php_request_vars "
    sudo -u www-data php -r "${php_request_vars} require_once 'install.php';";
    # If sudo isn't working, remove "sudo -u www-data " from the previous line and uncomment the following line.
        # chown -R www-data:www-data cache
    cd /
    
    # Note: This wouldn't work because nginx and php aren't running yet at this point
    # wget -O silent_install_result.html http://localhost/install.php?goto=SilentInstall&cli=true
fi

# put the supervisord config where it goes (substituting if necessary)
if [ ! -f /opt/suitecrm_supervisord.conf ]; then
    # run envsubst if necessary
    cp suitecrm_supervisord.conf /opt/suitecrm_supervisord.conf
fi

supervisord -c /opt/suitecrm_supervisord.conf