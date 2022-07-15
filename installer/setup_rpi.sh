#!/bin/bash

#script to configure Raspberry Pi related settings

#are we on a raspberry pi?
if grep -q "Raspberry" /proc/cpuinfo ; then
    echo "Found a Raspberry Pi, doing Raspberry Pi specific config"

    #reduce GPU memory to 8MB since we aren't using a GUI
    if grep -q "gpu_mem" /boot/config.txt ; then
        sudo sed -i 's/gpu_mem=[0-9]*/gpu_mem=8/' /boot/config.txt
    else
        echo "gpu_mem=8" | sudo tee -a /boot/config.txt
    fi

    #turn off bluetooth, we aren't using it
    sudo systemctl disable bluetooth.service
    sudo systemctl disable hciuart.service

    #not enabling this by default, it causes shutdown to hang when not connected
    #it is also rather unreliable when connected and this limits its usefulness
    #enable a USB gadget serial port for debugging on a Pi Zero
    #grep "Zero" /proc/device-tree/model > /dev/null
    #if [ "$?" = "0" ] ; then
    #    echo "Found a Raspberry Pi Zero, enabling USB Serial console"
    #    echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
    #    echo $(cat /boot/cmdline.txt) modules-load=dwc2,g_serial | sudo tee /boot/cmdline.txt
    #    sudo systemctl enable getty@ttyGS0.service
    #else 
    #    echo "Found a $(cat /proc/device-tree/model), not enabling USB serial console"
    #fi
else
    echo "Not a Raspberry Pi, ignoring Raspberry Pi specific config"
fi
