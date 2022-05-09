#!/bin/bash

#raspbian desktop cleanup
if [ $(lscpu | grep "^Arch" | awk '{print $2}') = "i686" ] ; then
  echo "WARNING: About to delete desktop software, do you want to proceed y/n"
  read r
  if [ "$r" = "y" ] ; then
    sudo apt --purge remove x11-* ant  default-jre-headless java8-runtime-headless ca-certificates-java libreoffice-* vlc* libvlc* desktop-base xserver-xorg lxde lxde-core pixflat-icons pipanel lightdm 
    sudo apt-get autoremove
    #turn off graphical login
    sudo systemctl set-default mutli-user.target
  else
    exit
  fi  
fi

wget https://github.com/carpentriesoffline/carpentriesoffline-installer/archive/refs/heads/main.zip -O automated_install.zip
unzip automated_install.zip
cd carpentriesoffline-installer-main/installer
sudo ./install.sh
