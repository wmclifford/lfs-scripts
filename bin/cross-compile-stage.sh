#!/bin/sh

set -o nounset
set -o errexit

source lib/functions.sh
source lib/build-env.sh

trap WAT EXIT

source pkg-file.sh && cross_compile

PKG_NAME="CLFS"
PKG_VERS="2.0rc1"
trap GTG EXIT

