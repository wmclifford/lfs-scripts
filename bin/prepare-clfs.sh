#!/bin/sh

set -o nounset
set -o errexit

source lib/functions.sh
source lib/build-env.sh

PKG_NAME="CLFS"
PKG_VERS="2.0rc1"
trap WAT EXIT

# This script should be run as root, but may be run by a user with sudo privileges.
if [ "x${CLFS_SUDO}" != "x" ] ; then
	# We are not root; call sudo to get the password entered now, so that
	# subsequent calls to sudo do not prompt each time.
	echo "
------------------------------------------------------------------------
WARNING: Running as non-privileged user ${USER}.
This portion of the cross linux from scratch build requires root access
to the build system. Attempting to get sudo access ...
------------------------------------------------------------------------
"
	${CLFS_SUDO} echo "Successfully acquired sudo access. Continuing with build."
fi

# Make sure ${CLFS} exists.
if [ ! -d "${CLFS}" ] ; then ${CLFS_SUDO} install -dv "${CLFS}" ; fi

# Make sure ${CLFS_SOURCES} exists.
if [ ! -d "${CLFS_SOURCES}" ] ; then ${CLFS_SUDO} install -dv "${CLFS_SOURCES}" ; fi

# Make sure ${CLFS_TOOLS} exists.
# To allow the tools folder to be something other than "/tools", the folder names
# specified here are accurate; make sure ${CLFS_TOOLS} starts with a "/".
if [ ! -d "${CLFS}${CLFS_TOOLS}" ] ; then
	${CLFS_SUDO} install -dv "${CLFS}${CLFS_TOOLS}"
fi
if [ ! -e "${CLFS_TOOLS}" ] ; then
	${CLFS_SUDO} install -dv `dirname "${CLFS_TOOLS}"`
	${CLFS_SUDO} ln -vfs "${CLFS}${CLFS_TOOLS}" "${CLFS_TOOLS}"
fi

# Make sure ${CLFS_CROSS_TOOLS} exists.
# To allow the cross-tools folder to be something other than "/cross-tools", the
# folder names specified here are accurate; make sure ${CLFS_CROSS_TOOLS} starts
# with a "/".
if [ ! -d "${CLFS}${CLFS_CROSS_TOOLS}" ] ; then
	${CLFS_SUDO} install -dv "${CLFS}${CLFS_CROSS_TOOLS}"
fi
if [ ! -e "${CLFS_CROSS_TOOLS}" ] ; then
	${CLFS_SUDO} install -dv `dirname "${CLFS_CROSS_TOOLS}"`
	${CLFS_SUDO} ln -vfs "${CLFS}${CLFS_CROSS_TOOLS}" "${CLFS_CROSS_TOOLS}"
fi

# Create ${CLFS_GROUP}, if it does not already exist.
set +e
if ! group_exists ${CLFS_GROUP} ; then
	${CLFS_SUDO} groupadd ${CLFS_GROUP} || WAT
fi
if ! user_exists ${CLFS_USER} ; then
	(${CLFS_SUDO} useradd -s /bin/bash -g ${CLFS_GROUP} -d ${CLFS_HOME} ${CLFS_USER}) || WAT
	(${CLFS_SUDO} mkdir -pv ${CLFS_HOME}) || WAT
	(${CLFS_SUDO} chown -v ${CLFS_USER}:${CLFS_GROUP} ${CLFS_HOME}) || WAT
	(${CLFS_SUDO} echo 'clfs1234' |passwd --stdin ${CLFS_USER}) || WAT
fi
set -e

# Set ownership of ${CLFS_TOOLS}, ${CLFS_CROSS_TOOLS}, and ${CLFS_SOURCES}.
${CLFS_SUDO} chown -v ${CLFS_USER} ${CLFS}${CLFS_TOOLS}
${CLFS_SUDO} chown -v ${CLFS_USER} ${CLFS}${CLFS_CROSS_TOOLS}
${CLFS_SUDO} chown -v ${CLFS_USER} ${CLFS_SOURCES}

# Create bash profile and rc settings files for user ${CLFS_USER}.
${CLFS_SUDO} cat > /tmp/${CLFS_USER}-bash_profile <<"EOF"
exec env -i HOME=${HOME} TERM=${TERM} PS1='[\u:\w]\$ ' /bin/bash
EOF
${CLFS_SUDO} mv -f /tmp/${CLFS_USER}-bash_profile ${CLFS_HOME}/.bash_profile
${CLFS_SUDO} cat > /tmp/${CLFS_USER}-bashrc <<"EOF"
set +h
umask 022
LC_ALL=POSIX
EOF
${CLFS_SUDO} echo "CLFS=${CLFS}" >>/tmp/${CLFS_USER}-bashrc
${CLFS_SUDO} echo "PATH=${CLFS_CROSS_TOOLS}/bin:/bin:/usr/bin" >>/tmp/${CLFS_USER}-bashrc
${CLFS_SUDO} echo "export CLFS LC_ALL PATH" >>/tmp/${CLFS_USER}-bashrc
${CLFS_SUDO} mv -f /tmp/${CLFS_USER}-bashrc ${CLFS_HOME}/.bashrc
${CLFS_SUDO} chown ${CLFS_USER}:${CLFS_GROUP} ${CLFS_HOME}/.bash_profile ${CLFS_HOME}/.bashrc

echo "
------------------------------------------------------------------------
Cross Linux From Scratch - initial preparation complete.
To continue the build process, change to user ${CLFS_USER},
and run the cross-compile stage (cross-compile-stage.sh).
------------------------------------------------------------------------
"

trap GTG EXIT

