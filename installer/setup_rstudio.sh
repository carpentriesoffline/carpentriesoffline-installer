#!/bin/bash

#install java runtime environment
apt-get -y install r-base

#create an openrefine user
sudo adduser \
   --system \
   --shell /bin/bash \
   --gecos 'rstudio' \
   --group \
   --disabled-password \
   --home /home/rstudio \
   rstudio

cd /home/rstudio

#install rstudio
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2023.03.0-386-amd64.deb
dpkg -i rstudio-server-2023.03.0-386-amd64.deb

cd -
#enable rstudio service
#cp rstudio.service /etc/systemd/system/
#systemctl enable rstudio
#systemctl start rstudio
