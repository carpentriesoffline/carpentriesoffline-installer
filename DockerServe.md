TODO: This needs to be expanded

- install docker
- clone lesson
- cd to lesson directory
- make docker-serve

While the docker is running the lesson pages are served on localhost:4000. There will also be a directory ```_site``` which contains the static html pages. When the docker is stop this _site directory will be deleted. While the docker is running the _site directory can be copied to the Raspberry Pi with the webserver, into the directory from where the pages are served.
