#!/bin/bash

sudo ./apache2.sh
sudo ./setup_jekyll.sh
./build_webpages.sh
sudo ./deploy_webpages.sh
sudo ./setup_cran.sh
