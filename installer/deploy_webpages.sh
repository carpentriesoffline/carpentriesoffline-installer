#!/bin/bash

mkdir -p /var/www/html/lessons

# Create index pages:
echo << EOF > /var/www/html/lessons/index.html
<html>

<head>
	<title>Welcome to Carpentries Offline</title>
	<!--<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Oswald">
	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Domine">
	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Playfair+Display">-->
	<link rel="stylesheet" type="text/css" href="/assets/css/styles.css">
</head>

<body>
	<div class="logo"><img src="/assets/images/OFFLINE.svg"></div>

	<div class="titleblock">Welcome to Carpentries Offline</div>

  <h2 id='dc'>Data Carpentry</h2>
  <ul>
  <!-- dc-lesson -->

  </ul>

  <h2 id='swc'>Software Carpentry</h2>
  <ul>
  <!-- swc-lesson -->


  </ul>

</body>
</html>
EOF



for site in `find sites -maxdepth 1 -type d` ; do
    if [ $site = "sites" ] ; then
	      continue
    fi
    lesson_dir=$(basename ${site})
    cp -r $site/_site /var/www/html/lessons/${lesson_dir}
    if [[ "${lesson_dir}" == *"datacarpentry.org"* ]]; then
        sed "/dc-lesson/ i '<li><a href=\'${lesson_dir}/index.html\'>${lesson_dir//-/ }</a></li>'"
    else
        sed "/swc-lesson/ i '<li><a href=\'${lesson_dir}/index.html\'>${lesson_dir//-/ }</a></li>'"
    fi
done
