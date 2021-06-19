# Apache Webserver

## Starting with a Raspberry Pi with an installed version of Raspbian OS Lite:
* Assuming the hostname of the pi is ```tim```
* Install Apache:
    * ```sudo apt-get install -y apache2```
* The default directory where web pages are served from is /var/www/html
* The following instructions are for setting up three virtual hosts that will serve pages on port 80 for the following three domain names:
    * ```tim.local```
	 * ```tim.web```
	 * ```tim.cran```
* Apache2 needs the configuration file /etc/apache2/apache2.conf
* For each of the virtual hosts we need a configuration file in /etc/apache2/sites-available/. See files in [ApacheConfFiles](https://github.com/CarpenPi/WebServer/tree/main/ApacheConfFiles)
* After creating the virtual host configuration files, symbolic links to the files need to be created in /etc/apache2/sites-enabled. This can be done with the commands:
    * ```sudo a2ensite tim.local```
    * ```sudo a2ensite tim.web```
    * ```sudo a2ensite tim.cran```
* Alternatively the symbolic links can be created manually using ```ln```
* Use ```sudo apachectl configtest``` to verify the correctness of the config files
* Use ```sudo systemctl restart apache2``` to restart the server with the new configuration files
