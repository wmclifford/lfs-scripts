#!/bin/sh

COLOR_RED='\033[01;31m'
COLOR_GREEN='\033[01;32m'
COLOR_YELLOW='\033[01;33m'
COLOR_BLUE='\033[01;34m'
COLOR_MAGENTA='\033[01;35m'
COLOR_CYAN='\033[01;36m'
COLOR_WHITE='\033[01;37m'
COLOR_RESET='\033[0m'

function apply_patch_archive() {
	local -i patch_index=${1}
	local patch_file="$(basename ${PKG_PATCH_URI[$patch_index]})"
	cd "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
	echo -e "${COLOR_YELLOW}Applying patch '${PKG_PATCH_DESC[$patch_index]}' to source tree${COLOR_RESET}"
	tar xvf "${CLFS_SOURCES}/${patch_file}"
}

function apply_patch_file() {
	local -i patch_index=${1}
	local patch_file="$(basename ${PKG_PATCH_URI[$patch_index]})"
	cd "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
	echo -e "${COLOR_YELLOW}Applying patch '${PKG_PATCH_DESC[$patch_index]}' to source tree${COLOR_RESET}"
	patch -Np1 -i "${CLFS_SOURCES}/${patch_file}"
}

function cleanup_package() {
	set +e
	echo -e "${COLOR_BLUE}Cleaning up package ${PKG_NAME}-${PKG_VERS}${COLOR_RESET}"
	cd "${CLFS_SOURCES}"
	if [ -d "${CLFS_SOURCES}/${PKG_SOURCE_DIR}" ] ; then
		rm -rf ${CLFS_VERBOSE} "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
	fi
	if [ "x${PKG_BUILD_DIR}" != "x" -a -d "${CLFS_SOURCES}/${PKG_BUILD_DIR}" ] ; then
		rm -rf ${CLFS_VERBOSE} "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	fi
	set -e
}

function dump_package() {
	echo -e "${COLOR_BLUE}Dumping package ${PKG_ARCHIVE} ...${COLOR_RESET}"
	cd "${CLFS_SOURCES}"
	if [ ! -f "${CLFS_SOURCES}/${PKG_ARCHIVE}" ] ; then
		echo -e "${COLOR_RED}Missing: ${PKG_ARCHIVE}${COLOR_RESET}"
		return 1
	fi
	tar ${CLFS_VERBOSE}xf ${PKG_ARCHIVE}
	if [ "${PKG_SOURCE_DIR}" != "${PKG_BUILD_DIR}" ] ; then
		if [ "x${PKG_BUILD_DIR}" != "x" -a ! -d "${CLFS_SOURCES}/${PKG_BUILD_DIR}" ] ; then
			mkdir -p ${CLFS_VERBOSE} "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
		fi
	fi
	cd "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
}

function fetch_all_patches() {
	local -i patch_count=${#PKG_PATCH_DESC[*]}
	local -i patch_index=0
	while [ $patch_index -lt $patch_count ] ; do
		fetch_patch $patch_index
		let patch_index=${patch_index}+1
	done
	/bin/true
}

function fetch_patch() {
	local patch_index=${1:-0}
	local patch_desc="${PKG_PATCH_DESC[$patch_index]}"
	local patch_uri="${PKG_PATCH_URI[$patch_index]}"
	local patch_filename="$(basename $patch_uri)"
	cd "${CLFS_SOURCES}"
	if [ ! -f "${CLFS_SOURCES}/${patch_filename}" ] ; then
		echo -e "${COLOR_CYAN}Retrieving patch \"$patch_desc\" ...${COLOR_RESET}"
		wget "${PKG_PATCH_URI[$patch_index]}"
	else
		echo -e "${COLOR_WHITE}Patch \"$patch_desc\" already available.${COLOR_RESET}"
	fi
	/bin/true
}

function get_package() {
	echo -e "${COLOR_CYAN}Retrieving package ${PKG_URI} ...${COLOR_RESET}"
	cd "${CLFS_SOURCES}"
	if [ ! -f "${CLFS_SOURCES}/${PKG_ARCHIVE}" ] ; then
		wget "${PKG_URI}"
	else
		echo -e "${COLOR_WHITE}Package \"${PKG_ARCHIVE}\" already available.${COLOR_RESET}"
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
		let patch_index=${patch_index}+1
	done
	/bin/true
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
	echo -e "${COLOR_GREEN}"
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
	echo -e "${COLOR_RESET}"
}

function NTD() {
	echo -e "${COLOR_MAGENTA}${PKG_NAME}-${PKG_VERS}: ${FUNCNAME[1]} - nothing to do${COLOR_RESET}"
}

function WAT() {
	local fn=${FUNCNAME[1]}
	if [ "${fn}" == "main" ] ; then
		fn=${0}
	fi
	echo -e "${COLOR_RED}"
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
	echo -e "${COLOR_RESET}"
	exit 1
}

