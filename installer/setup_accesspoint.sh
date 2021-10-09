#!/bin/bash

# script to install software/config to setup an access point on the Pi

# install packages, hostap for running the access point, isc-dhcp-server to provide IP addresses and NTP to provide time configuration
apt -y install hostapd dnsmasq ntp

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
