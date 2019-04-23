LOCAL_PATH := $(call my-dir)

include device/linaro/dragonboard/utils.mk

# Firmware files copied from
# http://builds.96boards.org/releases/dragonboard410c/qualcomm/firmware/linux-board-support-package-r1032.1.1.zip
firmware_files_display :=  \
    a300_pfp.fw \
    a300_pm4.fw

$(foreach f, $(firmware_files_display), $(call add-qcom-firmware, $(f), $(TARGET_OUT_VENDOR)/firmware/qcom/))
