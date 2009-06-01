#!/usr/bin/env python
# vim: set sts=4 expandtab:

"""
colspec.py - set colspec in XML to correct values

Design: Convert text depending on cols:

   72pt = 1 inch, 7 inch = 504pt

 2 cols = 2,5                    = 144,360 
 3 cols = 1.5,1.5 ,4             = 108,108,288
 4 cols = 1,1,1,4                = 72,72,72,288
 5 cols = 1,1,1,1,3              = 72,72,72,72,216
 6 cols = 1,1,1,1,1,2            = 72,72,72,72,72,144
 7 cols = 1,1,1,1,1,1,1          = 72,72,72,72,72,72,72

Copyright (C) 2009 Osamu Aoki, GPL
"""

import sys, os, re

VERSION = '1.0.1'

if __name__ == '__main__':

    table_id  = ''
    tgroup_cols = 0

    for line in sys.stdin.readlines():
        line=line[0:-1]
        if re.match('.*table id="', line):
            table_id = re.sub(r'.*table id="([^"]*)".*',r'\1',line)
#            print "table id =" + table_id 
        elif re.match('.*<title>', line):
            title = re.sub(r'.*<title>([^<]*)</title>.*',r'\1',line)
#            print "title =" + title
        elif re.match('.*tgroup cols="', line):
            tgroup_cols = int(re.sub(r'.*tgroup cols="([^"]*)".*',r'\1',line))
#            print "tgroup_cols =", tgroup_cols
            cols = 0
            if tgroup_cols == 2:
                colwidth = (144,360)
            elif tgroup_cols == 3:
                colwidth = (108,108,288)
            elif tgroup_cols == 4:
                colwidth = (72,72,72,288)
            elif tgroup_cols == 5:
                colwidth = (72,72,72,72,216)
            elif tgroup_cols == 6:
                colwidth = (72,72,72,72,72,144)
            elif tgroup_cols == 7:
                colwidth = (72,72,72,72,72,72,72)
            if table_id == "bogus":
                colwidth = (72,72,72,72,144,72)

        if re.match('.*colspec colwidth="', line):
            x = str(colwidth[cols])
            cols += 1
            print re.sub(r'(.*colspec colwidth=").*',r'\1',line)+str(x)+re.sub(r'.*colspec colwidth="[^"]*(".*)',r'\1',line)
        else:
            print line

