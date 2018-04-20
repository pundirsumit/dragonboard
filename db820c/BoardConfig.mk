include device/linaro/dragonboard/BoardConfigCommon.mk

TARGET_CPU_VARIANT := kryo
TARGET_2ND_CPU_VARIANT := kryo

# Board Information
TARGET_BOOTLOADER_BOARD_NAME := db820c
TARGET_BOARD_PLATFORM := db820c

# Image Configuration
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_CMDLINE := firmware_class.path=/vendor/firmware/ androidboot.hardware=db820c
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4294967296 #4G
BOARD_USERDATAIMAGE_PARTITION_SIZE := 12884901888 #12G
BOARD_CACHEIMAGE_PARTITION_SIZE := 536870912 #512M
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_PARTITION_SIZE := 2147483648 #2G
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
