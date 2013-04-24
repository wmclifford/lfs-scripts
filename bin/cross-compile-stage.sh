#!/bin/sh

set -o nounset
set -o errexit

source ../lib/functions.sh
source ../lib/build-env.sh

trap WAT EXIT

source pkg-linux-headers.sh ; cross_compile
source pkg-file.sh ; cross_compile
source pkg-m4.sh ; cross_compile
source pkg-ncurses.sh ; cross_compile
source pkg-gmp.sh ; cross_compile
source pkg-mpfr.sh ; cross_compile
source pkg-mpc.sh ; cross_compile
source pkg-ppl.sh ; cross_compile
source pkg-cloog.sh ; cross_compile
source pkg-binutils.sh ; cross_compile
source pkg-gcc.sh ; cross_compile_static
source pkg-eglibc.sh ; cross_compile
source pkg-gcc.sh ; cross_compile

PKG_NAME="CLFS"
PKG_VERS="2.0rc1"
trap GTG EXIT

