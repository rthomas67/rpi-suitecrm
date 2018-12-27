#!/usr/bin/qemu-arm-static /bin/sh

BASEDIR=$(dirname "$0")

echo "Applying patch files from ${BASEDIR}"

# Diagnostics to show verbose info about what is loaded from config_si.php
patch /opt/suitecrm/install/install_utils.php "${BASEDIR}/install_utils.patch"

# Diagnostics to discover why the setup_db_create_database = 0 is being ignored/overwritten.
patch /opt/suitecrm/install/performSetup.php "${BASEDIR}/performSetup.patch"

# Diagnostics to confirm silent-install bug in checkDBSettings logic
patch /opt/suitecrm/install/checkDBSettings.php "${BASEDIR}/checkDBSettings.patch"

# Fix stuff that is broken in SilentInstall when setup_db_create_database is false/0
patch /opt/suitecrm/install/suite_install/suite_install.php "${BASEDIR}/suite_install.patch"
