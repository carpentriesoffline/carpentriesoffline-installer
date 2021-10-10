#!/bin/bash

apt install python3-pip

pip3 install git+https://git@github.com/CarpenPi/web-free-data-science.git

cd /var/www/html/
~/.local/bin/carpenpi download .



