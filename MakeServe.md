
## Serving training materials with ```make serve```
* ```sudo apt-get update```
* ```sudo apt-get install -y git```
* https://carpentries.github.io/lesson-example/setup.html
* ```sudo apt-get install -y ruby ruby-dev build-essential libxml2-dev```
* ```gem install bundler --user-install```
* ```sudo apt install -y ruby-bundler ```
* Create Gemfile containing the following
```

source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
```
* ```bundle update```
* for localhost testing: ```make serve```
* build for web server: ```bundle exec jekyll build ```
* Pages are now served from Pi server running nginx. Access with http://<ip-address>/git-novice/
