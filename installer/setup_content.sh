#!/bin/bash

#only run if we didn't do this already, since it takes ages and is breaking github actions builds
if [ ! -d "/var/www/html/lessons" ] ; then

    os=`grep "^ID=" /etc/os-release | awk -F= '{print $2}'`
    # ubuntu only comes with R 4.1, we're trying to target R 4.4, let's get a newer version
    if [ "$os" = "ubuntu" ] ; then
        wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
        gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
        codename=`grep "^VERSION_CODENAME=" /etc/os-release | awk -F= '{print $2}'`
        echo "deb https://cloud.r-project.org/bin/linux/ubuntu $codename-cran40/" >> /etc/apt/sources.list
        apt -y update
    fi
 
    apt install -y python3-pip pipx r-base-core python3-lxml libssl-dev r-cran-curl
    #some weird bug means we have to try and install these twice as a download fails sometimes
    apt install -y python3-pip pipx r-base-core python3-lxml libssl-dev r-cran-curl
    
    #ubuntu docker images provide an old version of pip which doesn't work, upgrade it
    python3 -m pip install pip -U
    pipx install git+https://github.com/carpentriesoffline/offlinedatasci.git
    
    #hack to fix R version until pull request fixing this upstream is accepted
    #sed -i 's/R-4.1.0/R-4.1.1/g' /usr/local/lib/python3.7/dist-packages/carpenpi/urls.py
    
    cd /var/www/html/

    /usr/local/bin/offlinedatasci install all .
fi
