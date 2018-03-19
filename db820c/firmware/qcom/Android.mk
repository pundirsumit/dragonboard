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
