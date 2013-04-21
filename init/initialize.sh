#!/bin/bash

# NOTE: exit on error
set -e
# install libraries linked to gserver
yum install -y libpcap libcurl libmicrohttpd

cp -f /home/mpisws_broadband/datapull_rename.py /etc/cron.hourly
