#!/bin/sh

# build it without the version tag to replace the magic "latest" tag
docker build -t rthomas67/rpi-suitecrm .

# tag it with the version number from the VERSION file
version=`cat VERSION`
echo "Tagging with version ${version}"
docker tag rthomas67/rpi-suitecrm rthomas67/rpi-suitecrm:${version}

echo "Ready for docker login, docker push"