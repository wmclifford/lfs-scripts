#!/bin/sh

PKG_NAME="Linux"
PKG_VERS="3.8.7"
PKG_URI="http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.8.7.tar.xz"
PKG_MD5="37ce9b5cc33551b45fea59c1c4c9da13"
PKG_ARCHIVE="$(basename ${PKG_URI})"
PKG_SOURCE_DIR="${PKG_ARCHIVE%.tar.*}"
PKG_BUILD_DIR="${PKG_SOURCE_DIR}"

#
# Patches required by this package
#
unset PKG_PATCH_URI PKG_PATCH_MD5 PKG_PATCH_DESC
declare -a PKG_PATCH_URI PKG_PATCH_MD5 PKG_PATCH_DESC

PKG_PATCH_DESC[0]="rtc-s3c - Disable alarm entries that are not chosen"
PKG_PATCH_URI[0]="http://localhost/mini6410/kernel-patches/3.8/PATCH_2_3_rtc-s3c_Disable_alarm_entries_that_are_not_chosen.diff"
PKG_PATCH_MD5[0]="a19f6b68ce80c64bf22fef37e79dcef0"
PKG_PATCH_DESC[1]="DM9000 - Make the driver follow the IRQF_SHARED contract"
PKG_PATCH_URI[1]="http://localhost/mini6410/kernel-patches/3.8/dm9000_Make_the_driver_follow_the_IRQF_SHARED_contract.patch"
PKG_PATCH_MD5[1]="2d3bb195efac180208a17e41bc35af52"
PKG_PATCH_DESC[2]="DM9000 - Implement full reset of network device"
PKG_PATCH_URI[2]="http://localhost/mini6410/kernel-patches/3.8/dm9000_Implement_full_reset_of_network_device.patch"
PKG_PATCH_MD5[2]="e288c9d2ab6d8995441240b1100420cc"
PKG_PATCH_DESC[3]="simplify the touchscreen driver"
PKG_PATCH_URI[3]="http://localhost/mini6410/kernel-patches/3.8/fix_ts_race.diff"
PKG_PATCH_MD5[3]="9ef9e29002a6c81e6266b98ad4d94f14"
PKG_PATCH_DESC[4]="12 bit ADC resolution"
PKG_PATCH_URI[4]="http://localhost/mini6410/kernel-patches/3.8/adapt_ts_to_extended_adc.diff"
PKG_PATCH_MD5[4]="01eb8cf3b808a644c2a8479979b6023d"
PKG_PATCH_DESC[5]="Add GPIO - Keys"
PKG_PATCH_URI[5]="http://localhost/mini6410/kernel-patches/3.8/add_gpio_keys.diff"
PKG_PATCH_MD5[5]="281edda411939d8259b6c447db27bfcf"
PKG_PATCH_DESC[6]="Add GPIO - LEDS"
PKG_PATCH_URI[6]="http://localhost/mini6410/kernel-patches/3.8/add_gpio_leds.diff"
PKG_PATCH_MD5[6]="23e8759d23534a1f4dd53807cdfb82f2"
PKG_PATCH_DESC[7]="Remove local backlight handling"
PKG_PATCH_URI[7]="http://localhost/mini6410/kernel-patches/3.8/remove_local_backlight_handling.diff"
PKG_PATCH_MD5[7]="2d0411dee1a862dd7c26dfc65371c4de"
PKG_PATCH_DESC[8]="Add hardware monitoring feature"
PKG_PATCH_URI[8]="http://localhost/mini6410/kernel-patches/3.8/add_hwmon_feature.diff"
PKG_PATCH_MD5[8]="766e9c94663a381b151f25b7ad0ac272"
PKG_PATCH_DESC[9]="Add I2C support"
PKG_PATCH_URI[9]="http://localhost/mini6410/kernel-patches/3.8/add_i2c_support.diff"
PKG_PATCH_MD5[9]="4adfcc1e01e3c1d833ae266cc112c2a4"
PKG_PATCH_DESC[10]="Add RTC"
PKG_PATCH_URI[10]="http://localhost/mini6410/kernel-patches/3.8/add_rtc_feature.diff"
PKG_PATCH_MD5[10]="f2e29986b8591abdd3f3ed23da64c506"
PKG_PATCH_DESC[11]="Fix LCD match"
PKG_PATCH_URI[11]="http://localhost/mini6410/kernel-patches/3.8/fix_lcd_match.diff"
PKG_PATCH_MD5[11]="30e39b357cc25bc9367180bd3f288a54"
PKG_PATCH_DESC[12]="handle display's physical size in kernel"
PKG_PATCH_URI[12]="http://localhost/mini6410/kernel-patches/3.8/add_display_size_in_kernel.diff"
PKG_PATCH_MD5[12]="6e61e286d1a1927eb8e84c5771c4456e"
PKG_PATCH_DESC[13]="Enable user to select 32 bit colour depth"
PKG_PATCH_URI[13]="http://localhost/mini6410/kernel-patches/3.8/change_colour_depth_on_demand.diff"
PKG_PATCH_MD5[13]="79c77d5673c3ce0e4747c821a42dedbf"
PKG_PATCH_DESC[14]="Gain access to the iROM"
PKG_PATCH_URI[14]="http://localhost/mini6410/kernel-patches/3.8/gain_access_to_the_iROM.diff"
PKG_PATCH_MD5[14]="3b016c018f37caeb6001d509a8e3487f"
PKG_PATCH_DESC[15]="Add SD card support"
PKG_PATCH_URI[15]="http://localhost/mini6410/kernel-patches/3.8/add_sd_card_support.diff"
PKG_PATCH_MD5[15]="5125dcf5e3740fd23bf2b08b04bbc89a"
PKG_PATCH_DESC[16]="Add SDIO card support"
PKG_PATCH_URI[16]="http://localhost/mini6410/kernel-patches/3.8/add_sdio_card_support.diff"
PKG_PATCH_MD5[16]="7f156a96d5d14707a0ced91a328ef4b9"
PKG_PATCH_DESC[17]="Fix PWM"
PKG_PATCH_URI[17]="http://localhost/mini6410/kernel-patches/3.8/fix_pwm.diff"
PKG_PATCH_MD5[17]="618c176543116e45b995ac2deb93e315"
PKG_PATCH_DESC[18]="Add buzzer support"
PKG_PATCH_URI[18]="http://localhost/mini6410/kernel-patches/3.8/add_buzzer_support.diff"
PKG_PATCH_MD5[18]="3f66022efff30d7e65c44e4af254b5c8"
PKG_PATCH_DESC[19]="Mini6410 1wire"
PKG_PATCH_URI[19]="http://localhost/mini6410/kernel-patches/3.8/mini6410_onewire.patch"
PKG_PATCH_MD5[19]="f73948f299fe8ae9556653b31aa0733d"
PKG_PATCH_DESC[20]="Mini6410 1wire backlight"
PKG_PATCH_URI[20]="http://localhost/mini6410/kernel-patches/3.8/mini6410_ow_backlight.patch"
PKG_PATCH_MD5[20]="1e43da55b82f628ab63fccd95d14b7e3"
PKG_PATCH_DESC[21]="Mini6410 1wire touchscreen"
PKG_PATCH_URI[21]="http://localhost/mini6410/kernel-patches/3.8/mini6410_ow_touchscreen.patch"
PKG_PATCH_MD5[21]="e7e3199d1b7b19d3edec40b2113b9c26"
PKG_PATCH_DESC[22]="Add 1wire driver to Mini6410"
PKG_PATCH_URI[22]="http://localhost/mini6410/kernel-patches/3.8/add_1wire_driver_to_mini6410.diff"
PKG_PATCH_MD5[22]="dfa921a00bc1632667b7d3e63abec588"
PKG_PATCH_DESC[23]="Fix 7\" display - timing"
PKG_PATCH_URI[23]="http://localhost/mini6410/kernel-patches/3.8/fix_7inch_display_timing.patch"
PKG_PATCH_MD5[23]="f8ddd4c187acc1bb424e1ce28d7b2b26"

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
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make ARCH=${CLFS_TARGET_ARCH} CROSS_COMPILE=${CLFS_TARGET}-
}

