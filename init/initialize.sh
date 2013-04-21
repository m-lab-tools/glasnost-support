#!/bin/bash

source /etc/mlab/slice-functions
# NOTE: exit on error
set -e
# install libraries linked to gserver
yum install -y libpcap libcurl libmicrohttpd

cp -f $SLICEHOME/datapull_rename.py /etc/cron.hourly
mkdir -p $SLICEHOME/logs
