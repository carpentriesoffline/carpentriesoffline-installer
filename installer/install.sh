#!/bin/bash

#install any pending updates first
sudo apt update -y
sudo apt upgrade -y

#set the hostname to carpenpi
sudo hostname carpenpi
echo carpenpi | sudo tee /etc/hostname
sudo sed -i 's/raspberrypi/carpenpi/g' /etc/hosts

sudo ./setup_gitea.sh
sudo ./apache2.sh
sudo ./setup_jekyll.sh
./build_webpages.sh
sudo ./deploy_webpages.sh
sudo ./setup_cran.sh

sudo reboot
