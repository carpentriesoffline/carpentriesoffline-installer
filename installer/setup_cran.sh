#!/bin/bash

apt update
apt install -y r-base-core libssl-dev r-cran-curl r-cran-httr
R --no-save < minicran.R

