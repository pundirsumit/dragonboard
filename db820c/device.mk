#
# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Override heap size and growth limit
# Copied from Marlin
PRODUCT_PROPERTY_OVERRIDES := \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=36m

$(call inherit-product-if-exists, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

PRODUCT_COPY_FILES := \
    device/linaro/dragonboard-kernel/$(TARGET_PREBUILT_KERNEL):kernel \
    device/linaro/dragonboard/fstab.common:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.db820c \
    device/linaro/dragonboard/init.common.rc:root/init.db820c.rc \
    device/linaro/dragonboard/init.common.usb.rc:root/init.db820c.usb.rc \
    $(LOCAL_PATH)/init.db820c.power.rc:root/init.db820c.power.rc \
    device/linaro/dragonboard/common.kl:system/usr/keylayout/db820c.kl

# Build generic Power HAL
PRODUCT_PACKAGES += power.db820c

$(call inherit-product, $(LOCAL_PATH)/firmware/device.mk)
