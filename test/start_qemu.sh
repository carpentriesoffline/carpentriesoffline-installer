#!/usr/bin/env bash

PI_IMG=$1

echo PI_IMG=$PI_IMG
echo PWD=$(pwd)

export QEMU_AUDIO_DRV=none # disable audio

mkfifo /tmp/pi_io.in /tmp/pi_io.out # Setup serial IO for seeing pi output

qemu-system-arm \
  -serial pipe:/tmp/pi_io \
  -M versatilepb \
  -cpu arm1176 \
  -m 256 \
  -drive "file="$PI_IMG",if=none,index=0,media=disk,format=raw,id=disk0" \
  -device "virtio-blk-pci,drive=disk0,disable-modern=on,disable-legacy=off" \
  -net "user,hostfwd=tcp::5022-:22" \
  -net nic \
  -dtb qemu-rpi-kernel/versatile-pb-buster-5.4.51.dtb \
  -kernel qemu-rpi-kernel/kernel-qemu-5.4.51-buster \
  -append 'root=/dev/vda2 panic=1' \
  -no-reboot \
  -display none \
  -daemonize
