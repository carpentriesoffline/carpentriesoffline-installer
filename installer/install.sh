#!/bin/bash

start_time=`date +s`

#install any pending updates first
sudo apt update -y
sudo apt upgrade -y

#install key utilities just in case we don't have them
sudo apt install -y wget unzip git build-essential openssh-server

sudo systemctl enable ssh.service

#set the hostname to carpentriesoffline
sudo hostname carpentriesoffline
echo carpentriesoffline | sudo tee /etc/hostname
sudo sed -i 's/raspberrypi/carpentriesoffline/g' /etc/hosts
echo "192.168.1.1     carpentriesoffline.org www.carpentriesoffline.org" | sudo tee -a /etc/hosts

echo "Setting up Raspberry Pi"
sudo ./setup_rpi.sh
clear

echo "Setting up Web Server"
sudo ./apache2.sh
clear

echo "Getting Content"
sudo ./setup_content.sh
clear

echo "Setting up Gitea"
sudo ./setup_gitea.sh
clear

echo "Setting up Access Point"
sudo ./setup_accesspoint.sh
clear

end_time=`date +s`

echo "Installation took $[$end_time-$start_time] seconds"
echo "Done, rebooting"

if [ -f /.dockerenv ] ; then
    #don't try to reboot docker
    exit 0
else 
    sudo reboot
fi
