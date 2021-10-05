#!/bin/bash

mkdir /var/www/html/lessons

for site in `find sites -maxdepth 1 -type d` ; do
    if [ $site = "sites" ] ; then
	continue
    fi
    cp -r $site/_site /var/www/html/lessons/$(basename $site)

done