temp_system_BOOT_install() {
	cd "${CLFS_SOURCES}/${PKG_BUILD_DIR}"
	make ARCH=${CLFS_TARGET_ARCH} CROSS_COMPILE=${CLFS_TARGET}- \
		INSTALL_MOD_PATH=${CLFS} modules_install
	cp -v vmlinux ${CLFS}/boot/vmlinux-${PKG_VERS}
	gzip -9 ${CLFS}/boot/vmlinux-${PKG_VERS}
	cp -v System.map ${CLFS}/boot/System.map-${PKG_VERS}
	cp -v .config ${CLFS}/boot/config-${PKG_VERS}
	cp -v arch/${CLFS_TARGET_ARCH}/boot/zImage ${CLFS}/boot/zImage-${PKG_VERS}
}

temp_system_BOOT_prepare() {
	cd "${CLFS_SOURCES}/${PKG_SOURCE_DIR}"
	make mrproper
	for ii in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 ; do
		apply_patch_file $ii
	done
	cp -v "${CLFS_SOURCES}/kernel-${PKG_VERS}-config" "${CLFS_SOURCES}/${PKG_SOURCE_DIR}/.config"
	make ARCH=${CLFS_TARGET_ARCH} CROSS_COMPILE=${CLFS_TARGET}- menuconfig
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

