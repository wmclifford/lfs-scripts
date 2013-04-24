#!/bin/sh

PKG_NAME=Patch
PKG_VERS=2.7.1
PKG_URI=http://ftp.gnu.org/gnu/patch/patch-2.7.1.tar.xz
PKG_MD5=e9ae5393426d3ad783a300a338c09b72
PKG_ARCHIVE=$(basename ${PKG_URI})
PKG_SOURCE_DIR=${PKG_ARCHIVE%.tar.*}
PKG_BUILD_DIR=${PKG_SOURCE_DIR}

#
# Cross-compile stage (CLFS chapter 5)
#

cross_compile() {
	get_package $1
	validate_package
	dump_package $1
	cross_compile_prepare
	cross_compile_build
	cross_compile_install
	cross_compile_post_install
	cleanup_package $1
}

cross_compile_build() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	make
}

cross_compile_install() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	make install
}

cross_compile_prepare() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	./configure --prefix=${CLFS_CROSS_TOOLS}
}

cross_compile_post_install() {
	NTD
}

#
# Temporary system stage (CLFS chapter 6)
#

temp_system() {
	get_package $1
	validate_package
	dump_package $1
	temp_system_prepare
	temp_system_build
	temp_system_install
	temp_system_post_install
	cleanup_package $1
}

temp_system_build() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	make
}

temp_system_install() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	make install
}

temp_system_prepare() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	./configure --prefix=${CLFS_TOOLS} --build=${CLFS_HOST} --host=${CLFS_TARGET}
}

temp_system_post_install() {
	NTD
}

#
# Temporary system stage - boot and complete (CLFS chapter 7)
#

temp_system_BOOT() {
	get_package $1
	validate_package
	dump_package $1
	temp_system_BOOT_prepare
	temp_system_BOOT_build
	temp_system_BOOT_install
	temp_system_BOOT_post_install
	cleanup_package $1
}

temp_system_BOOT_build() {
	NTD
}

temp_system_BOOT_install() {
	NTD
}

temp_system_BOOT_prepare() {
	NTD
}

temp_system_BOOT_post_install() {
	NTD
}

#
# Temporary system stage - chroot and complete (CLFS chapter 8)
#

temp_system_CHROOT() {
	get_package $1
	validate_package
	dump_package $1
	temp_system_CHROOT_prepare
	temp_system_CHROOT_build
	temp_system_CHROOT_install
	temp_system_CHROOT_post_install
	cleanup_package $1
}

temp_system_CHROOT_build() {
	NTD
}

temp_system_CHROOT_install() {
	NTD
}

temp_system_CHROOT_prepare() {
	NTD
}

temp_system_CHROOT_post_install() {
	NTD
}

#
# Testsuite build stage (CLFS chapter 9)
#

construct_testsuite_tools() {
	get_package $1
	validate_package
	dump_package $1
	construct_testsuite_prepare
	construct_testsuite_build
	construct_testsuite_install
	construct_testsuite_post_install
	cleanup_package $1
}

construct_testsuite_build() {
	NTD
}

construct_testsuite_install() {
	NTD
}

construct_testsuite_prepare() {
	NTD
}

construct_testsuite_post_install() {
	NTD
}

#
# Final basic system (CLFS chapter 10)
#

final_system() {
	get_package $1
	validate_package
	dump_package $1
	final_system_prepare
	final_system_build
	final_system_check
	final_system_install
	final_system_post_install
	cleanup_package $1
}

final_system_build() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	make
}

final_system_check() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	make check
}

final_system_install() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	make install
}

final_system_prepare() {
	cd ${CLFS_SOURCES}/${PKG_BUILD_DIR}
	./configure --prefix=/usr
}

final_system_post_install() {
	NTD
}

