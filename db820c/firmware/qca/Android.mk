LOCAL_PATH := $(call my-dir)

include device/linaro/dragonboard/utils.mk

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
