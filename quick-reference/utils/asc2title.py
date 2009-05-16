#!/usr/bin/env python
# vim: set sts=4 expandtab:
"""
asc2title - convert an AsciiDoc titles

Copyright (C) 2009 Osamu Aoki, GPL
"""

import sys, os, re, string

VERSION = '1.0.1'

if __name__ == '__main__':

    for line in sys.stdin.readlines():
        line=line[0:-1]
        if line[0:1] == "=":
            line = re.sub(r'^=+ +([^ ].*[^ ]) *=*',r'\1',line)
            print line
#    entityname=pop-$(echo $package |tr "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" "abcdefghijklmnopqrstuvwxyzabcdefghij"| \
#               tr -d " \!#\$%()=\-~^|\\/+*,.?;:@\`\"'&><")
# 32 char


