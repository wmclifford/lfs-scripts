#!/bin/sh

PKG_NAME="GCC"
PKG_VERS="4.6.3"
PKG_URI="ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.6.3/gcc-4.6.3.tar.bz2"
PKG_MD5="773092fe5194353b02bb0110052a972e"
PKG_ARCHIVE="$(basename ${PKG_URI})"
PKG_SOURCE_DIR="${PKG_ARCHIVE%.tar.*}"
PKG_BUILD_DIR="${PKG_SOURCE_DIR}"

#
# Patches required by this package
#
unset PKG_PATCH_URI PKG_PATCH_MD5 PKG_PATCH_DESC
declare -a PKG_PATCH_URI PKG_PATCH_MD5 PKG_PATCH_DESC

PKG_PATCH_DESC[0]="GCC Branch Update Patch"
PKG_PATCH_MD5[0]="e7af1c4a02408aeb25c94ed86c7921d6"
PKG_PATCH_URI[0]="http://patches.cross-lfs.org/dev/gcc-4.6.3-branch_update-2.patch"

PKG_PATCH_DESC[1]="GCC Mips Fix"
PKG_PATCH_MD5[1]="abf4b55165bb44508d1f8f36188c9e90"
PKG_PATCH_URI[1]="http://patches.cross-lfs.org/dev/gcc-4.6.3-mips_fix-1.patch"

PKG_PATCH_DESC[2]="GCC Specs Patch"
PKG_PATCH_MD5[2]="61d583984f9f12b6f37141e132fc7d57"
PKG_PATCH_URI[2]="http://patches.cross-lfs.org/dev/gcc-4.6.3-specs-1.patch"

#
# Cross-compile stage (CLFS chapter 5) - static build
#

cross_compile_static() {
	get_package
	validate_package
	dump_package
	cross_compile_static_prepare
	cross_compile_static_build
	cross_compile_static_install
	cross_compile_static_post_install
	cleanup_package
}

cross_compile_static_build() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make all-gcc all-target-libgcc
}

cross_compile_static_install() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make install-gcc install-target-libgcc
}

cross_compile_static_prepare() {
	apply_patch_file 0
	apply_patch_file 2
	apply_patch_file 1
	echo -en "#undef STANDARD_INCLUDE_DIR\\n#define STANDARD_INCLUDE_DIR \"${CLFS_TOOLS}/include/\"\\n\\n" >> gcc/config/linux.h
	echo -en "\\n#undef STANDARD_STARTFILE_PREFIX_1\\n#define STANDARD_STARTFILE_PREFIX_1 \"${CLFS_TOOLS}/lib/\"\\n" >> gcc/config/linux.h
	echo -en "\\n#undef STANDARD_STARTFILE_PREFIX_2\\n#define STANDARD_STARTFILE_PREFIX_2 \"\"\\n" >> gcc/config/linux.h
	cp -v gcc/Makefile.in{,.orig}
	sed -e "s@\(^CROSS_SYSTEM_HEADER_DIR =\).*@\1 ${CLFS_TOOLS}/include@g" gcc/Makefile.in.orig > gcc/Makefile.in
	touch ${CLFS_TOOLS}/include/limits.h
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	AR=ar LDFLAGS="-Wl,-rpath,${CLFS_CROSS_TOOLS}/lib" \
		../${PKG_SOURCE_DIR}/configure --prefix=${CLFS_CROSS_TOOLS} \
		--build=${CLFS_HOST} --host=${CLFS_HOST} --target=${CLFS_TARGET} \
		--with-sysroot=${CLFS} --with-local-prefix=${CLFS_TOOLS} --disable-nls \
		--disable-shared --with-mpfr=${CLFS_CROSS_TOOLS} --with-gmp=${CLFS_CROSS_TOOLS} \
		--with-ppl=${CLFS_CROSS_TOOLS} --with-cloog=${CLFS_CROSS_TOOLS} --without-headers \
		--with-newlib --disable-decimal-float --disable-libgomp \
		--disable-libmudflap --disable-libssp --disable-threads \
		--enable-languages=c --disable-multilib --enable-cloog-backend=isl
}

