#!/usr/bin/env python
# vim: set sts=4 expandtab:

"""
colspec.py - set colspec in XML to correct values

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
                colwidth = (40,60)
            elif tgroup_cols == 3:
                colwidth = (30,30,40)
            elif tgroup_cols == 4:
                colwidth = (20,12,6,62)
            elif tgroup_cols == 5:
                colwidth = (20,12,6,12,50)
            elif tgroup_cols == 6:
                colwidth = (20,12,6,12,12,38)
            elif tgroup_cols == 7:
                colwidth = (20,12,6,12,12,12,26)
            # List of exceptions
            if table_id == "thenumericmodefoinchmodbcommands":
                colwidth = (20,80)
            elif table_id == "listofnotablesysupsforfileaccess":
                colwidth = (20,80)
            elif table_id == "listofnotablesysommandexecutions":
                colwidth = (20,80)
            elif table_id == "listoftypesoftimestamps":
                colwidth = (20,80)
            elif table_id == "listofnotablesysupsforfileaccess":
                colwidth = (20,80)
            elif table_id == "listofnotablepinpinningtechnique":
                colwidth = (20,80)
            elif table_id == "listofkeyboardreigurationmethods":
                colwidth = (20,80)
            elif table_id == "listoffilesystemalusagescenarios":
                colwidth = (20,80)
            elif table_id == "thereplacementexpression":
                colwidth = (30,70)
            elif table_id == "thekeybindingsofmc":
                colwidth = (30,70)
            elif table_id == "listofkeywebsiteaspecificpackage":
                colwidth = (30,70)
            elif table_id == "listofspecialdevicefiles":
                colwidth = (30,20,50)
            elif table_id == "listofdebianarchivearea":
                colwidth = (20,20,60)
            elif table_id == "listofviewsforaptitude":
                colwidth = (20,20,60)
            elif table_id == "listofrunlevelsationoftheirusage":
                colwidth = (20,20,60)
            elif table_id == "listofsshauthenttocolsandmethods":
                colwidth = (20,40,40)
            elif table_id == "listofterminologornetworkdevices":
                colwidth = (20,20,25,35)
            elif table_id == "tableofkeywordsundicatefonttypes":
                colwidth = (25,25,25,25)
            elif table_id == "listofinsecureanservicesandports":
                colwidth = (25,25,25,25)
            elif table_id == "therelationshipbsuiteandcodename":
                colwidth = (25,25,25,25)
            elif table_id == "theumaskvalueexamples":
                colwidth = (20,25,25,30)
            elif table_id == "dimportantconfigilesforpam_unixi":
                colwidth = (20,20,10,10,40)
            elif table_id == "listoftoolstogeneratepassword":
                colwidth = (15,15,10,15,45)
            elif table_id == "listofnetworkaddressranges":
                colwidth = (10,40,30,10,10)


        if re.match('.*table pgwide="', line):
            print re.sub(r'(.*table pgwide=)"0"(.*)',r'\1"1"\2',line)
        elif re.match('.*colspec colwidth="', line):
            x = str(colwidth[cols])
            cols += 1
            print re.sub(r'(.*colspec colwidth=").*',r'\1',line)+str(x)+"*"+re.sub(r'.*colspec colwidth="[^"]*(".*)',r'\1',line)
        else:
            print line

