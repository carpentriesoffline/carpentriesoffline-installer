#!/bin/bash

#install any pending updates first
sudo apt update
sudo apt upgrade

sudo ./setup_gitea.sh
sudo ./apache2.sh
sudo ./setup_jekyll.sh
./build_webpages.sh
sudo ./deploy_webpages.sh
sudo ./setup_cran.sh
