include device/linaro/dragonboard/BoardConfigCommon.mk

TARGET_CPU_VARIANT := kryo
TARGET_2ND_CPU_VARIANT := kryo

# Board Information
TARGET_BOOTLOADER_BOARD_NAME := db820c
TARGET_BOARD_PLATFORM := db820c

# Image Configuration
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive firmware_class.path=/system/vendor/firmware/ androidboot.hardware=db820c
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 12884901888
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456