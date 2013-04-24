#!/bin/sh

function cleanup_package() {
	set +e
	cd ${CLFS_SOURCES}
	if [ -d "${CLFS_SOURCES}/${PKG_SOURCE_DIR}" ] ; then
		rm -rf ${1} "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
	fi
	if [ "x${PKG_BUILD_DIR}" != "x" -a -d "${CLFS_SOURCES}/${PKG_BUILD_DIR}" ] ; then
		rm -rf ${1} "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
	fi
	set -e
}

function dump_package() {
	cd ${CLFS_SOURCES}
	if [ ! -f "${CLFS_SOURCES}/${PKG_ARCHIVE}" ] ; then
		echo "Missing: ${PKG_ARCHIVE}"
		return 1
	fi
	tar ${1}xf ${PKG_ARCHIVE}
	cd ${CLFS_SOURCES}/${PKG_SOURCE_DIR}
}

function get_package() {
	cd ${CLFS_SOURCES}
	if [ -f "${CLFS_SOURCES}/${PKG_ARCHIVE}" ] ; then
		return 0
	fi
	wget ${PKG_URI}
}

function group_exists() {
	grep --quiet "${1}" /etc/group
}

function user_exists() {
	grep --quiet "${1}" /etc/passwd
}

function validate_package() {
	cd ${CLFS_SOURCES}
	echo "${PKG_MD5} *${PKG_ARCHIVE}" |md5sum --check
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

