#!/bin/bash

#install any pending updates first
sudo apt update -y
sudo apt upgrade -y

#install key utilities just in case we don't have them
sudo apt install -y wget unzip git build-essential adduser

#set the hostname to carpenpi
sudo hostname carpenpi
echo carpenpi | sudo tee /etc/hostname
sudo sed -i 's/raspberrypi/carpenpi/g' /etc/hosts
echo "192.168.1.1     carpenpi.org www.carpenpi.org" | sudo tee -a /etc/hosts

sudo ./setup_rpi.sh
sudo ./apache2.sh
sudo ./setup_content.sh
#./build_webpages.sh
#sudo ./deploy_webpages.sh
sudo ./setup_cran.sh
sudo ./setup_gitea.sh
sudo ./setup_accesspoint.sh
sudo ./setup_etherpad.sh
sudo ./setup_jupyter.sh
sudo reboot
