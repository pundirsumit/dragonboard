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

# Ath10k Qca6174 firmware files copied from
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/ath10k/
firmware_files_wifi :=  \
    QCA6174/hw3.0/board-2.bin \
    QCA6174/hw3.0/board.bin \
    QCA6174/hw3.0/firmware-4.bin \
    QCA6174/hw3.0/firmware-6.bin \
    QCA6174/hw3.0/notice_ath10k_firmware-4.txt \
    QCA6174/hw3.0/notice_ath10k_firmware-6.txt

$(foreach f, $(firmware_files_wifi), $(call add-qcom-firmware, $(f), $(TARGET_OUT_VENDOR)/firmware/ath10k))
