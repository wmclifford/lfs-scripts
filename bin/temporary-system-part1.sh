#!/bin/sh

set -o nounset
set -o errexit

# Set the chapter number -- this is important for lib/build-env.sh
# Where we are beyond chapter 5, we have to have CC, CXX, AR, and
# others set to point at the ${CLFS_TARGET} versions of those tools.
# Chapter 5 needs these to be unset ... build-env.sh handles the
# details for us.
declare -i CLFS_CHAPTER=6

source ../lib/functions.sh
source ../lib/build-env.sh

trap WAT EXIT

source ../packages/pkg-gmp.sh ; temp_system
source ../packages/pkg-mpfr.sh ; temp_system
source ../packages/pkg-mpc.sh ; temp_system
source ../packages/pkg-ppl.sh ; temp_system
source ../packages/pkg-cloog.sh ; temp_system
source ../packages/pkg-zlib.sh ; temp_system
source ../packages/pkg-binutils.sh ; temp_system
source ../packages/pkg-gcc.sh ; temp_system
source ../packages/pkg-ncurses.sh ; temp_system
source ../packages/pkg-bash.sh ; temp_system
source ../packages/pkg-bison.sh ; temp_system
source ../packages/pkg-bzip2.sh ; temp_system
source ../packages/pkg-coreutils.sh ; temp_system
source ../packages/pkg-diffutils.sh ; temp_system
source ../packages/pkg-findutils.sh ; temp_system
source ../packages/pkg-file.sh ; temp_system
source ../packages/pkg-flex.sh ; temp_system
source ../packages/pkg-gawk.sh ; temp_system
source ../packages/pkg-gettext.sh ; temp_system
source ../packages/pkg-grep.sh ; temp_system
source ../packages/pkg-gzip.sh ; temp_system
source ../packages/pkg-m4.sh ; temp_system
source ../packages/pkg-make.sh ; temp_system
source ../packages/pkg-patch.sh ; temp_system
source ../packages/pkg-sed.sh ; temp_system
source ../packages/pkg-tar.sh ; temp_system
source ../packages/pkg-texinfo.sh ; temp_system
source ../packages/pkg-vim.sh ; temp_system
source ../packages/pkg-xz.sh ; temp_system

PKG_NAME="CLFS"
PKG_VERS="2.0.rc1"
trap GTG EXIT

