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

PRODUCT_COPY_FILES := \
    device/linaro/dragonboard-kernel/$(TARGET_PREBUILT_KERNEL):kernel \
    device/linaro/dragonboard/fstab.common:root/fstab.db410c \
    device/linaro/dragonboard/init.common.rc:root/init.db410c.rc \
    device/linaro/dragonboard/init.common.usb.rc:root/init.db410c.usb.rc \
    device/linaro/dragonboard/ueventd.common.rc:root/ueventd.db410c.rc \
    device/linaro/dragonboard/common.kl:system/usr/keylayout/db410c.kl

# Dalvik/ART Heap Configuration
PRODUCT_PROPERTY_OVERRIDES := \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=96m \
    dalvik.vm.heapsize=32m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=8m

# Build generic Audio HAL
PRODUCT_PACKAGES := audio.primary.db410c

$(call inherit-product, $(LOCAL_PATH)/firmware/device.mk)
