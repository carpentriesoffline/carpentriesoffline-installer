#!/bin/bash
apache2ctl start
su git -c "GITEA_WORK_DIR=/var/lib/gitea /usr/local/bin/gitea web --config /etc/gitea/app.ini"

