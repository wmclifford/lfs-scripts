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

if [ $UID -ne 0 ] ; then
    CLFS_SUDO=sudo
fi

#
LC_ALL=POSIX

