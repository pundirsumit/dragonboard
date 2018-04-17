#!/bin/sh

INSTALLER_DIR="`dirname ${0}`"

# for cases that don't run "lunch db820c-userdebug"
if [ -z "${ANDROID_BUILD_TOP}" ]; then
    ANDROID_BUILD_TOP=${INSTALLER_DIR}/../../../../../
    ANDROID_PRODUCT_OUT="${ANDROID_BUILD_TOP}/out/target/product/db820c"
fi

if [ ! -d "${ANDROID_PRODUCT_OUT}" ]; then
    echo "error in locating out directory, check if it exist"
    exit
fi

echo "android out dir:${ANDROID_PRODUCT_OUT}"

# Flash GPT and bootloader firmware files
fastboot flash partition:0 "${INSTALLER_DIR}"/gpt_both0.bin
fastboot flash partition:1 "${INSTALLER_DIR}"/gpt_both1.bin
fastboot flash partition:2 "${INSTALLER_DIR}"/gpt_both2.bin
fastboot flash partition:3 "${INSTALLER_DIR}"/gpt_both3.bin
fastboot flash partition:4 "${INSTALLER_DIR}"/gpt_both4.bin
fastboot flash partition:5 "${INSTALLER_DIR}"/gpt_both5.bin

fastboot erase ddr

fastboot flash cdt "${INSTALLER_DIR}"/sbc_1.0_8096.bin
fastboot flash xbl "${INSTALLER_DIR}"/xbl.elf
fastboot flash rpm "${INSTALLER_DIR}"/rpm.mbn
fastboot flash tz "${INSTALLER_DIR}"/tz.mbn
fastboot flash hyp "${INSTALLER_DIR}"/hyp.mbn
fastboot flash pmic "${INSTALLER_DIR}"/pmic.elf
fastboot flash aboot "${INSTALLER_DIR}"/emmc_appsboot.mbn
fastboot flash devcfg "${INSTALLER_DIR}"/devcfg.mbn
fastboot flash cmnlib64 "${INSTALLER_DIR}"/cmnlib64.mbn
fastboot flash cmnlib "${INSTALLER_DIR}"/cmnlib.mbn
fastboot flash keymaster "${INSTALLER_DIR}"/keymaster.mbn

# Flash AOSP images
fastboot reboot-bootloader
fastboot flash boot "${ANDROID_PRODUCT_OUT}"/boot.img
fastboot flash system "${ANDROID_PRODUCT_OUT}"/system.img
fastboot flash vendor "${ANDROID_PRODUCT_OUT}"/vendor.img
fastboot flash cache "${ANDROID_PRODUCT_OUT}"/cache.img
fastboot flash userdata "${ANDROID_PRODUCT_OUT}"/userdata.img
fastboot reboot
