LOCAL_PATH := $(call my-dir)

include device/linaro/dragonboard/utils.mk

# Firmware files copied from
# http://builds.96boards.org/releases/dragonboard410c/qualcomm/firmware/linux-board-support-package-r1032.1.1.zip
firmware_files_wlan :=  \
    WCNSS_qcom_wlan_nv.bin

$(foreach f, $(firmware_files_wlan), $(call add-qcom-firmware, $(f), $(TARGET_OUT_VENDOR)/firmware/wlan/prima))

include $(call all-makefiles-under,$(LOCAL_PATH))
