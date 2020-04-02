include device/linaro/dragonboard/BoardConfigCommon.mk

# Primary Arch
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi

# Secondary Arch
TARGET_2ND_ARCH :=
TARGET_2ND_ARCH_VARIANT :=
TARGET_2ND_CPU_VARIANT :=
TARGET_2ND_CPU_ABI :=
TARGET_2ND_CPU_ABI2 :=

# Board Information
TARGET_BOOTLOADER_BOARD_NAME := db410c
TARGET_BOARD_PLATFORM := db410c

# Kernel/boot.img Configuration
TARGET_NO_KERNEL := false
BOARD_KERNEL_BASE := 0x80008000
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x0
BOARD_KERNEL_CMDLINE := earlycon firmware_class.path=/vendor/firmware/ androidboot.hardware=db410c
BOARD_KERNEL_CMDLINE += init=/init androidboot.boot_devices=soc/7824900.sdhci printk.devkmsg=on

# Image Configuration
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864 #64M
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1288491008
BOARD_USERDATAIMAGE_PARTITION_SIZE := 5653544960
BOARD_VENDORIMAGE_PARTITION_SIZE := 69206016 #66M
BOARD_FLASH_BLOCK_SIZE := 512
