#!/usr/bin/qemu-arm-static /bin/sh

wget --no-verbose https://suitecrm.com/files/160/SuiteCRM-7.10.11/335/SuiteCRM-7.10.11.zip
unzip -q -d /opt SuiteCRM-7.10.11.zip
ln -s /opt/SuiteCRM-7.10.11 /opt/suitecrm
chown -R www-data:www-data /opt/SuiteCRM-7.10.11

# Several file permissions are not quite right after unzipping, so those need to be
# fixed.
chmod -R ugo+rw /opt/SuiteCRM-7.10.11/modules
chmod -R ugo+rw /opt/SuiteCRM-7.10.11/upload
chmod -R ugo+rw /opt/SuiteCRM-7.10.11/custom

# Also, presumably, we're done with the zip file now, so drop it to shrink the container
# image a little.
rm SuiteCRM-7.10.11.zip