#!/bin/bash

#get the architecture and convert it to one of 386, armv6l or amd64 to match names in the go packages
arch=$(lscpu | grep "^Arch" | awk '{print $2}' | sed 's/i[0-9]86/386/' | sed 's/armv[0-9]l/arm-6/' | sed 's/x86_64/amd64/' | sed 's/aarch64/arm64/' )

#get the latest gitea version number
#latest_gitea=$(curl https://dl.gitea.io/gitea/ | grep -o "Current Release [0-9]*\.[0-9]*\.[0-9]*" | head -1 |  awk '{print $3}')
latest_gitea="1.15.2"

wget https://dl.gitea.io/gitea/$latest_gitea/gitea-$latest_gitea-linux-$arch -O /usr/local/bin/gitea
chmod +x /usr/local/bin/gitea

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

#copy gitea config
cp gitea/app.ini /etc/gitea/app.ini
chown git:git /etc/gitea/app.ini

#copy gitea sql database
download_dir=`pwd`
cd / 
tar xvfz $download_dir/gitea/gitea_data.tar.gz
cd -

#install systemd service
wget https://raw.githubusercontent.com/go-gitea/gitea/main/contrib/systemd/gitea.service -O /etc/systemd/system/gitea.service
systemctl enable gitea
systemctl start gitea

#not needed? systemd does this for us
#setup supervisord
#apt install -y supervisor
#mkdir /home/git/gitea/log/supervisor
#wget https://raw.githubusercontent.com/go-gitea/gitea/main/contrib/supervisor/gitea -O /etc/supervisor/supervisord.conf
#systemctl enable supervisor
#systemctl start supervisor


