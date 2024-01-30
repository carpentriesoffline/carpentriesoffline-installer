#!/bin/bash

#only run if we didn't do this already, since it takes ages and is breaking github actions builds
if [ ! -d "/var/www/html/lessons" ] ; then
    apt install -y python3-pip r-base-core python3-lxml libssl-dev r-cran-curl
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
