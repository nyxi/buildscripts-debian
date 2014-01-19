#!/bin/sh
#This script assumes you have dependencies set up
#and the mpv-build git repo in $BUILDDIR/mpv-build

BUILDDIR="/root/build"
DEBDIR="/root/latestbuilds"
MAINTAINER="root@stor.nyxi.eu"
LOGFILE="/root/logbuilds"

#####################
# Control files
#####################
cd $BUILDDIR/mpv-build
mkdir -p tmp/DEBIAN 2> /dev/null
rm -f tmp/DEBIAN/control 2> /dev/null
echo "Package: mpv" >> tmp/DEBIAN/control
echo "Maintainer: $MAINTAINER" >> tmp/DEBIAN/control
echo "Architecture: amd64" >> tmp/DEBIAN/control
echo "Version: 1.0git-$(date +%Y%m%d)" >> tmp/DEBIAN/control
echo "Provides: mpv" >> tmp/DEBIAN/control
echo "Priority: optional" >> tmp/DEBIAN/control
echo "Section: main" >> tmp/DEBIAN/control
echo "Filename: pool/main/m/mpv/mpv_1.0git-$(date +%Y%m%d)_amd64.deb" >> tmp/DEBIAN/control
echo "Description: mpv movie player" >> tmp/DEBIAN/control
chmod -R a-s tmp/DEBIAN
#####################

#####################
# Build it!
#####################
./rebuild -j4
mkdir -p tmp/usr/bin
cp -f mpv/build/mpv tmp/usr/bin/
dpkg-deb --build tmp "mpv_1.0git-$(date +%Y%m%d)_amd64.deb"
rm $DEBDIR/mpv*deb 2> /dev/null
mv *deb "$DEBDIR/"
echo "$(date) - mpv build ready" >> "$LOGFILE"
#####################
