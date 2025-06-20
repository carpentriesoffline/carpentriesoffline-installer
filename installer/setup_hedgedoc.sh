#!/bin/bash

HEDGEDOC_VERSION=1.10.0
HEDGEDOC_URL="https://github.com/hedgedoc/hedgedoc/releases/download/${HEDGEDOC_VERSION}/hedgedoc-${HEDGEDOC_VERSION}.tar.gz"

curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install -y nodejs npm
npm install -g corepack
corepack use yarn@4

adduser \
   --system \
   --shell /bin/bash \
   --gecos 'HedgeDoc user' \
   --group \
   --disabled-password \
   --home /home/hedgedoc \
   hedgedoc

dir="$(mktemp -d)"

pushd "$dir"
wget "$HEDGEDOC_URL"
tar zxvf hedgedoc_${HEDGEDOC_VERSION}.tar.gz -C /home/hedgedoc
chown -R hedgedoc:hedgedoc /home/hedgedoc
popd

pushd "/home/hedgedoc/hedgedoc"
su hedgedoc -c "./bin/setup"
popd

# copy configuration and service
cp ./hedgedoc-config.json /home/hedgedoc/hedgedoc/config.json
cp ./hedgedoc.service /etc/systemd/system/
systemctl enable hedgedoc
systemctl start hedgedoc
