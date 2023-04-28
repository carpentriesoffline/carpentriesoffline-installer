#!/bin/bash

#install java runtime environment
apt-get -y install default-jre-headless

#install openrefine
wget https://github.com/OpenRefine/OpenRefine/releases/download/3.7.2/openrefine-linux-3.7.2.tar.gz
tar xvfz openrefine-linux-3.7.2.tar.gz
mv openrefine-3.7.2 /usr/local/

#enable openrefine service
cp openrefine.service /etc/systemd/system/
systemctl enable openrefine
systemctl start openrefine
