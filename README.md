Some scripts for building various packages for Debian.

Please note that most scripts do not set up the required dependencies, you have to do that yourself.

Most of the scripts are called with the version to download and compile, for instance:
	sh build-mpd.sh 0.17.6
##Variables##
	BUILDDIR="/root/build"
	DEBDIR="/root/latestbuilds"
	MAINTAINER="root@stor.nyxi.eu"
	LOGFILE="/root/logbuilds"

BUILDDIR is the directory to which source code packages are downloaded and extracted to
DEBDIR is the output directory where the deb packages are saved after compiling
MAINTAINER sets the maintainer email for the package
LOGFILE should be obvious, currently only logs a line telling when and what packages was compiled
