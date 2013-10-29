#!/bin/sh

BUILDDIR="/root/build"
DEBDIR="/root/latestbuilds"
MAINTAINER="root@stor.nyxi.eu"
LOGFILE="/root/logbuilds"

cd "$BUILDDIR"
rm -R node*
wget http://nodejs.org/dist/node-latest.tar.gz
tar xvf node-latest.tar.gz
rm node-latest.tar.gz
cd node-v*
./configure
#####################
# Control files
#####################
mkdir -p tmp/DEBIAN
echo "Package: node" >> tmp/DEBIAN/control
echo "Maintainer: $MAINTAINER" >> tmp/DEBIAN/control
echo "Architecture: amd64" >> tmp/DEBIAN/control
echo "Version: $(pwd | tail -c 8)" >> tmp/DEBIAN/control
echo "Provides: node" >> tmp/DEBIAN/control
echo "Priority: extra" >> tmp/DEBIAN/control
echo "Section: main" >> tmp/DEBIAN/control
echo "Filename: pool/main/n/node/node_$(pwd | tail -c 8)_amd64.deb" >> tmp/DEBIAN/control
echo "Description: nodejs" >> tmp/DEBIAN/control
chmod -R a-s tmp/DEBIAN
make DESTDIR="$(pwd)"/tmp install
echo "#!/bin/sh" >> tmp/DEBIAN/postinst
echo "ldconfig" >> tmp/DEBIAN/postinst
chmod 755 tmp/DEBIAN/postinst
dpkg-deb --build tmp "node_$(pwd | tail -c 8)_amd64.deb"
rm "$DEBDIR/node*deb" 2> /dev/null
mv *deb "$DEBDIR/"
echo "$(date) - nodejs $(pwd | tail -c 8) build ready" >> "$LOGFILE"
