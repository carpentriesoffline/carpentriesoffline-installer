#!/bin/bash 

#before using run apt-get -y install unzip git wget qemu-system-arm qemu-efi expect 

#check arguments are right
if [ "$#" != "1" ] ; then
    echo "Usage: build_img.sh <destination directory>"
    exit 1
fi


OUTPUT_DIR=$1
IMG_URL=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-04-07/2022-04-04-raspios-bullseye-armhf-lite.img.xz
img_name=2022-04-04-raspios-bullseye-armhf-lite.img


cd build_img


#assuming we have a checkout of the carpentries-offline repo in working directory script was started from

wget $IMG_URL

#we should check the sha256 sum
#echo "d49d6fab1b8e533f7efc40416e98ec16019b9c034bc89c59b83d0921c2aefeef 2021-01-11-raspios-buster-armhf-lite.zip" | sha256sum -c

xz -d 2022-04-04-raspios-bullseye-armhf-lite.img.xz

echo "Extracting kernel/device tree and setting password"
start_sector=`fdisk -l $img_name | grep FAT32 | awk '{print $2}'`
sector_count=`fdisk -l $img_name | grep FAT32 | awk '{print $4}'`
dd if=$img_name of=bootsector.img count=$start_sector bs=512
dd if=$img_name of=bootfs.img skip=$start_sector count=$sector_count bs=512
dd if=$img_name of=os.img skip=$[$start_sector+$sector_count] bs=512 status=progress

mcopy -i bootfs.img ::/bcm2710-rpi-3-b-plus.dtb .
mcopy -i bootfs.img ::/kernel8.img .
echo "Extracted Device Tree and Kernel"

#setup a password
#https://www.raspberrypi.com/news/raspberry-pi-bullseye-update-april-2022/

password=`echo 'raspberry' | openssl passwd -6 -stdin`
echo "pi:$password" > userconf
mcopy -i bootfs.img userconf ::/

#rebuild the image with our password set
mv $img_name $img_name.orig
cat bootsector.img bootfs.img os.img >> $img_name
rm os.img bootsector.img
qemu-img resize -f raw $img_name 8G
echo "Updated image with password set"

#let the system boot up once to resize the partition
./resize_pi.exp $img_name
echo "Resized Partitons"

reset
clear

#install carpenpi
./install_carpenpi.exp $img_name

echo "Installed Software"

start_sector=`fdisk -l $img_name | tail -1 | awk '{print $2}'`
size=`fdisk -l $img_name | tail -1 | awk '{print $4}'`

echo "Extracting boot filesystem"

dd if=$img_name of=bootfs.img count=$start_sector bs=512 status=progress


echo "Extracting os filesystem"
dd if=$img_name of=fs.img skip=$start_sector count=$size bs=512 status=progress

e2fsck fs.img
resize2fs -M fs.img

echo "Combining Images"
cat bootfs.img fs.img > combined.img

echo "Shrinking Partition"
./shrink_part.exp combined.img


echo "Exporting Finish Image"
mv $img_name $img_name.fullsize
mv combined.img $img_name

zip -9 $OUTPUT_DIR/release.zip $img_name

