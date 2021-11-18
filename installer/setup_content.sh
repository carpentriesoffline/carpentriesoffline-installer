#!/bin/bash

apt install python3-pip

pip3 install git+https://git@github.com/CarpenPi/web-free-data-science.git

#hack to fix R version until pull request fixing this upstream is accepted
sed -i 's/R-4.1.1/R-4.1.2/g' /usr/local/lib/python3.7/dist-packages/carpenpi/urls.py

cd /var/www/html/
/usr/local/bin/carpenpi download .
