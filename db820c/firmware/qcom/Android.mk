LOCAL_PATH := $(call my-dir)

include device/linaro/dragonboard/utils.mk

# Adreno a530 firmware files copied from
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/qcom
firmware_files_display :=  \
    a530_pfp.fw \
    a530_pm4.fw \
    a530_zap.b00 \
    a530_zap.b01 \
    a530_zap.b02 \
    a530_zap.mdt \
    a530v3_gpmu.fw2

$(foreach f, $(firmware_files_display), $(call add-qcom-firmware, $(f), $(TARGET_OUT_VENDOR)/firmware/qcom/))
