#!/bin/bash

wget https://github.com/CarpenPi/WebServer/archive/refs/heads/automated_install.zip -O automated_install.zip
unzip automated_install.zip
cd WebServer-automated_install/installer
sudo ./install.sh
