#!/bin/bash

# import epel release information & yum repo files
sudo yum install -y http://mirror.pnl.gov/epel/6/i386/epel-release-6-8.noarch.rpm
# install libraries linked to gserver
sudo yum install -y libpcap libcurl libmicrohttpd

sudo cp -f /home/mpisws_broadband/datapull_rename.py /etc/cron.hourly
sudo cp -f /home/mpisws_broadband/cleanup.py /etc/cron.daily
