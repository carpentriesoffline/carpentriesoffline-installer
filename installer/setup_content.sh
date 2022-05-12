#!/bin/bash

apt install -y python3-pip r-base-core python3-lxml

pip3 install git+https://git@github.com/carpentriesoffline/offlinedatasci.git

#hack to fix R version until pull request fixing this upstream is accepted
#sed -i 's/R-4.1.0/R-4.1.1/g' /usr/local/lib/python3.7/dist-packages/carpenpi/urls.py

cd /var/www/html/
/usr/local/bin/offlinedatasci setup all .
