#!/bin/sh

BUILDDIR="/root/build"
DEBDIR="/root/latestbuilds"
MAINTAINER="root@stor.nyxi.eu"
LOGFILE="/root/logbuilds"

if [ "$1" == "" ]; then
	echo "Must provide version to download!"
	exit
fi

cd "$BUILDDIR"
rm -R mpd*
wget http://www.musicpd.org/download/mpd/stable/mpd-$1.tar.xz
tar xvf mpd*tar.xz
rm mpd*tar.xz
cd mpd*
cp -R ../debian/ debian/
sed -i "s/0.17.5/$1/" debian/changelog
mk-build-deps
dpkg -i *deb
apt-get update && apt-get -f install -y
debuild -uc -us -b -j2
cd "$BUILDDIR"
rm *build *changes mpd-dbg*deb
rm "$DEBDIR/mpd*deb" 2> /dev/null
mv mpd*deb "$DEBDIR/"
echo "$(date) - mpd $1 build ready" >> "$LOGFILE"
