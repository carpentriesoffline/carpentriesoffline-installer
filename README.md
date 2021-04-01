# WebServer


## Serving training materials with ```make serve```
* Download Raspbian OS Lite: https://www.raspberrypi.org/software/operating-systems/
* Write image to SD card using rpi-imager:
* ```sudo apt-get update```
* ```sudo apt-get install -y git```
* https://carpentries.github.io/lesson-example/setup.html
* ```sudo apt-get install -y ruby ruby-dev build-essential libxml2-dev```
* ```gem install -y bundler --user-install```
* ```sudo apt install ruby-bundler ```
* ```bundle update```
* for localhost testting: ```make serve```
* build for web server: ```bundle exec jekyll build ```
* Pages are now served from Pi server running nginx. Access with http://<ip-address>/git-novice/


## Nginx
* Download Raspbian OS Lite: https://www.raspberrypi.org/software/operating-systems/
* Write image to SD card using rpi-imager:
* ```sudo apt-get update```
* ```sudo apt-get -y install nginx```
* ```mkdir /var/www/html/git-novice```
* ```cp  -f <path-to-repository>/_setup/* /var/www/html/git-novice/.```
