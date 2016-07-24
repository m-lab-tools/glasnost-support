#!/usr/bin/python

import glob
import os
import time
raw_log_path = "/home/mpisws_broadband/logs"

os.chdir(raw_log_path)
for filename in glob.glob("*"):
    try:
        s = os.stat(filename)
    except:
        continue

    # if file was last modified more than 7 days ago
    if s.st_mtime < (time.time() - (7*24*60*60)):
        # remove it
        os.remove(filename)
