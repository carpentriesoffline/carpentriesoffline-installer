#!/bin/bash

#get the architecture and convert it to one of 386, armv6l or amd64 to match names in the go packages
arch=$(lscpu | grep "^Arch" | awk '{print $2}' | sed 's/i[0-9]86/386/') | sed 's/armv[0-9]l/armv6l/' | sed 's/x86_64/amd64/')

#get the latest gitea version number
latest_gitea=$(curl https://dl.gitea.io/gitea/ | grep -o "Current Release [0-9]*\.[0-9]*\.[0-9]*" | head -1 |  awk '{print $3}')

wget https://dl.gitea.io/gitea/$latest_gitea/gitea-$latest_gitea-linux-$arch -O /usr/local/bin/gitea

#create git user
adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Git Version Control' \
   --group \
   --disabled-password \
   --home /home/git \
   git

mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea

export GITEA_WORK_DIR=/var/lib/gitea/

#install systemd service
wget https://github.com/go-gitea/gitea/blob/master/contrib/systemd/gitea.service -O /etc/systemd/system/gitea.service
systemctl enable gitea
systemctl start gitea


#setup supervisord
apt install supervisor
mkdir /home/git/gitea/log/supervisor
wget https://github.com/go-gitea/gitea/blob/master/contrib/supervisor/gitea -O /etc/supervisor/supervisord.conf
systemctl enable supervisor
systemctl start supervisor


