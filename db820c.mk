TARGET_PREBUILT_KERNEL ?= db820c-qcomlt-4.14.gz-dtb

# Inherit the full_base and device configurations
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/linaro/dragonboard/db820c/device.mk)
$(call inherit-product, device/linaro/dragonboard/device-common.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Product overrides
PRODUCT_NAME := db820c
PRODUCT_DEVICE := db820c
PRODUCT_BRAND := Android
