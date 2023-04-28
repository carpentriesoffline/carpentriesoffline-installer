#!/bin/bash
apache2ctl start
su git -c "GITEA_WORK_DIR=/var/lib/gitea /usr/local/bin/gitea web --config /etc/gitea/app.ini" &
su jupyter -c "/home/jupyter/.local/bin/jupyter-lab --ip=0.0.0.0" &
su openrefine -c "cd /home/openrefine/openrefine-3.7.2 ; ./refine -i 0.0.0.0"
