#!/bin/sh

set -o nounset
set -o errexit

# Set the chapter number -- this is important for lib/build-env.sh
# Where we are beyond chapter 5, we have to have CC, CXX, AR, and
# others set to point at the ${CLFS_TARGET} versions of those tools.
# Chapter 5 needs these to be unset ... build-env.sh handles the
# details for us.
declare -i CLFS_CHAPTER=7

source ../lib/functions.sh
source ../lib/build-env.sh

# Make sure we are running as the CLFS user.
if [ "$USER" != "${CLFS_USER}" ] ; then
	echo -e "${COLOR_YELLOW}
////////////////////////////////////////////////////////////////////////
// WARNING: Presently running script as user '${USER}';
//          This stage needs to be run as the CLFS user '${CLFS_USER}'.
//          Aborting build.
////////////////////////////////////////////////////////////////////////
${COLOR_RESET}"
	exit 1
fi

PKG_NAME="CLFS"
PKG_VERS="2.0rc1"
trap WAT EXIT

# Temporarily change ownership of $CLFS to the CLFS user.
${CLFS_SUDO} chown -v ${CLFS_USER} ${CLFS}

# Creating some structure in the CLFS file system. This is a standard
# directory tree.
mkdir -pv ${CLFS}/{bin,boot,dev,{etc/,}opt,home,lib,mnt}
mkdir -pv ${CLFS}/{proc,media/{floppy,cdrom},run/{,shm},sbin,srv,sys}
mkdir -pv ${CLFS}/var/{lock,log,mail,spool}
mkdir -pv ${CLFS}/var/{opt,cache,lib/{misc,locate},local}
install -dv -m 0750 ${CLFS}/root
install -dv -m 1777 ${CLFS}{/var,}/tmp
mkdir -pv ${CLFS}/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv ${CLFS}/usr/{,local/}share/{doc,info,locale,man}
mkdir -pv ${CLFS}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${CLFS}/usr/{,local/}share/man/man{1,2,3,4,5,6,7,8}
for dir in ${CLFS}/usr{,/local}; do
	ln -sv share/{man,doc,info} $dir
done

# Some programs use hard-wired paths to programs which do not exist yet.
# In order to satisfy these programs, create a number of symbolic links
# which will be replaced by real files over the course of building the
# rest of the system.
ln -sv ${CLFS_TOOLS}/bin/{bash,cat,echo,grep,login,passwd,pwd,sleep,stty} ${CLFS}/bin
ln -sv ${CLFS_TOOLS}/sbin/{agetty,blkid} ${CLFS}/sbin
ln -sv ${CLFS_TOOLS}/bin/file ${CLFS}/usr/bin
ln -sv ${CLFS_TOOLS}/lib/libgcc_s.so{,.1} ${CLFS}/usr/lib
ln -sv ${CLFS_TOOLS}/lib/libstd*so* ${CLFS}/usr/lib
ln -sv bash ${CLFS}/bin/sh
ln -sv /run ${CLFS}/var/run

CLFS_BUILD_ROOT="$(pwd)"
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-util-linux.sh ; temp_system_BOOT
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-shadow.sh ; temp_system_BOOT
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-e2fsprogs.sh ; temp_system_BOOT
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-sysvinit.sh ; temp_system_BOOT
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-kmod.sh ; temp_system_BOOT
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-udev.sh ; temp_system_BOOT

cat > ${CLFS}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/bin/false
daemon:x:2:6:daemon:/sbin:/bin/false
adm:x:3:16:adm:/var/adm:/bin/false
lp:x:10:9:lp:/var/spool/lp:/bin/false
mail:x:30:30:mail:/var/mail:/bin/false
news:x:31:31:news:/var/spool/news:/bin/false
operator:x:50:0:operator:/root:/bin/bash
postmaster:x:51:30:postmaster:/var/spool/mail:/bin/false
nobody:x:65534:65534:nobody:/:/bin/false
EOF

cat > ${CLFS}/etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:root,adm,daemon
console:x:17:
cdrw:x:18:
mail:x:30:mail
news:x:31:news
users:x:1000:
nogroup:x:65533:
nobody:x:65534:
EOF

touch ${CLFS}/var/run/utmp ${CLFS}/var/log/{btmp,lastlog,wtmp}
chmod -v 664 ${CLFS}/var/run/utmp ${CLFS}/var/log/lastlog
chmod -v 600 ${CLFS}/var/log/btmp

# Linux kernel setup
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-linux.sh ; temp_system_BOOT

# Setting up the environment
cat > ${CLFS}/root/.bash_profile << "EOF"
set +h
PS1='\u:\w\$ '
LC_ALL=POSIX
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/tools/sbin
export LC_ALL PATH PS1
EOF

# Creating the /etc/fstab file
# Note that the root file system is not defined here; this is a deviation
# from the (C)LFS book, as we are building the rest of the system with
# root being mounted via NFS. We will have to fill in the root file system
# entry once everything has been copied to the actual boot media.
cat > ${CLFS}/etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options          dump  fsck
#                                                         order

##/dev/[xxx]     /            [fff]  defaults         1     1
##/dev/[yyy]     swap         swap   pri=1            0     0
proc           /proc        proc   defaults         0     0
sysfs          /sys         sysfs  defaults         0     0
devpts         /dev/pts     devpts gid=4,mode=620   0     0
shm            /dev/shm     tmpfs  defaults         0     0
tmpfs          /run            tmpfs       defaults         0     0
devtmpfs       /dev            devtmpfs    mode=0755,nosuid 0     0

# End /etc/fstab
EOF

# Boot scripts
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-bootscripts.sh ; temp_system_BOOT

# Populating /dev/
mknod -m 600 ${CLFS}/dev/console c 5 1
mknod -m 666 ${CLFS}/dev/null c 1 3
mknod -m 600 ${CLFS}/lib/udev/devices/console c 5 1
mknod -m 666 ${CLFS}/lib/udev/devices/null c 1 3

# Changing ownership
chown -Rv 0:0 ${CLFS}
chgrp -v 13 ${CLFS}/var/run/utmp ${CLFS}/var/log/lastlog

PKG_NAME="CLFS"
PKG_VERS="2.0rc1"
trap GTG EXIT

