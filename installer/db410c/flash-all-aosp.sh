#!/bin/sh

INSTALLER_DIR="`dirname ${0}`"

# for cases that don't run "lunch db410c32_only-userdebug"
if [ -z "${ANDROID_BUILD_TOP}" ]; then
    ANDROID_BUILD_TOP=${INSTALLER_DIR}/../../../../../
    ANDROID_PRODUCT_OUT="${ANDROID_BUILD_TOP}/out/target/product/db410c32_only"
fi

if [ ! -d "${ANDROID_PRODUCT_OUT}" ]; then
    echo "error in locating out directory, check if it exist"
    exit
fi

echo "android out dir:${ANDROID_PRODUCT_OUT}"

# Flash Bootloader firmware files
fastboot flash partition "${INSTALLER_DIR}"/gpt_both0.bin
fastboot flash hyp "${INSTALLER_DIR}"/hyp.mbn
fastboot flash modem "${INSTALLER_DIR}"/NON-HLOS.bin
fastboot flash rpm "${INSTALLER_DIR}"/rpm.mbn
fastboot flash sbl1 "${INSTALLER_DIR}"/sbl1.mbn
fastboot flash tz "${INSTALLER_DIR}"/tz.mbn
fastboot flash aboot "${INSTALLER_DIR}"/emmc_appsboot.mbn
fastboot flash cdt "${INSTALLER_DIR}"/sbc_1.0_8016.bin

# Android (for some reasons) have bak partition with duplicate..
fastboot flash sbl1bak "${INSTALLER_DIR}"/sbl1.mbn
fastboot flash hypbak "${INSTALLER_DIR}"/hyp.mbn
fastboot flash rpmbak "${INSTALLER_DIR}"/rpm.mbn
fastboot flash tzbak "${INSTALLER_DIR}"/tz.mbn
fastboot flash abootbak "${INSTALLER_DIR}"/emmc_appsboot.mbn

# Erase AOSP partition images (not sure if we need to do that explicitly)
fastboot erase boot
fastboot erase recovery
fastboot erase system
fastboot erase userdata
fastboot erase cache
fastboot erase devinfo
fastboot erase persist
fastboot erase sec

# Flash AOSP images
fastboot reboot-bootloader
fastboot flash boot "${ANDROID_PRODUCT_OUT}"/boot.img
fastboot flash system "${ANDROID_PRODUCT_OUT}"/system.img
fastboot flash cache "${ANDROID_PRODUCT_OUT}"/cache.img
fastboot flash userdata "${ANDROID_PRODUCT_OUT}"/userdata.img
fastboot reboot
