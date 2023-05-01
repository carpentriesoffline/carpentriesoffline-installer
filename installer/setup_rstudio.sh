#!/bin/bash

#install java runtime environment
apt-get -y install r-base libclang-dev

#create an openrefine user
sudo adduser \
   --shell /bin/bash \
   --gecos 'rstudio' \
   --home /home/rstudio \
   --disabled-password \
   rstudio

usermod -p `python3 -c "import crypt; print(crypt.crypt('test'))"` rstudio

cd /home/rstudio

#install rstudio
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2023.03.0-386-amd64.deb
dpkg -i rstudio-server-2023.03.0-386-amd64.deb

cd -
#enable rstudio service
#cp rstudio.service /etc/systemd/system/
#systemctl enable rstudio
#systemctl start rstudio
