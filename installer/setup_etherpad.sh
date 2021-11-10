#!/bin/bash 

#this installs extra apt sources, does it have the right arm binaries?
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs
git clone --branch master https://github.com/ether/etherpad-lite.git
cd etherpad-lite/src/bin
export NODE_ENV=production
./run.sh
cd -
