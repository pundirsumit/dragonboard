# Copyright 2018 The Android Open Source Project
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

PRODUCT=db820c
DEVICE_DIR=device/linaro/dragonboard/
PRODUCT_OUT_DIR=$ANDROID_BUILD_TOP/out/target/product/$PRODUCT

# Prepare the staging directory
rm -rf tmp
mkdir tmp

BUILD=eng.`whoami`
BUILDNAME=`ls ${ANDROID_BUILD_TOP}/${PRODUCT}-img-${BUILD}.zip 2> /dev/null`
if [ $? -ne 0 ]; then
  VERSION=linaro-`date +"%Y.%m.%d"`
else
  # Installing an existing ${ANDROID_BUILD_TOP}/${PRODUCT}-img-*.zip image package?
  echo "Installing from prebuilt zip image package $BUILDNAME"
  BUILDNAME=`ls ${ANDROID_BUILD_TOP}/${PRODUCT}-img-*.zip 2> /dev/null`
  BUILD=`basename ${BUILDNAME} | cut -f3 -d'-' | cut -f1 -d'.'`
  VERSION=$BUILD

  # unzip the existing image package to tmp and copy AOSP images from there
  unzip -d tmp $BUILDNAME
  PRODUCT_OUT_DIR=tmp
fi

# The staging directory
mkdir tmp/$PRODUCT-$VERSION

# copy over bootloader binaries
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/README tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/gpt_both0.bin tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/gpt_both1.bin tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/gpt_both2.bin tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/gpt_both3.bin tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/gpt_both4.bin tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/gpt_both5.bin tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/sbc_1.0_8096.bin tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/xbl.elf tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/rpm.mbn tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/tz.mbn tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/hyp.mbn tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/pmic.elf tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/emmc_appsboot.mbn tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/devcfg.mbn tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/cmnlib64.mbn tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/cmnlib.mbn tmp/$PRODUCT-$VERSION/
cp $ANDROID_BUILD_TOP/$DEVICE_DIR/installer/db820c/keymaster.mbn tmp/$PRODUCT-$VERSION/

# "fastboot update <zip>" is not flashing cache and userdata partitions
# for some reason. So copy over AOSP images and flash them separately instead.
cp $PRODUCT_OUT_DIR/boot.img tmp/$PRODUCT-$VERSION/
cp $PRODUCT_OUT_DIR/system.img tmp/$PRODUCT-$VERSION/
cp $PRODUCT_OUT_DIR/vendor.img tmp/$PRODUCT-$VERSION/
cp $PRODUCT_OUT_DIR/cache.img tmp/$PRODUCT-$VERSION/
cp $PRODUCT_OUT_DIR/userdata.img tmp/$PRODUCT-$VERSION/

# Write flash-all.sh
cat > tmp/$PRODUCT-$VERSION/flash-all.sh << EOF
#!/bin/bash

# Copyright 2018 The Android Open Source Project
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

# Flash GPT and bootloader firmware files
fastboot flash partition:0 gpt_both0.bin
fastboot flash partition:1 gpt_both1.bin
fastboot flash partition:2 gpt_both2.bin
fastboot flash partition:3 gpt_both3.bin
fastboot flash partition:4 gpt_both4.bin
fastboot flash partition:5 gpt_both5.bin

fastboot erase ddr

fastboot flash cdt sbc_1.0_8096.bin
fastboot flash xbl xbl.elf
fastboot flash rpm rpm.mbn
fastboot flash tz tz.mbn
fastboot flash hyp hyp.mbn
fastboot flash pmic pmic.elf
fastboot flash aboot emmc_appsboot.mbn
fastboot flash devcfg devcfg.mbn
fastboot flash cmnlib64 cmnlib64.mbn
fastboot flash cmnlib cmnlib.mbn
fastboot flash keymaster keymaster.mbn

fastboot reboot-bootloader

# "fastboot update <zip>" is not flashing cache and userdata partitions
# for some reason. So don't do "fastboot update" and use "fastboot flash"
# instructions instead. #FIXME
fastboot flash boot boot.img
fastboot flash system system.img
fastboot flash vendor vendor.img
fastboot flash cache cache.img
fastboot flash userdata userdata.img

fastboot reboot
EOF

chmod a+x tmp/$PRODUCT-$VERSION/flash-all.sh

# Create the distributable package
(cd tmp ; zip -r ../$PRODUCT-$VERSION-factory.zip $PRODUCT-$VERSION)
mv $PRODUCT-$VERSION-factory.zip $PRODUCT-$VERSION-factory-$(sha256sum < $PRODUCT-$VERSION-factory.zip | cut -b -8).zip

# Clean up
rm -rf tmp
