LOCAL_PATH := $(call my-dir)

# $(1): The source file name in LOCAL_PATH.
#       It also serves as the module name and the dest file name.
# $(2): Module installation path.
define add-qcom-firmware
$(eval include $(CLEAR_VARS))\
$(eval LOCAL_MODULE := $(1))\
$(eval LOCAL_SRC_FILES := $(1))\
$(eval LOCAL_MODULE_STEM := $(1))\
$(eval LOCAL_MODULE_CLASS := FIRMWARE)\
$(eval LOCAL_MODULE_TAGS := optional)\
$(eval LOCAL_MODULE_PATH := $(2))\
$(eval include $(BUILD_PREBUILT))
endef

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
