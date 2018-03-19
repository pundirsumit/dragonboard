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

# QCA ROME firmware files copied from
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/qca
firmware_files_bt :=  \
    nvm_00130300.bin \
    nvm_00130302.bin \
    nvm_usb_00000200.bin \
    nvm_usb_00000201.bin \
    nvm_usb_00000300.bin \
    nvm_usb_00000302.bin \
    rampatch_00130300.bin \
    rampatch_00130302.bin \
    rampatch_usb_00000200.bin \
    rampatch_usb_00000201.bin \
    rampatch_usb_00000300.bin \
    rampatch_usb_00000302.bin

$(foreach f, $(firmware_files_bt), $(call add-qcom-firmware, $(f), $(TARGET_OUT_VENDOR)/firmware/qca/))
