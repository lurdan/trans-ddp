#!/usr/bin/env python
# vim: set sts=4 expandtab:
"""
po4a-old

Copyright (C) 2009 Osamu Aoki, GPL

Design: reverse msgid of po file to old one

Prerequisite: msgmerge --previous --no-wrap

"""

import sys, os, re

VERSION = '1.0.1'

msgold = ''
if __name__ == '__main__':

    for line in sys.stdin.readlines():
        # drop EOL = NL
        line=line[0:-1]
        if re.match("^[ \t]*$", line):
            # reformat as clean blank line
            print line
        elif re.match("^#. msgid ", line):
            msgold = re.sub(r"^#. msgid +\"(.*)\" *$",r'\1',line)
            print line
        elif re.match("^msgid ", line):
            msgnew = re.sub(r"^msgid +\"(.*)\" *$",r'\1',line)
            if msgold == '':
                print line
            else:
                print "msgid \"" + msgold + "\""
            # reset
            msgold = ''
        elif re.match("^msgstr ", line):
            msgstr = re.sub(r"^msgstr +\"(.*)\" *$",r'\1',line)
            print line
        elif re.match("^#", line):
            # comment line
            print line
        else:
            print line
        #


