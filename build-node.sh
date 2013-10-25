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
checkinstall -y --pkgversion "$(pwd | tail -c 8)" --install=no
rm "$DEBDIR/node*deb" 2> /dev/null
mv node*deb "$DEBDIR/"
echo "$(date) - nodejs $(pwd | tail -c 8) build ready" >> "$LOGFILE"
