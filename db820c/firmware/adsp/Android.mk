LOCAL_PATH := $(call my-dir)

include device/linaro/dragonboard/utils.mk

# Adreno a530 firmware files copied from
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/qcom
firmware_files_adsp :=  \
    adsp.b00 \
    adsp.b01 \
    adsp.b02 \
    adsp.b03 \
    adsp.b04 \
    adsp.b05 \
    adsp.b06 \
    adsp.b08 \
    adsp.b09 \
    adsp.mdt \
    adspr.jsn \
    adspua.jsn

$(foreach f, $(firmware_files_adsp), $(call add-qcom-firmware, $(f), $(TARGET_OUT_VENDOR)/firmware/))
