#!/bin/bash
#compensate for the time it takes to ssh in and actually set the clock
#on my laptop/pi this is taking about 4 seconds
echo $[`date +%s` + 4] > timestamp
scp timestamp pi@192.168.1.1:
ssh pi@192.168.1.1 'sudo date +%s -s @`cat timestamp`'
