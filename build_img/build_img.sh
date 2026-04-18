#!/bin/bash
#script to build a raspberry pi image using qemu
#
# exit and fail if anything goes wrong
set -eou pipefail

TEMP_FOLDER="${TMPDIR:-/tmp}"

msg() {
    echo -e "\e[1m$*\e[0m"
}

extract_device_tree_kernel() {
    img_name="${1:-}"
    if [ -z "$img_name" ]; then
        echo "usage: extract_device_tree_kernel <img>"
        return
    fi
    temp="$(mktemp "$TEMP_FOLDER/carpentriesoffline.XXXXX.bootfs.img")"
    msg "==> Extracting device tree and kernel"
    start_sector=`fdisk -l $img_name | grep FAT32 | awk '{print $2}'`
    sector_count=`fdisk -l $img_name | grep FAT32 | awk '{print $4}'`
    dd if=$img_name of="$temp" skip=$start_sector count=$sector_count bs=512
    mcopy -i "$temp" ::/$driver .
    mcopy -i "$temp" ::/$kernel .
    echo "    Extracted $driver $kernel from $img_name"
}

#before using run apt-get -y install unzip git wget qemu-system-arm qemu-efi-aarch64 qemu-efi-arm expect z-utils

qemu_version=`qemu-system-aarch64 --version | grep -Eo "version [0-9]+" | awk '{print $2}'`
if [ "$qemu_version" -lt "6" ] ; then
    echo "Qemu version too old, please use a newer version (or a newer operating system)"
    exit 1
fi

#check arguments are right
if [ "$#" != "1" ] ; then
    echo "Usage: build_img.sh <destination directory>"
    exit 1
fi

OUTPUT_DIR=$1

# ----- constants ---------
driver=bcm2710-rpi-3-b.dtb
kernel=kernel8.img
SIZE=8G
OFFLINEDATASCI_SIZE=3G
ARCH="${ARCH:-arm64}"
# -------------------------
msg "==> Building for architecture: $ARCH"

# DEVICE_TREE_KERNEL_IMG_URL links to a known good image that allows QEMU to boot
# the Raspberry Pi image. The device tree (dtb) and the kernel image
# are extracted from this image.

case "$ARCH" in
    armhf)
        # IMG_URL=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2026-04-14/2026-04-13-raspios-trixie-armhf-lite.img.xz
        IMG_URL=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2024-11-19/2024-11-19-raspios-bookworm-armhf-lite.img.xz
        DEVICE_TREE_KERNEL_IMG_URL=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2023-05-03/2023-05-03-raspios-bullseye-armhf-lite.img.xz
        ;;
    arm64)
        # IMG_URL=https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2026-04-14/2026-04-13-raspios-trixie-arm64-lite.img.xz
        IMG_URL=https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2024-11-19/2024-11-19-raspios-bookworm-arm64-lite.img.xz
        DEVICE_TREE_KERNEL_IMG_URL=https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2023-05-03/2023-05-03-raspios-bullseye-arm64-lite.img.xz
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

xz_img_name=`basename $IMG_URL`
img_name=`basename "$xz_img_name" .xz`

cd build_img

# msg "==> Getting image for device tree and kernel extraction"
wget -c "$DEVICE_TREE_KERNEL_IMG_URL"
xz_dtb_img_name=`basename $DEVICE_TREE_KERNEL_IMG_URL`
xz -d --keep "$xz_dtb_img_name"
dtb_img_name=`basename $xz_dtb_img_name .xz`
extract_device_tree_kernel "$dtb_img_name"

# ------- offlinedatasci image creation --------------------------------
# offlinedatasci takes a while to download, particularly with
#    offlinedatasci install all .
# build_img checks for existence of offlinedatasci.tar from which it will
# create an image from and mount to the built carpentriesoffline image
# as an external disk
if test offlinedatasci.img -ot offlinedatasci.tar; then
    msg "==> Creating offlinedatasci image"
    qemu-img create -f raw offlinedatasci.img $OFFLINEDATASCI_SIZE
    mkfs.vfat offlinedatasci.img
    mcopy -i offlinedatasci.img offlinedatasci.tar ::/
else
    msg "--> Skip offlinedatasci image creation, already present"
fi
# ----------------------------------------------------------------------

msg "==> Downloading base image"
wget -c $IMG_URL
if [ ! -f "$img_name" ]; then
    xz -d --keep $xz_img_name
fi

msg "==> Expanding disk to $SIZE"
qemu-img resize -f raw $img_name $SIZE
msg "==> Resizing partition"
./shrink_part.exp $img_name
msg "==> Extracting bootsector, bootfs, os"
start_sector=`fdisk -l $img_name | grep FAT32 | awk '{print $2}'`
sector_count=`fdisk -l $img_name | grep FAT32 | awk '{print $4}'`
msg "    Extracting bootsector..."
dd if=$img_name of=bootsector.img count=$start_sector bs=512
msg "    Extracting bootfs..."
dd if=$img_name of=bootfs.img skip=$start_sector count=$sector_count bs=512
msg "    Extracting os..."
dd if=$img_name of=os.img skip=$[$start_sector+$sector_count] bs=512 status=progress

#setup a password
#https://www.raspberrypi.com/news/raspberry-pi-bullseye-update-april-2022/
password=`echo 'raspberry' | openssl passwd -6 -stdin`
echo "pi:$password" > userconf
mcopy -i bootfs.img userconf ::/

msg "==> Expanding filesystem"
e2fsck -p os.img
resize2fs -p os.img

msg "==> Rebuilding image"
mv $img_name $img_name.orig
cat bootsector.img bootfs.img os.img > $img_name

msg "==> Installing CarpentriesOffline"
./install_carpenpi.exp $img_name

msg "==> Extracting boot filesystem"
start_sector=`fdisk -l $img_name | tail -1 | awk '{print $2}'`
size=`fdisk -l $img_name | tail -1 | awk '{print $4}'`
dd if=$img_name of=bootfs.img count=$start_sector bs=512 status=progress

msg "==> Extracting os filesystem"
dd if=$img_name of=fs.img skip=$start_sector count=$size bs=512 status=progress
e2fsck -p fs.img
resize2fs -M fs.img

msg "==> Combining images"
output_name=carpentries-offline-`date +%Y-%m-%d`-$ARCH.img
cat bootfs.img fs.img > $output_name
rm bootfs.img fs.img $img_name $kernel *.dtb

ls -ld $OUTPUT_DIR
