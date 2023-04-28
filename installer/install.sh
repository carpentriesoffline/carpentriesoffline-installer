#!/bin/bash

start_time=`date +s`

#install any pending updates first
sudo apt update -y
sudo apt upgrade -y

#install key utilities just in case we don't have them
sudo apt install -y wget unzip git build-essential openssh-server

sudo systemctl enable ssh.service

#set the hostname to carpentries-offline
sudo hostname carpentries-offline
echo carpentries-offline | sudo tee /etc/hostname
sudo sed -i 's/raspberrypi/carpentries-offline/g' /etc/hosts
echo "192.168.1.1     carpentries-offline.org www.carpentries-offline.org" | sudo tee -a /etc/hosts

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

echo "Setting up etherpad"
sudo ./setup_etherpad.sh

echo "Setting up Jupyter"
sudo ./setup_jupyter.sh

echo "Setting up Openrefine"
sudo ./setup_openrefine.sh

echo "Setting up RStudio"
sudo ./setup_rstudio.sh

echo "Installation took $[$end_time-$start_time] seconds"
echo "Done, rebooting"

if [ -f /.dockerenv ] ; then
    #don't try to reboot docker
    exit 0
else 
    sudo reboot
fi
