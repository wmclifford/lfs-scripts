#!/bin/sh

PKG_NAME="Texinfo"
PKG_VERS="4.13a"
PKG_URI="http://ftp.gnu.org/gnu/texinfo/texinfo-4.13a.tar.gz"
PKG_MD5="71ba711519209b5fb583fed2b3d86fcb"
PKG_ARCHIVE="$(basename ${PKG_URI})"
PKG_SOURCE_DIR="${PKG_ARCHIVE%.tar.*}"
PKG_BUILD_DIR="${PKG_SOURCE_DIR}"

#
# Patches required by this package
#
declare -a PKG_PATCH_URI PKG_PATCH_MD5 PKG_PATCH_DESC

PKG_PATCH_DESC[0]="Texinfo New Compressors Patch"
PKG_PATCH_MD5[0]="4ae2d3c132e21cb83b825bc691056d07"
PKG_PATCH_URI[0]="http://patches.cross-lfs.org/dev/texinfo-4.13a-new_compressors-1.patch"

#
# Cross-compile stage (CLFS chapter 5)
#

cross_compile() {
	get_package
	validate_package
	dump_package
	cross_compile_prepare
	cross_compile_build
	cross_compile_install
	cross_compile_post_install
	cleanup_package
}

cross_compile_build() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make
}

cross_compile_install() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make install
}

cross_compile_prepare() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	./configure --prefix=${CLFS_CROSS_TOOLS}
}

cross_compile_post_install() {
	NTD
}

#
# Temporary system stage (CLFS chapter 6)
#

temp_system() {
	get_package
	validate_package
	dump_package
	temp_system_prepare
	temp_system_build
	temp_system_install
	temp_system_post_install
	cleanup_package
}

temp_system_build() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make -C tools/gnulib/lib
	make -C tools
	make
}

temp_system_install() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make install
}

temp_system_prepare() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	./configure --prefix=${CLFS_TOOLS} --build=${CLFS_HOST} --host=${CLFS_TARGET}
}

temp_system_post_install() {
	NTD
}

#
# Temporary system stage - boot and complete (CLFS chapter 7)
#

temp_system_BOOT() {
	get_package
	validate_package
	dump_package
	temp_system_BOOT_prepare
	temp_system_BOOT_build
	temp_system_BOOT_install
	temp_system_BOOT_post_install
	cleanup_package
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
	get_package
	validate_package
	dump_package
	temp_system_CHROOT_prepare
	temp_system_CHROOT_build
	temp_system_CHROOT_install
	temp_system_CHROOT_post_install
	cleanup_package
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
	get_package
	validate_package
	dump_package
	construct_testsuite_prepare
	construct_testsuite_build
	construct_testsuite_install
	construct_testsuite_post_install
	cleanup_package
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
	get_package
	validate_package
	dump_package
	final_system_prepare
	final_system_build
	final_system_check
	final_system_install
	final_system_post_install
	cleanup_package
}

final_system_build() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make
}

final_system_check() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make check
}

final_system_install() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make install
}

final_system_prepare() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	./configure --prefix=/usr
}

final_system_post_install() {
	NTD
}

