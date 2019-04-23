# Inherit the full_base and device configurations
$(call inherit-product, $(SRC_TARGET_DIR)/product/go_defaults_512.mk)
$(call inherit-product, device/linaro/dragonboard/db410c/device.mk)
$(call inherit-product, device/linaro/dragonboard/device-common.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Product overrides
PRODUCT_NAME := db410c
PRODUCT_DEVICE := db410c
PRODUCT_BRAND := Android
