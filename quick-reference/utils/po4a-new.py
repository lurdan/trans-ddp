#!/usr/bin/env python
# vim: set sts=4 expandtab:
"""
po4a-new

Copyright (C) 2009 Osamu Aoki, GPL

Design: fill old msgid with new one in po file

$ po4a-new <orig.po >this.po
$ wdiff -n1 orig.po this.po >new.po

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
        elif re.match("^msgid ", line):
            msgnew = re.sub(r"^msgid +\"(.*)\" *$",r'\1',line)
            if msgold == '':
                print line
            else:
                print "#| msgid \"" + msgnew + "\""
                print line
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


