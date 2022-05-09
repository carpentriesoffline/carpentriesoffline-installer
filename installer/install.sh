#!/bin/bash

#install any pending updates first
sudo apt update -y
sudo apt upgrade -y

#install key utilities just in case we don't have them
sudo apt install -y wget unzip git build-essential

#set the hostname to carpentries-offline
sudo hostname carpentries-offline
echo carpentries-offline | sudo tee /etc/hostname
sudo sed -i 's/raspberrypi/carpentries-offline/g' /etc/hosts
echo "192.168.1.1     carpentries-offline.org www.carpentries-offline.org" | sudo tee -a /etc/hosts

sudo ./setup_rpi.sh
sudo ./apache2.sh
sudo ./setup_content.sh
sudo ./setup_gitea.sh
sudo ./setup_accesspoint.sh

sudo reboot
