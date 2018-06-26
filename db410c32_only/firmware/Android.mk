LOCAL_PATH := $(call my-dir)

include device/linaro/dragonboard/utils.mk

# Firmware files copied from
# http://builds.96boards.org/releases/dragonboard410c/qualcomm/firmware/linux-board-support-package-r1032.1.1.zip
firmware_files :=  \
    a300_pfp.fw \
    a300_pm4.fw \
    wcnss.b00 \
    wcnss.b01 \
    wcnss.b02 \
    wcnss.b04 \
    wcnss.b06 \
    wcnss.b09 \
    wcnss.b10 \
    wcnss.b11 \
    wcnss.mdt

firmware_files_2 :=  \
    WCNSS_qcom_wlan_nv.bin

$(foreach f, $(firmware_files), $(call add-qcom-firmware, $(f), $(TARGET_OUT_VENDOR)/firmware))
$(foreach f, $(firmware_files_2), $(call add-qcom-firmware, $(f), $(TARGET_OUT_VENDOR)/firmware/wlan/prima))
