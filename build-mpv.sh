#!/bin/sh

BUILDDIR="/root/build"
DEBDIR="/root/latestbuilds"
MAINTAINER="root@stor.nyxi.eu"
LOGFILE="/root/logbuilds"

cd "$BUILDDIR"
rm mpv*deb
cd "$BUILDDIR/mpv-build"
./update
rm *deb
mk-build-deps
dpkg -i *deb
apt-get update && apt-get -f install -y
echo "mpv (1.0git-$(date +%Y%m%d)) stable; urgency=low" > debian/changelog
echo "" >> debian/changelog
echo "  * Initial package." >> debian/changelog
echo "" >> debian/changelog
echo " -- Wessel Dankers <wsl@fruit.je>  Sun, 06 Jan 2013 13:44:11 +0100" >> debian/changelog
debuild -uc -us -b -j2
cd /root/build
rm *changes
rm "$BUILDDIR/*build" 2> /dev/null
rm "$DEBDIR/mpv*deb" 2> /dev/null
mv mpv*deb "$DEBDIR/"
echo "$(date) - MPV build ready" >> "$LOGFILE"