#!/usr/bin/env bash

echo $USER
echo $HOME
cd $HOME

#qemu-system-arm \
 #-M versatilepb \
 #-cpu arm1176 \
 #-m 256 \
 #-drive "file=2021-01-11-raspios-buster-armhf-lite.img,if=none,index=0,media=disk,format=raw,id=disk0" \
 #-device "virtio-blk-pci,drive=disk0,disable-modern=on,disable-legacy=off" \
 #-net "user,hostfwd=tcp::5022-:22" \
 #-net nic \
 #-dtb qemu-rpi-kernel/versatile-pb-buster-5.4.51.dtb \
 #-kernel qemu-rpi-kernel/kernel-qemu-5.4.51-buster \
 #-append 'root=/dev/vda2 panic=1' \
 #-no-reboot \
 #-display none \
 #-daemonize
