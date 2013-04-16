#!/bin/bash
#
# A watchdog that checks if the mserver process is still running
# and restarts it if it is gone.

HOME_DIR=/home/mpisws_broadband
# TODO: use slicebase function for local IP address.
ETH=$(/sbin/ifconfig | grep eth0: | cut -d" " -f1 | head -1)

cd $HOME_DIR
TS=`date +%s`
sudo nohup ./gserver -i $ETH -d logs -s scripts/protocols.spec -scriptdir scripts >> logs/gserver-${TS}.log 2>&1 &
