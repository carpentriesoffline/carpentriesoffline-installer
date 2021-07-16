#!/bin/bash

#this script seems to work without needing root
#but root will be needed if we want to copy the build webpages

#initial setup for gem
gem install bundler --user-install
bundle update

#this seems to work but complains we haven't stuck some stuff in the path, should we modify the path here?

mkdir sites
cd sites

#list of swcarpentry repositories at https://github.com/swcarpentry/swcarpentry
#loop through all the repositories we want to copy and build their webpages
for repo in "https://github.com/swcarpentry/shell-novice" "https://github.com/swcarpentry/git-novice" "https://github.com/swcarpentry/r-novice-inflammation"; do
    repo_name=$(basename $repo)
    git clone $repo
    cd $repo_name
    echo "source 'https://rubygems.org'" > Gemfile
    echo "gem 'github-pages', group: :jekyll_plugins" >> Gemfile
    bundle exec jekyll build
    cd ..
done

cd ..
