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
rm -R mpd*
wget http://www.musicpd.org/download/mpd/stable/mpd-$1.tar.xz
tar xvf mpd*tar.xz
rm mpd*tar.xz
cd mpd*
#####################

#####################
# I use the "debian" directory
# from the mpd source in the
# Debian repo and just replace the version
#####################
cp -R ../debian/ debian/
sed -i "s/0.17.5/$1/" debian/changelog
#####################

#####################
# Build package with dependencies
# for building mpd and install it
#####################
mk-build-deps
dpkg -i *deb
apt-get update && apt-get -f install -y
#####################

#####################
# Build it!
#####################
debuild -uc -us -b -j2
cd "$BUILDDIR"
rm *build *changes mpd-dbg*deb
rm "$DEBDIR/mpd*deb" 2> /dev/null
mv mpd*deb "$DEBDIR/"
echo "$(date) - mpd $1 build ready" >> "$LOGFILE"
#####################
