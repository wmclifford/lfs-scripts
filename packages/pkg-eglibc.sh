#!/bin/sh

PKG_NAME="EGLIBC"
PKG_VERS="2.15"
PKG_URI="http://cross-lfs.org/files/eglibc-2.15-r21467.tar.xz"
PKG_MD5="f4087281e50843e67da86dd8da3ec9a3"
PKG_ARCHIVE="$(basename ${PKG_URI})"
PKG_SOURCE_DIR="${PKG_ARCHIVE%.tar.*}"
PKG_BUILD_DIR="eglibc-build"

#
# Patches required by this package
#
unset PKG_PATCH_URI PKG_PATCH_MD5 PKG_PATCH_DESC
declare -a PKG_PATCH_URI PKG_PATCH_MD5 PKG_PATCH_DESC

PKG_PATCH_DESC[0]="EGLIBC Ports (2.15)"
PKG_PATCH_MD5[0]="2d52bc76d509bf60c46c3f37fdfe3a4e"
PKG_PATCH_URI[0]="http://cross-lfs.org/files/eglibc-ports-2.15-r21467.tar.xz"

PKG_PATCH_DESC[1]="EGLIBC Fixes Patch"
PKG_PATCH_MD5[1]="872128f0f087f2036798680c3b118c65"
PKG_PATCH_URI[1]="http://patches.cross-lfs.org/dev/eglibc-2.15-fixes-1.patch"

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
	make install inst_vardbdir=${CLFS_TOOLS}/var/db
	cp -v ../${PKG_SOURCE_DIR}/sunrpc/rpc/*.h ${CLFS_TOOLS}/include/rpc
	cp -v ../${PKG_SOURCE_DIR}/sunrpc/rpcsvc/*.h ${CLFS_TOOLS}/include/rpcsvc
	cp -v ../${PKG_SOURCE_DIR}/nis/rpcsvc/*.h ${CLFS_TOOLS}/include/rpcsvc
}

cross_compile_prepare() {
	apply_patch_archive 0
	cp -v Makeconfig{,.orig}
	sed -e 's/-lgcc_eh//g' Makeconfig.orig > Makeconfig
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	cat > config.cache << "EOF"
libc_cv_forced_unwind=yes
libc_cv_c_cleanup=yes
libc_cv_gnu89_inline=yes
libc_cv_ssp=no
EOF
	BUILD_CC="gcc" CC="${CLFS_TARGET}-gcc" \
		AR="${CLFS_TARGET}-ar" RANLIB="${CLFS_TARGET}-ranlib" \
		../${PKG_SOURCE_DIR}/configure --prefix=${CLFS_TOOLS} \
		--host=${CLFS_TARGET} --build=${CLFS_HOST} \
		--disable-profile --with-tls --enable-kernel=2.6.32 \
		--with-__thread --with-binutils=${CLFS_CROSS_TOOLS}/bin \
		--with-headers=${CLFS_TOOLS}/include --cache-file=config.cache
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

