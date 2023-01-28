#!/bin/bash

start_sector=`fdisk -l $1 | grep FAT32 | awk '{print $2}'`
sector_count=`fdisk -l $1 | grep FAT32 | awk '{print $4}'`
dd if=$1 of=bootfs.img skip=$start_sector count=$sector_count bs=512
mcopy -i bootfs.img ::/bcm2710-rpi-3-b-plus.dtb .
mcopy -i bootfs.img ::/kernel8.img .

qemu-img resize -f raw $1 8G

qemu-system-aarch64 -m 1024 -M raspi3b -kernel kernel8.img -dtb bcm2710-rpi-3-b-plus.dtb -sd $1 -append "console=ttyAMA0 root=/dev/mmcblk0p2 rw rootwait rootfstype=ext4" -nographic -device usb-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:22 -no-reboot