cross_compile_static_post_install() {
	NTD
}

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
	make AS_FOR_TARGET="${CLFS_TARGET}-as" LD_FOR_TARGET="${CLFS_TARGET}-ld"
}

cross_compile_install() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make install
}

cross_compile_prepare() {
	apply_patch_file 0
	apply_patch_file 2
	apply_patch_file 1
	echo -en "#undef STANDARD_INCLUDE_DIR\\n#define STANDARD_INCLUDE_DIR \"${CLFS_TOOLS}/include/\"\\n\\n" >> gcc/config/linux.h
	echo -en "\\n#undef STANDARD_STARTFILE_PREFIX_1\\n#define STANDARD_STARTFILE_PREFIX_1 \"${CLFS_TOOLS}/lib/\"\\n" >> gcc/config/linux.h
	echo -en "\\n#undef STANDARD_STARTFILE_PREFIX_2\\n#define STANDARD_STARTFILE_PREFIX_2 \"\"\\n" >> gcc/config/linux.h
	cp -v gcc/Makefile.in{,.orig}
	sed -e "s@\(^CROSS_SYSTEM_HEADER_DIR =\).*@\1 ${CLFS_TOOLS}/include@g" gcc/Makefile.in.orig > gcc/Makefile.in
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	AR=ar LDFLAGS="-Wl,-rpath,${CLFS_CROSS_TOOLS}/lib" \
		../${PKG_SOURCE_DIR}/configure --prefix=${CLFS_CROSS_TOOLS} \
		--build=${CLFS_HOST} --host=${CLFS_HOST} --target=${CLFS_TARGET} \
		--with-sysroot=${CLFS} --with-local-prefix=${CLFS_TOOLS} --disable-nls \
		--enable-shared --disable-static --enable-languages=c,c++ \
		--enable-__cxa_atexit --with-mpfr=${CLFS_CROSS_TOOLS} --with-gmp=${CLFS_CROSS_TOOLS} \
		--enable-c99 --with-ppl=${CLFS_CROSS_TOOLS} --with-cloog=${CLFS_CROSS_TOOLS} \
		--enable-cloog-backend=isl --enable-long-long --enable-threads=posix --disable-multilib
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
	make AS_FOR_TARGET="${AS}" LD_FOR_TARGET="${LD}"
}

temp_system_install() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make install
}

temp_system_prepare() {
	apply_patch_file 0
	apply_patch_file 2
	apply_patch_file 1
	echo -en "#undef STANDARD_INCLUDE_DIR\\n#define STANDARD_INCLUDE_DIR \"${CLFS_TOOLS}/include/\"\\n\\n" >> gcc/config/linux.h
	echo -en "\\n#undef STANDARD_STARTFILE_PREFIX_1\\n#define STANDARD_STARTFILE_PREFIX_1 \"${CLFS_TOOLS}/lib/\"\\n" >> gcc/config/linux.h
	echo -en "\\n#undef STANDARD_STARTFILE_PREFIX_2\\n#define STANDARD_STARTFILE_PREFIX_2 \"\"\\n" >> gcc/config/linux.h
	cp -v gcc/Makefile.in{,.orig}
	sed -e "s@\(^NATIVE_SYSTEM_HEADER_DIR =\).*@\1 ${CLFS_TOOLS}/include@g" gcc/Makefile.in.orig > gcc/Makefile.in
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	../${PKG_SOURCE_DIR}/configure --prefix=${CLFS_TOOLS} \
		--build=${CLFS_HOST} --host=${CLFS_TARGET} --target=${CLFS_TARGET} \
		--with-local-prefix=${CLFS_TOOLS} --enable-long-long --enable-c99 \
		--enable-shared --enable-threads=posix --enable-__cxa_atexit \
		--disable-nls --enable-languages=c,c++ --disable-libstdcxx-pch \
		--disable-multilib --enable-cloog-backend=isl
	cp -v Makefile{,.orig}
	sed "/^HOST_\(GMP\|PPL\|CLOOG\)\(LIBS\|INC\)/s:-[IL]/\(lib\|include\)::" Makefile.orig > Makefile
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

