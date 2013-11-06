#!/bin/sh

BUILDDIR="/root/build"
DEBDIR="/root/latestbuilds"
MAINTAINER="root@stor.nyxi.eu"
LOGFILE="/root/logbuilds"

if [ "$1" == "" ]; then
        echo "Must provide version to download!"
        exit
fi

#####################
# Cleanup, dl, untar
#####################
cd "$BUILDDIR"
rm -R mpc*
wget http://www.musicpd.org/download/mpc/0/mpc-$1.tar.xz
tar xvf mpc*tar.xz
rm mpc*tar.xz
cd mpc*
#####################

#####################
# Control files
#####################
mkdir -p tmp/DEBIAN
echo "Package: mpc" >> tmp/DEBIAN/control
echo "Maintainer: $MAINTAINER" >> tmp/DEBIAN/control
echo "Architecture: amd64" >> tmp/DEBIAN/control
echo "Version: $1" >> tmp/DEBIAN/control
echo "Provides: mpc" >> tmp/DEBIAN/control
echo "Depends: libc6 (>= 2.4), libmpdclient2 (>= 2.9)" >> tmp/DEBIAN/control
echo "Priority: Extra" >> tmp/DEBIAN/control
echo "Section: main" >> tmp/DEBIAN/control
echo "Filename: pool/main/m/mpc/mpc_$1_amd64.deb" >> tmp/DEBIAN/control
echo "Description: cli client for the music player daemon (mpd)" >> tmp/DEBIAN/control
chmod -R a-s tmp/DEBIAN
#####################

#####################
# Build it!
#####################
./configure
make DESTDIR="$(pwd)"/tmp install
dpkg-deb --build tmp "mpc_$1_amd64.deb"
rm $DEBDIR/mpc*deb 2> /dev/null
mv *deb "$DEBDIR/"
echo "$(date) - mpc $1 build ready" >> "$LOGFILE"
#####################
