#!/bin/sh

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

# configure suitecrm with docker env params
#read -d '' SUITECRM_CONFIG_SHELL_FORMAT <<_EOF_
#\$MARIADB_HOST,\$MARIADB_PORT_NUMBER,\$MARIADB_ROOT_USER,\$MARIADB_ROOT_PASSWORD,\$SUITECRM_DATABASE_NAME
#\$SUITECRM_HOST
#_EOF_

if [ ! -f /opt/suitecrm/config.php ]; then
    # TODO substitute stuff
#    envsubst "'${SUITECRM_CONFIG_SHELL_FORMAT}'" \
#        < suitecrm_config_template.php > /opt/suitecrm/config.php
    # See: http://www.jsmackin.co.uk/suitecrm/suitecrm-command-line-install/
    
    # If this trick doesn't work to override substitution of the actual php var,
    # will have to use the SHELL_FORMAT variable list.
    export sugar_config_si=\$sugar_config_si
    
    envsubst < suitecrm_silent_install_template.php > /opt/suitecrm/config_si.php
    
    # Run PHP from the command line (since the actual nginx and php-fpm won't be running yet).
    cd /opt/suitecrm
    php -r "\$_SERVER['HTTP_HOST'] = 'localhost'; \$_SERVER['SERVER_PORT'] = '80'; \$_SERVER['SERVER_NAME'] = 'suitecrm';  \$_SERVER['REQUEST_URI'] = 'install.php';\$_REQUEST = array('goto' => 'SilentInstall', 'cli' => true);require_once 'install.php';";
    cd /
    
    # This won't work because nginx and php aren't running yet at this point
    # wget -O silent_install_result.html http://localhost/install.php?goto=SilentInstall&cli=true
fi

# put the supervisord config where it goes (substituting if necessary)
if [ ! -f /opt/suitecrm_supervisord.conf ]; then
    # run envsubst if necessary
    cp suitecrm_supervisord.conf /opt/suitecrm_supervisord.conf
fi

supervisord -c /opt/suitecrm_supervisord.conf