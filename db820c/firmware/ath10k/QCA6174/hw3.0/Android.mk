LOCAL_PATH := $(call my-dir)

include device/linaro/dragonboard/utils.mk

# Ath10k Qca6174 firmware files copied from
# https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/ath10k/
firmware_files_wifi :=  \
    gboard-2.bin \
    gboard.bin \
    gfirmware-4.bin \
    gfirmware-6.bin \
    gnotice_ath10k_firmware-4.txt \
    gnotice_ath10k_firmware-6.txt

$(foreach f, $(firmware_files_wifi), $(call add-qcom-firmware, $(f), $(TARGET_OUT_VENDOR)/firmware/ath10k/QCA6174/hw3.0))
