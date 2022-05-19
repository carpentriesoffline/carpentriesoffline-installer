#!/bin/bash 

IMG_URL=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-04-07/2022-04-04-raspios-bullseye-armhf-lite.img.xz
img_name=2022-04-04-raspios-bullseye-armhf-lite.img

#      - name: Download base image
#        if: steps.cache-image.outputs.cache-hit != 'true'
#        run: |
#          wget --quiet ${{ env.IMG_URL }}
#          echo "${{ env.PI_ZIP_CHECKSUM }} ${{ env.PI_ZIP }}" | sha256sum -c
#          unzip ${{ env.PI_ZIP }}
#          mv ${{ env.PI_IMG }} ${{ env.PI_IMG }}.orig
#      - name: Create clean base image
#        run: cp ${{ env.PI_IMG }}.orig ${{ env.PI_IMG }}
#      - name: Install packages
#        run: sudo apt-get install -y qemu-system-arm qemu-efi expect

#before using run apt-get -y install unzip git wget qemu-system-arm qemu-efi expect 

mkdir -p build_img
cd build_img

#assuming we have a checkout of the carpentries-offline repo in working directory script was started from

wget $IMG_URL

#the script should fail if this doesn't match
#echo "d49d6fab1b8e533f7efc40416e98ec16019b9c034bc89c59b83d0921c2aefeef 2021-01-11-raspios-buster-armhf-lite.zip" | sha256sum -c

xz -d 2022-04-04-raspios-bullseye-armhf-lite.img.xz

#extract the kernel and device tree
start_sector=`fdisk -l $img_name | grep FAT32 | awk '{print $2}'`
sector_count=`fdisk -l $img_name | grep FAT32 | awk '{print $4}'`
dd if=$img_name of=bootfs.img skip=$start_sector count=$sector_count bs=512 

mcopy -i bootfs.img ::/bcm2710-rpi-3-b-plus.dtb .
mcopy -i bootfs.img ::/kernel8.img .

#qemu-system-aarch64 -m 1024 -M raspi3b -kernel kernel8.img -dtb bcm2710-rpi-3-b-plus.dtb -sd /build_img/2021-01-11-raspios-buster-armhf-lite.img -append "console=ttyAMA0 root=/dev/mmcblk0p2 rw rootwait rootfstype=ext4" -nographic -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22

#      - name: Resize image
#        run: |
#          cp ${{env.PI_IMG}} base.img
#          qemu-img resize -f raw ${{ env.PI_IMG }} +4G
#          chmod +x ./checkout/test/resize_pi.exp
#          ./checkout/test/resize_pi.exp ${{env.PI_IMG}}

cp $img_name boot.img
chmod +x ../test/resize_pi.exp
qemu-img resize -f raw $img_name 8G

#let the system boot up once to resize the partition
cat ../test/resize_pi.exp
../test/resize_pi.exp $img_name

reset
clear

#install carpenpi
../test/install_carpenpi.exp $img_name


#      - name: Run QEMU & install CarpenPi
#        run: |
#          ls -l ./checkout/test/
#          # Don't do it! It's not ready!
#          #./checkout/test/install_carpenpi.exp ${{env.PI_IMG}}
#      - name: Shrink final image
#        run: |
#          wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
#          chmod a+x pishrink.sh
#          sudo ./pishrink.sh ${{env.PI_IMG}} ${{env.OUTPUT_IMG}}
#          zip ${{env.OUTPUT_ZIP}} ${{env.OUTPUT_IMG}}

start_sector=`fdisk -l $img_name | tail -1 | awk '{print $2}'`
size=`fdisk -l $img_name | tail -1 | awk '{print $4}'`

echo "extracting boot filesystem"

dd if=$img_name of=boot.img count=$start_sector bs=512 status=progress


echo "extracting os filesystem"
dd if=$img_name of=fs.img skip=$start_sector count=$size bs=512 status=progress

e2fsck fs.img
resize2fs -M fs.img

echo "combining images"
cat boot.img fs.img > combined.img

echo "shrinking partition"
../test/shrink_part.exp combined.img

mv $img_name $img_name.fullsize
mv combined.img $img_name

zip -9 release.zip $img_name

#      - name: Upload image as release
#        id: upload-release-asset 
#        uses: actions/upload-release-asset@v1
#        env:
#          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
#        with:
#          upload_url: ${{ github.event.release.upload_url }}
#          asset_path: ${{env.OUTPUT_ZIP}}
#          asset_name: ${{env.OUTPUT_ZIP}}
#          asset_content_type: application/zip
