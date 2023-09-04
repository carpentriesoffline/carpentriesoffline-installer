#!/bin/bash

# script to install software/config to setup an access point on the Pi

# ensure we are running on a pi
if grep -q "Raspberry" /proc/cpuinfo ; then
  # install packages, hostap for running the access point, isc-dhcp-server to provide IP addresses and NTP to provide time configuration
  apt -y install hostapd dnsmasq ntp iptables

  # copy config files
  cp access_point_files/interfaces /etc/network/
  cp access_point_files/iptables.ipv4.nat /etc
  cp access_point_files/hostapd.conf /etc/hostapd
  cp access_point_files/hostapd /etc/default/
  cp access_point_files/dnsmasq /etc/default/
  cp access_point_files/dnsmasq.conf /etc/
  cp access_point_files/ntp.conf /etc/ntp.conf

  # allow forwarding/internet access via the Pi
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

  systemctl unmask hostapd.service
  systemctl enable hostapd.service
  #we don't need wpa_supplicant after hostapd is active
  systemctl disable wpa_supplicant
  #we don't need dhcpcd either as the interfaces file invokes dhclient instead
  systemctl disable dhcpcd

  #make sure rfkill doesn't disable the wifi
  awk '{print $0" systemd.restore_state=0 rfkill.default_state=1"}' /boot/cmdline.txt > /boot/cmdline.txt.new
  rm /boot/cmdline.txt
  mv /boot/cmdline.txt.new /boot/cmdline.txt

else
  echo "Not configuring access point mode as we aren't on a Raspberry Pi"
fi
