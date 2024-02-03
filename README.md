[![fair-software.eu](https://img.shields.io/badge/fair--software.eu-%E2%97%8F%20%20%E2%97%8F%20%20%E2%97%8B%20%20%E2%97%8B%20%20%E2%97%8B-orange)](https://fair-software.eu)

# General Carpentries Offline Documentation
Overview of the project: https://github.com/carpentriesoffline/CarpentriesOffline.github.io/tree/main/docs

This repository contains scripts to intialise a Raspberry Pi with the Carpentries Offline software. 

# Initial Setup of the Raspberry Pi

## You will need:
* A Raspberry Pi with an internet connection
* An installation of Raspberry Pi OS Lite
* 2.5GB of more free on the SD card

## Setting up a Raspberry Pi with an operating system:
* Download Raspbian OS Lite: https://www.raspberrypi.org/software/operating-systems/
* Write image to SD card using rpi-imager: https://www.raspberrypi.org/software/

### Setup for headless config (useful if you don't have a screen and keyboard to hand)
* In the boot (small FAT32) partition on the SD card create an empty file called "ssh"
* If you're using WiFi to get access to the Pi, create a file called wpa_supplicant.conf in the boot partition. Paste in the following and set your network SSID and password appropriately.

```
#set this to your country code, gb=great britain
country=gb
update_config=1
ctrl_interface=/var/run/wpa_supplicant

network={
 scan_ssid=1
 ssid="my_networks_ssid"
 psk="my_networks_password"
}
```

## Run the install script
* Login to your Raspberry Pi with an SSH client or on a local screen/keyboard and run the command:
* curl https://raw.githubusercontent.com/carpentriesoffline/carpentriesoffline-installer/main/setup.sh > setup.sh && bash ./setup.sh

## Change the password
* Run the passwd command. Leaving the default password will mean anybody in your workshop can login to your Pi and change settings on it.

## Connect to Carpentries Offline
* After installing the Raspberry Pi will reboot.
* It will then switch the WiFi interface to access point mode and will be available as a network called carpentries-offline. 
* Connect to the carpenpi WiFi network
* Visting http://carpentriesoffline.org or http://192.168.1.1
* You should get links to the Carpentries Lessons and the Gitea server on the Raspberry Pi

## Using pre-built images
There are pre-built images available from the releases section of this page. These are experimental and unlikely to be fully working yet. 
These are built as multipart zip files with names like release.zip and release.z01, this is due to a 2GB upload limit in our build process. Download each of these. To extract them on a Linux system run the following:

`cat release.z01 release.zip > carpentries-offline.zip`

`unzip carpentries-offline.zip`

After you have downloaded and unzipped the image files, write the image file to an SD card with [Etcher](https://www.balena.io/etcher/) or your image writing program of choice. 

# Development Status

Carpentries offline is still under development and is not yet ready for general use. Here is the general state of each component:

(last updated 2022-08-11)

| Component    | Status  |
| ------------ | ------- |
| Access Point | Works, possible performance issues |
| Course Notes | Working |
| MiniCRAN repository | Needs Testing |
| Pip Repository | Needs Testing |
| R/R studio downloads | Working | 
| Python downloads  | Working |
| Workshop Surveys | Still to do | 
| Etherpad | Work in progress | 
| Jupyter Lab | Work in progress |
| Auto build image via qemu | Work in progress | 
| Dockerfile for cloud deployment | Working, needs documenting |

