#!/bin/sh

# Build settings
CLFS_HOST=$(echo ${MACHTYPE} |sed -e 's/-[^-]*/-cross/')
CLFS_TARGET=arm-1136jfs-linux-gnueabi
CLFS_TARGET_ARCH=arm

# Folders
CLFS=/mnt/clfs/${CLFS_TARGET_ARCH}/${CLFS_TARGET}
CLFS_SOURCES=${CLFS}/sources
CLFS_CROSS_TOOLS=/opt/clfs-2.0rc1/${CLFS_TARGET}/cross-tools
CLFS_TOOLS=/opt/clfs-2.0rc1/${CLFS_TARGET}/tools

# User settings
CLFS_GROUP=clfs
CLFS_USER=clfs
CLFS_HOME=/home/${CLFS_USER}
CLFS_SUDO=

if [ "x${USER}" == "x" ] ; then
	USER=`id -un`
fi

if [ $UID -ne 0 ] ; then
    CLFS_SUDO=sudo
fi

#
LC_ALL=POSIX
CLFS_VERBOSE="-v"

# Target-specific variables for the compiler and linkers
# These are dependent upon which chapter we are presently
# building. Pre-chapter 6 requires they be left unset.
if [ $CLFS_CHAPTER -ge 6 ] ; then
	CC="${CLFS_TARGET}-gcc"
	CXX="${CLFS_TARGET}-g++"
	AR="${CLFS_TARGET}-ar"
	AS="${CLFS_TARGET}-as"
	RANLIB="${CLFS_TARGET}-ranlib"
	LD="${CLFS_TARGET}-ld"
	STRIP="${CLFS_TARGET}-strip"
else
	# Chapter 5 and earlier ...
	unset CC CXX AR AS RANLIB LD STRIP
fi

