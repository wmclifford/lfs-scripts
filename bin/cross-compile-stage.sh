#!/bin/sh

set -o nounset
set -o errexit

# Set the chapter number -- this is important for lib/build-env.sh
# Where we are beyond chapter 5, we have to have CC, CXX, AR, and
# others set to point at the ${CLFS_TARGET} versions of those tools.
# Chapter 5 needs these to be unset ... build-env.sh handles the
# details for us.
declare -i CLFS_CHAPTER=5

source ../lib/functions.sh
source ../lib/build-env.sh

# Make sure we are running this as the CLFS user.
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

trap WAT EXIT

CLFS_BUILD_ROOT="$(pwd)"
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-linux-headers.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-file.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-m4.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-ncurses.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-gmp.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-mpfr.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-mpc.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-ppl.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-cloog.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-binutils.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-gcc.sh ; cross_compile_static
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-eglibc.sh ; cross_compile
cd "${CLFS_BUILD_ROOT}" ; source ../packages/pkg-gcc.sh ; cross_compile

PKG_NAME="CLFS"
PKG_VERS="2.0rc1"
trap GTG EXIT

