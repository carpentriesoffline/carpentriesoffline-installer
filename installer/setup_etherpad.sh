#!/bin/bash 

#this installs extra apt sources, does it have the right arm binaries?
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs


#create a jupyter user
sudo adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Etherpad' \
   --group \
   --disabled-password \
   --home /home/etherpad \
   etherpad

cd /home/etherpad
sudo -s -u etherpad git clone --branch master https://github.com/ether/etherpad-lite.git
sudo -s -u etherpad sed -i 's/"suppressErrorsInPadText": false/"suppressErrorsInPadText": true/' /home/etherpad/etherpad-lite/settings.json

cd -
sudo cp etherpad.service /etc/systemd/system/
sudo systemctl enable etherpad
sudo systemctl start etherpad


