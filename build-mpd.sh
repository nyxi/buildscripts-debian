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
# Control files
#####################
mkdir -p tmp/DEBIAN
echo "Package: mpd" >> tmp/DEBIAN/control
echo "Maintainer: $MAINTAINER" >> tmp/DEBIAN/control
echo "Architecture: amd64" >> tmp/DEBIAN/control
echo "Version: $1" >> tmp/DEBIAN/control
echo "Provides: mpd" >> tmp/DEBIAN/control
echo "Depends: adduser, lsb-base (>= 3.2-13), libao4 (>= 1.1.0), libasound2 (>= 1.0.16),\
 libaudiofile1 (>= 0.3.4), libavahi-client3 (>= 0.6.16), libavahi-common3 (>= 0.6.16), \
libavahi-glib1 (>= 0.6.16), libavcodec53 (>= 6:0.8.3-1~) | libavcodec-extra-53 \
(>= 6:0.8.6), libavformat53 (>= 6:0.8.3-1~), libavutil51 (>= 6:0.8.3-1~), libc6 (>= 2.10)\
, libcurl3-gnutls (>= 7.18.0), libfaad2 (>= 2.7), libflac8 (>= 1.2.1), libgcc1 (>= 1:4.1.1)\
, libglib2.0-0 (>= 2.31.8), libid3tag0 (>= 0.15.1b), libjack-jackd2-0 (>= 1.9.5~dfsg-14) | \
libjack-0.116, libmad0 (>= 0.15.1b-3), libmikmod2 (>= 3.1.10), libmms0 (>= 0.4), libmp3lame0,\
 libmpcdec6 (>= 1:0.1~r435), libogg0 (>= 1.1.0), libpulse0 (>= 0.99.1), libsamplerate0 \
(>= 0.1.7), libshout3, libsqlite3-0 (>= 3.5.9), libstdc++6 (>= 4.1.1), libvorbis0a (>= 1.1.2)\
, libvorbisenc2 (>= 1.1.2), libvorbisfile3 (>= 1.1.2), libwavpack1 (>= 4.40.0), zlib1g\
 (>= 1:1.1.4)" >> tmp/DEBIAN/control
echo "Priority: optional" >> tmp/DEBIAN/control
echo "Section: sound" >> tmp/DEBIAN/control
echo "Filename: pool/main/m/mpd/mpd_$1_amd64.deb" >> tmp/DEBIAN/control
echo "Description: Music Player Daemon" >> tmp/DEBIAN/control
chmod -R a-s tmp/DEBIAN
echo "#!/bin/sh" >> tmp/DEBIAN/postinst
echo "ldconfig" >> tmp/DEBIAN/postinst
chmod 755 tmp/DEBIAN/postinst
#####################

#####################
# Build it!
#####################
./configure
make DESTDIR="$(pwd)/tmp" install
mv tmp/usr/local/bin tmp/usr/
dpkg-deb --build tmp "mpd_$1_amd64.deb"
rm "$DEBDIR/mpd*deb"
mv *deb "$DEBDIR/"
echo "$(date) - mpd $1 build ready" >> "$LOGFILE"
#####################
