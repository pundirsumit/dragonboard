include device/linaro/dragonboard/BoardConfigCommon.mk

TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH :=
TARGET_2ND_ARCH_VARIANT :=
TARGET_2ND_CPU_ABI :=
TARGET_2ND_CPU_ABI2 :=
TARGET_2ND_CPU_VARIANT :=

# Board Information
TARGET_BOOTLOADER_BOARD_NAME := db410c_32
TARGET_BOARD_PLATFORM := db410c_32

# Image Configuration
BOARD_KERNEL_BASE := 0x80008000
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x0
BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive firmware_class.path=/system/vendor/firmware/ androidboot.hardware=db410c
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1288491008
BOARD_USERDATAIMAGE_PARTITION_SIZE := 5653544960
