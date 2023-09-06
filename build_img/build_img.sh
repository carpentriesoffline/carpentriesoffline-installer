#!/bin/bash 
#script to build a raspberry pi image using qemu

#exit and fail if anything goes wrong
set -e

#before using run apt-get -y install unzip git wget qemu-system-arm qemu-efi expect xz-utils

#check arguments are right
if [ "$#" != "1" ] ; then
    echo "Usage: build_img.sh <destination directory>"
    exit 1
fi

# get GIT_TAG if set, otherwise set to empty variable
GIT_TAG=${GIT_TAG:-}

if [ -z "$GIT_TAG" ]; then
    OUTFILE=release.zip
else
    OUTFILE="release-$GIT_TAG.zip"
fi

OUTPUT_DIR=$1
IMG_URL=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2023-05-03/2023-05-03-raspios-bullseye-armhf-lite.img.xz
xz_img_name=`basename $IMG_URL`
img_name=`echo $xz_img_name | sed 's/.xz$//'`

cd build_img

#assuming we have a checkout of the carpentries-offline repo in working directory script was started from

wget $IMG_URL

#we should check the sha256 sum
#echo "d49d6fab1b8e533f7efc40416e98ec16019b9c034bc89c59b83d0921c2aefeef 2021-01-11-raspios-buster-armhf-lite.zip" | sha256sum -c

xz -d $xz_img_name

echo "Expanding Disk"
qemu-img resize -f raw $img_name 8G

echo "Resizing Partition"
./shrink_part.exp $img_name

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

#expand the filesystem
echo "Expanding Filesystem"
e2fsck -p os.img
resize2fs -p  os.img

#rebuild the image
echo "Rebuilding Image"
mv $img_name $img_name.orig
cat bootsector.img bootfs.img os.img > $img_name
#rm os.img bootsector.img

echo "Updated image with password set"


#grab offline datasci from outside of qemu, it is faster and more reliable
apt install -y python3-pip r-base-core python3-lxml libssl-dev r-cran-curl dosfstools 

#ubuntu docker images provide an old version of pip which doesn't work, upgrade it
python3 -m pip install pip -U
pip3 install git+https://git@github.com/carpentriesoffline/offlinedatasci.git

mkdir offlinedatasci
cd offlinedatasci
"$(date +'%d/%m/%Y-%H:%M')" > build_date.txt
offlinedatasci install all .
tar cvf ../offlinedatasci.tar *
cd ..
qemu-img create -f raw offlinedatasci.img 2G
mkfs.vfat offlinedatasci.img
mcopy -i offlinedatasci.img offlinedatasci.tar ::/

#install carpenpi
./install_carpenpi.exp $img_name

echo "Installed Software"

start_sector=`fdisk -l $img_name | tail -1 | awk '{print $2}'`
size=`fdisk -l $img_name | tail -1 | awk '{print $4}'`

echo "Extracting boot filesystem"

dd if=$img_name of=bootfs.img count=$start_sector bs=512 status=progress


echo "Extracting os filesystem"
dd if=$img_name of=fs.img skip=$start_sector count=$size bs=512 status=progress

e2fsck -p fs.img
resize2fs -M fs.img

echo "Combining Images"
cat bootfs.img fs.img > combined.img

echo "Shrinking Partition"
./shrink_part.exp combined.img


echo "Exporting Finished Image"
mv $img_name $img_name.fullsize
output_name=carpentries-offline-`date +%Y-%m-%d`.img
mv combined.img $output_name

ls -ld $OUTPUT_DIR

touch $OUTPUT_DIR/test

zip -dd -9 -s 2047m $OUTPUT_DIR/release $output_name
#xz -v -z $img_name 
#mv $img_name.xz $OUTPUT_DIR/release.xz

