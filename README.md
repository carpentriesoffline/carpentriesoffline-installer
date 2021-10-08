[![fair-software.eu](https://img.shields.io/badge/fair--software.eu-%E2%97%8F%20%20%E2%97%8F%20%20%E2%97%8B%20%20%E2%97%8B%20%20%E2%97%8B-orange)](https://fair-software.eu)

# General CarpenPi Documentation
Overview of the project: https://github.com/CarpenPi/docs/wiki

# Initial Setup of the Raspberry Pi

## You will need:
* A Raspberry Pi with an internet connection
* Running Raspbian OS Lite
* 2.5GB of more free on the SD card

### Setting up a Raspberry Pi with an operating system:
* Download Raspbian OS Lite: https://www.raspberrypi.org/software/operating-systems/
* Write image to SD card using rpi-imager: https://www.raspberrypi.org/software/

#### Setup for headless config (useful if you don't have a screen and keyboard to hand)
* In the boot (small FAT32) partition on the SD card create an empty file called "ssh"
* If you're using WiFi to get online, create a file called wpa_supplicant.conf in the boot partition. Paste in the following and set your network SSID and password appropriately.

```
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
* curl https://raw.githubusercontent.com/CarpenPi/WebServer/main/setup.sh > setup.sh && bash ./setup.sh

## Change the password
* Run the passwd command. Leaving the default password will mean anybody in your workshop can login to your Pi and change settings on it.

## Connect to CarpenPi
* Visit http://<your raspberry pi's IP address>, you should get links to the Carpentries Lessons and the Gitea server.
* The hostname is automatically set to carpenpi. On some networks you'll be able to visit http://carpenpi or http://carpenpi.org, but it depends on your router.
* We still need to get access point mode working together with the web server, currently you need a second Pi to act as the access point or need to rely on another WiFi router.
