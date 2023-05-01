#!/bin/bash

start_time=`date +s`

#install any pending updates first
apt-get update -y
apt-get upgrade -y

#install key utilities just in case we don't have them
apt-get install -y wget unzip git build-essential openssh-server net-tools iproute2

systemctl enable ssh.service

#set the hostname to carpentries-offline
hostname carpentries-offline
echo carpentries-offline | tee /etc/hostname
sed -i 's/raspberrypi/carpentries-offline/g' /etc/hosts
echo "192.168.1.1     carpentries-offline.org www.carpentries-offline.org" | tee -a /etc/hosts

echo "Setting up Raspberry Pi"
./setup_rpi.sh
clear

echo "Setting up Web Server"
./apache2.sh
clear

echo "Getting Content"
./setup_content.sh
clear

echo "Setting up Gitea"
./setup_gitea.sh
clear

echo "Setting up Access Point"
./setup_accesspoint.sh
clear

end_time=`date +s`

echo "Setting up etherpad"
./setup_etherpad.sh

echo "Setting up Jupyter"
./setup_jupyter.sh

echo "Setting up Openrefine"
./setup_openrefine.sh

echo "Setting up RStudio"
#sudo ./setup_rstudio.sh

echo "Installation took $[$end_time-$start_time] seconds"
echo "Done, rebooting"

if [ -f /.dockerenv ] ; then
    #don't try to reboot docker
    exit 0
else 
    sudo reboot
fi
