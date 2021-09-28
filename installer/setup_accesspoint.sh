#!/bin/bash

# script to install software/config to setup an access point on the Pi

# install packages, hostap for running the access point, isc-dhcp-server to provide IP addresses and NTP to provide time configuration
apt -y install hostapd isc-dhcp-server ntp

# copy config files
cp interfaces /etc/network/
cp iptables.ipv4.nat /etc
cp hostapd.conf /etc/hostapd
cp hostapd /etc/default/hostapd
cp isc-dhcp-server /etc/default/isc-dhcp-server
cp dhcpd.conf /etc/dhcp/dhcpd.conf
cp ntp.conf /etc/ntp.conf

# allow forwarding/internet access via the Pi
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
