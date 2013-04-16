#!/usr/bin/python

# This script is used to move the Glasnost raw log files to the 
# rsync directory from which the logs are collected and archived.

# Attention: Files get renamed to the M-Lab format

import socket
import time
import shutil
import glob
import os
import sys
from datetime import datetime,timedelta


raw_log_path = "/home/mpisws_broadband/logs"
last_collection_date = "/home/mpisws_broadband/last_collection_date"
mlab_log_path = "/var/spool/mpisws_broadband"

SERVER_HOSTNAME = socket.gethostname()

def convert_rawlogfn_to_mlablogfn(rawlogfn):
    """
        NOTE: raw log filenames look like:
        raw_log_path/glasnost_88.147.43.208_88.147.43.208_1214660901.dump.gz
    """
    l = rawlogfn.split("_")
    ts = l[-1];
    ip = l[1];
    hname = "_".join(l[2:-1])
     
    suffix = ""
    if ".dump.gz" == ts[-len(".dump.gz"):]:
        ts = ts[:-len(".dump.gz")]
        suffix = "dump.gz"
    elif ".log" == ts[-4:]:
        ts = ts[:-len(".log")]
        suffix = "log"
    else:
        print "unknown suffix: %s" % ts
        return None

    ts = int(ts)
  
    # NOTE: very recent tests may not be complete so don't copy
    if ts >= time.time()-(60*60):
        return None
  
    # NOTE: creating path like:
    # mlab_log_path/YEAR/MM/DD/hostname/YYYY-MM-DDTHH:MM:SS_11.11.11.11_hostname.suffix"
    gmts              = time.gmtime(ts)
    iso_date          = time.strftime("%Y-%m-%dT%H:%M:%S", gmts)
    dir_with_datehost = time.strftime("%Y/%m/%d/"+SERVER_HOSTNAME, gmts) 
    new_filename      = iso_date+"_"+ip+"_"+hname+"."+suffix
    new_basedir       = mlab_log_path+"/"+dir_with_datehost
    mlablogfn         = new_basedir+"/"+new_filename

    return mlablogfn

def copy_rawlogs():
    # Change working directory to raw_log_path
    os.chdir(raw_log_path)

    # Then process all raw log files
    for rawlog_name in glob.glob("*"):
        if "glasnost_" not in rawlog_name:
            continue

        # Change rawlog path to mlablog path
        mlablog_name = convert_rawlogfn_to_mlablogfn(rawlog_name)
        if mlablog_name is None:
            continue
            
        # Make directories if missing
        if not os.path.exists(os.path.dirname(mlablog_name)):
            os.makedirs(os.path.dirname(mlablog_name))

        # if mlablog file already exists, verify that the size is the same
        s_orig = os.stat(rawlog_name)
        if os.path.exists(mlablog_name):
            s_new = os.stat(mlablog_name)
            if (s_new.st_size == s_orig.st_size):
                # then assume we've already copied this file.
                # this avoids resetting the mtime
                continue

        # Copy the file
        shutil.copy(rawlog_name, mlablog_name)
        # Reset modify/access times for mlablog file to help with prune-scripts
        os.utime(mlablog_name, (s_orig.st_atime,s_orig.st_mtime))

if __name__ == "__main__":
    copy_rawlogs()
        
