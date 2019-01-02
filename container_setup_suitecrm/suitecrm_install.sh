#!/usr/bin/qemu-arm-static /bin/sh

SUITECRM_VERSION=7.10.11

# TODO: Find out if there is a way to not hard-code the subdirectories (e.g. 160 and 335 in this one)
wget --no-verbose https://suitecrm.com/files/160/SuiteCRM-${SUITECRM_VERSION}/335/SuiteCRM-${SUITECRM_VERSION}.zip
unzip -q -d /opt SuiteCRM-${SUITECRM_VERSION}.zip
ln -s /opt/SuiteCRM-${SUITECRM_VERSION} /opt/suitecrm
chown -R www-data:www-data /opt/SuiteCRM-${SUITECRM_VERSION}

# Several file permissions are not quite right after unzipping,
# so those need to be fixed.
# TODO: Review/re-test this.  It might have been a file owner issue.
chmod -R ugo+rw /opt/SuiteCRM-${SUITECRM_VERSION}/modules
chmod -R ugo+rw /opt/SuiteCRM-${SUITECRM_VERSION}/upload
chmod -R ugo+rw /opt/SuiteCRM-${SUITECRM_VERSION}/custom
chmod -R ugo+rw /opt/SuiteCRM-${SUITECRM_VERSION}/cache

# Also, presumably, we're done with the zip file now, so drop it to shrink the container
# image a little.
rm SuiteCRM-${SUITECRM_VERSION}.zip