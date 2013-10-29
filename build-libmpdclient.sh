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
rm -R libmpdclient*
wget http://www.musicpd.org/download/libmpdclient/2/libmpdclient-$1.tar.bz2
tar xvf libmpdclient*tar.bz2
rm libmpdclient*tar.bz2
cd libmpdclient*
#####################

#####################
# Control files
#####################
mkdir -p tmp/DEBIAN
echo "Package: libmpdclient2" >> tmp/DEBIAN/control
echo "Maintainer: $MAINTAINER" >> tmp/DEBIAN/control
echo "Architecture: amd64" >> tmp/DEBIAN/control
echo "Version: $1" >> tmp/DEBIAN/control
echo "Provides: libmpdclient2" >> tmp/DEBIAN/control
echo "Depends: libc6 (>= 2.4)" >> tmp/DEBIAN/control
echo "Tag: role::shared-lib" >> tmp/DEBIAN/control
echo "Section: libs" >> tmp/DEBIAN/control
echo "Priority: Extra" >> tmp/DEBIAN/control
echo "Filename: pool/main/libm/libmpdclient/libmpdclient2_$1_amd64.deb" >> tmp/DEBIAN/control
echo "Description: cli client for the music player daemon (mpd)" >> tmp/DEBIAN/control
chmod -R a-s tmp/DEBIAN
echo "#!/bin/sh" >> tmp/DEBIAN/postinst
echo "ldconfig" >> tmp/DEBIAN/postinst
chmod 755 tmp/DEBIAN/postinst
#####################

#####################
# Build it!
#####################
./configure
make DESTDIR=$(pwd)/tmp install
dpkg-deb --build tmp "libmpdclient2_$1_amd64.deb"
rm "$DEBDIR/libmpdclient2*deb"
mv *deb "$DEBDIR/"
echo "$(date) - libmpdclient2 $1 build ready" >> "$LOGFILE"
#####################
