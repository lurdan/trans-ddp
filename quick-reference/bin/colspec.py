#!/usr/bin/env python
# vim: set sts=4 expandtab:

"""
colspec.py - set colspec in XML to correct values

Design: Convert text depending on % of width:

 2 cols = 30,70
 3 cols = 30,30,40
 4 cols = 20,20,20,40
 5 cols = 15,15,15,15,40
 6 cols = 10,10,10,10,10,50
 7 cols = 10,10,10,10,10,10,40

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
                colwidth = (30,70)
            elif tgroup_cols == 3:
                colwidth = (30,30,40)
            elif tgroup_cols == 4:
                colwidth = (20,20,20,40)
            elif tgroup_cols == 5:
                colwidth = (10,10,10,10,60)
            elif tgroup_cols == 6:
                colwidth = (10,10,10,10,10,50)
            elif tgroup_cols == 7:
                colwidth = (10,10,10,10,10,10,40)
            if table_id == "listofinsecureanservicesandports":
                colwidth = (25,25,25,25)

        if re.match('.*table pgwide="', line):
            print re.sub(r'(.*table pgwide=)"0"(.*)',r'\1"1"\2',line)
        elif re.match('.*colspec colwidth="', line):
            x = str(colwidth[cols])+"%"
            cols += 1
            print re.sub(r'(.*colspec colwidth=").*',r'\1',line)+str(x)+"*"+re.sub(r'.*colspec colwidth="[^"]*(".*)',r'\1',line)
        else:
            print line

