#!/bin/bash

#this script seems to work without needing root
#but root will be needed if we want to copy the build webpages

mkdir sites
cd sites

#list of swcarpentry repositories at https://github.com/swcarpentry/swcarpentry
#loop through all the repositories we want to copy and build their webpages
for repo in "https://github.com/swcarpentry/shell-novice" "https://github.com/swcarpentry/git-novice" "https://github.com/swcarpentry/r-novice-inflammation"; do
    repo_name=$(basename $repo)
    git clone $repo
    cd $repo_name
    #we aren't using jekyll from Gem and the Gemfile being present breaks the system version of jekyll
    rm Gemfile
    jekyll build
    cd ..
done

cd ..
