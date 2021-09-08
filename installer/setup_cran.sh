#!/bin/bash

apt update
apt install -y r-base-core libssl-dev r-cran-curl r-cran-httr
mkdir /var/www/html/MiniCRAN
R --no-save < minicran.R

