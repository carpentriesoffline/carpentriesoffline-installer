#!/bin/bash

sudo apt install libffi-dev python3-pandas python3-matplotlib r-cran-jupyter

#create a jupyter user
sudo adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Jupyter Lab' \
   --group \
   --disabled-password \
   --home /home/jupyter \
   jupyter

sudo -s -u jupyter pip3 install jupyterlab 

#installing pandas via pip runs out of memory
#pip3 install pandas matplotlib

sudo -s -u jupyter pip3 install --upgrade jupyter-core
jupyter_pass=`sudo -s -u jupyter python3 jupyter_password.py`

sudo mkdir ~jupyter/.jupyter

echo "c.ServerApp.password = u'$jupyter_pass'" | sudo tee -a ~jupyter/.jupyter/jupyter_notebook_config.py

sudo chown -R jupyter:jupyter /home/jupyter
sudo cp jupyter.service /etc/systemd/system/
sudo systemctl enable jupyter
sudo systemctl start jupyter
