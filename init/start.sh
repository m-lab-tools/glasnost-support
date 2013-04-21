#!/bin/bash
#
# A watchdog that checks if the mserver process is still running
# and restarts it if it is gone.

source /etc/mlab/slice-functions
# TODO: use slicebase function for local IP address.
ETH=$(/sbin/ifconfig | grep eth0: | cut -d" " -f1 | head -1)

TS=`date +%s`
nohup $SLICEHOME/gserver -i $ETH -d $SLICEHOME/logs \
      -s $SLICEHOME/scripts/protocols.spec \
      -scriptdir $SLICEHOME/scripts >> $SLICEHOME/logs/gserver-${TS}.log 2>&1 &
