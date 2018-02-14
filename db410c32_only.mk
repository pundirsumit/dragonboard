TARGET_PREBUILT_KERNEL ?= db410c-qcomlt-4.14.gz-dtb

# Inherit the full_base and device configurations
$(call inherit-product, device/linaro/dragonboard/db410c32_only/device.mk)
$(call inherit-product, device/linaro/dragonboard/device-common.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Product overrides
PRODUCT_NAME := db410c32_only
PRODUCT_DEVICE := db410c32_only
PRODUCT_BRAND := Android
