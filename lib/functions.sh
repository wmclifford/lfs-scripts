#!/bin/sh

function apply_patch_archive() {
	local -i patch_index=${1}
	local patch_file="$(basename ${PKG_PATCH_URI[$patch_index]})"
	cd "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
	echo "Applying patch '${PKG_PATCH_DESC[$patch_index]}' to source tree"
	tar xvf "${CLFS_SOURCES}/${patch_file}"
}

function apply_patch_file() {
	local -i patch_index=${1}
	local patch_file="$(basename ${PKG_PATCH_URI[$patch_index]})"
	cd "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
	echo "Applying patch '${PKG_PATCH_DESC[$patch_index]}' to source tree"
	patch -Np1 -i "${CLFS_SOURCES}/${patch_file}"
}

function cleanup_package() {
	set +e
	cd "${CLFS_SOURCES}"
	if [ -d "${CLFS_SOURCES}/${PKG_SOURCE_DIR}" ] ; then
		rm -rf ${1} "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
	fi
	if [ "x${PKG_BUILD_DIR}" != "x" -a -d "${CLFS_SOURCES}/${PKG_BUILD_DIR}" ] ; then
		rm -rf ${1} "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	fi
	set -e
}

function dump_package() {
	cd "${CLFS_SOURCES}"
	if [ ! -f "${CLFS_SOURCES}/${PKG_ARCHIVE}" ] ; then
		echo "Missing: ${PKG_ARCHIVE}"
		return 1
	fi
	tar ${1}xf ${PKG_ARCHIVE}
	if [ "${PKG_SOURCE_DIR}" != "${PKG_BUILD_DIR}" ] ; then
		if [ "x${PKG_BUILD_DIR}" != "x" -a ! -d "${CLFS_SOURCES}/${PKG_BUILD_DIR}" ] ; then
			mkdir -p ${1} "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
		fi
	fi
	cd "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
}

function fetch_all_patches() {
	local -i patch_count=${#PKG_PATCH_DESC[*]}
	local -i patch_index=0
	while [ $patch_index -lt $patch_count ] ; do
		fetch_patch $patch_index
	done
}

function fetch_patch() {
	local patch_index=${1:-0}
	local patch_desc="${PKG_PATCH_DESC[$patch_index]}"
	local patch_uri="${PKG_PATCH_URI[$patch_index]}"
	local patch_filename="$(basename $patch_uri)"
	cd "${CLFS_SOURCES}"
	if [ ! -f "${CLFS_SOURCES}/${patch_filename}" ] ; then
		echo "Retrieving patch \"$path_desc\" ..."
		wget "${PKG_PATCH_URI[$patch_index]}"
	fi
}

function get_package() {
	cd "${CLFS_SOURCES}"
	if [ ! -f "${CLFS_SOURCES}/${PKG_ARCHIVE}" ] ; then
		wget "${PKG_URI}"
	fi
	fetch_all_patches
}

function group_exists() {
	grep --quiet "${1}" /etc/group
}

function user_exists() {
	grep --quiet "${1}" /etc/passwd
}

function validate_all_patches() {
	local -i patch_count=${#PKG_PATCH_DESC[*]}
	local -i patch_index=0
	while [ $patch_index -lt $patch_count ] ; do
		validate_patch $patch_index
	done
}

function validate_package() {
	cd "${CLFS_SOURCES}"
	echo "${PKG_MD5} *${PKG_ARCHIVE}" |md5sum --check
	validate_all_patches
}

function validate_patch() {
	local patch_index=${1:-0}
	local patch_desc="${PKG_PATCH_DESC[$patch_index]}"
	local patch_uri="${PKG_PATCH_URI[$patch_index]}"
	local patch_filename="$(basename $patch_uri)"
	local patch_md5="${PKG_PATCH_MD5[$patch_index]}"
	cd "${CLFS_SOURCES}"
	echo "$patch_md5  $patch_filename" |md5sum --check
}

function GTG() {
	local fn=${FUNCNAME[1]}
	if [ "${fn}" == "main" ] ; then
		fn=${0}
	fi
	cat <<EOF

===============================================================
${PKG_NAME}-${PKG_VERS}: ${fn}
===============================================================
     #####  #     #  #####   #####  #######  #####   #####
    #     # #     # #     # #     # #       #     # #     #
    #       #     # #       #       #       #       #
     #####  #     # #       #       #####    #####   #####
          # #     # #       #       #             #       #
    #     # #     # #     # #     # #       #     # #     #
     #####   #####   #####   #####  #######  #####   #####
===============================================================

EOF
}

function NTD() {
	echo "${PKG_NAME}-${PKG_VERS}: ${FUNCNAME[1]} - nothing to do"
}

function WAT() {
	local fn=${FUNCNAME[1]}
	if [ "${fn}" == "main" ] ; then
		fn=${0}
	fi
	cat <<EOF

XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
${PKG_NAME}-${PKG_VERS}: ${fn}
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                    #     #    #    #######
                    #  #  #   # #      #
                    #  #  #  #   #     #
                    #  #  # #     #    #
                    #  #  # #######    #
                    #  #  # #     #    #
                     ## ##  #     #    #
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

EOF
    exit 1
}

