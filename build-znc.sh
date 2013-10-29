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
rm -R znc*
wget http://znc.in/releases/znc-$1.tar.gz
tar xvf znc*tar.gz
rm znc*tar.gz
cd znc*
#####################

#####################
# Control files
#####################
mkdir -p tmp/DEBIAN
echo "Package: znc" >> tmp/DEBIAN/control
echo "Maintainer: $MAINTAINER" >> tmp/DEBIAN/control
echo "Architecture: amd64" >> tmp/DEBIAN/control
echo "Version: $1" >> tmp/DEBIAN/control
echo "Provides: znc" >> tmp/DEBIAN/control
echo "Depends: libc-ares2 (>= 1.7.0), libc6 (>= 2.4), libgcc1 (>= 1:4.1.1), libssl1.0.0 (>= 1.0.0), libstdc++6 (>= 4.6)" >> tmp/DEBIAN/control
echo "Priority: optional" >> tmp/DEBIAN/control
echo "Section: main" >> tmp/DEBIAN/control
echo "Filename: pool/main/z/znc/znc_$1_amd64.deb" >> tmp/DEBIAN/control
echo "Description: znc is an IRC proxy (bouncer)." >> tmp/DEBIAN/control
chmod -R a-s tmp/DEBIAN
echo "#!/bin/sh" >> tmp/DEBIAN/postinst
echo "ldconfig" >> tmp/DEBIAN/postinst
chmod 755 tmp/DEBIAN/postinst
#####################

#####################
# Build it!
#####################
./configure
make DESTDIR="$(pwd)"/tmp install
dpkg-deb --build tmp "znc_$1_amd64.deb"
rm "$DEBDIR/znc*deb" 2> /dev/null
mv *deb "$DEBDIR/"
echo "$(date) - znc $1 build ready" >> "$LOGFILE"
#####################
