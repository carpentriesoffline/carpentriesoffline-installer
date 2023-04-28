#!/bin/bash

#install java runtime environment
apt-get -y install default-jre-headless

#create an openrefine user
sudo adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Openrefine' \
   --group \
   --disabled-password \
   --home /home/openrefine \
   openrefine

cd /home/openrefine

#install openrefine
wget https://github.com/OpenRefine/OpenRefine/releases/download/3.7.2/openrefine-linux-3.7.2.tar.gz
tar xvfz openrefine-linux-3.7.2.tar.gz

cd -
#enable openrefine service
cp openrefine.service /etc/systemd/system/
systemctl enable openrefine
systemctl start openrefine
