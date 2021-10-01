#!/bin/bash

#this script seems to work without needing root
#but root will be needed if we want to copy the build webpages

mkdir sites
cd sites

#loop through all the repositories we want to copy and build their webpages
#the file lessons contains a list of every lesson we'll build
for repo in $(cat ../lessons.jekyll) ; do
    repo_name=$(basename $repo)
    git clone $repo
    cd $repo_name
    #we aren't using jekyll from Gem and the Gemfile being present breaks the system version of jekyll
    rm Gemfile
    jekyll build
    cd ..
done


for repo in $(cat ../lessons.rmarkdown) ; do
    repo_name=$(basename $repo)
    git clone $repo
    cd $repo_name
    sudo make
    cd ..
done

cd ..
