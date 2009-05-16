#!/usr/bin/env python
# vim: set sts=4 expandtab:
"""
po4a-trim

Copyright (C) 2009 Osamu Aoki, GPL

Design: Trim po file depending on mode

Add blank line at the end of po
"""

import sys, os, re

VERSION = '1.0.1'

if __name__ == '__main__':

    po4a_mode = 'NORMAL'
    po4a_mode_old = 'NORMAL'
    # 'NORMAL' for header/comment which is dropped.
    # 'MSGID' for English original part
    # 'MSGSTR' for translated text part
    msgid = ''
    msgstr = ''

    for line in sys.stdin.readlines():
        line=line[0:-1]
        if re.match("^[ \t]*$", line):
            # blank line
            line = ""
            if po4a_mode != 'NORMAL':
                po4a_mode_old = po4a_mode
            po4a_mode = 'NORMAL'
        elif re.match("^#", line):
            # comment line
            line = ""
            if po4a_mode != 'NORMAL':
                po4a_mode_old = po4a_mode
            po4a_mode = 'NORMAL'
        elif re.match("^msgid", line):
            line = re.sub(r"^msgid +\"(.*)\" *$",r'\1',line)
            if po4a_mode != 'MSGID':
                po4a_mode_old = po4a_mode
            else:
                print "error @ " + line
            po4a_mode = 'MSGID'
        elif re.match("^msgstr", line):
            line = re.sub(r"^msgstr +\"(.*)\" *$",r'\1',line)
            if po4a_mode != 'MSGSTR':
                po4a_mode_old = po4a_mode
            else:
                print "error @ " + line
            po4a_mode = 'MSGSTR'
        elif re.match("^\"", line):
            line = re.sub(r"^\"(.*)\" *$",r'\1',line)
            # po4a_mode_old and po4a_mode are the same
        #
        if po4a_mode == 'MSGID':
            msgid = msgid + line
        if po4a_mode == 'MSGSTR':
            msgstr = msgstr + line
        if po4a_mode == 'NORMAL' and po4a_mode_old == 'MSGSTR':
            if msgid != "" and  msgstr != "":
                print "msgid \"" + msgid + "\""
                print "msgstr \"" + msgstr + "\"\n"
            #
            msgid = ''
            msgstr = ''
            po4a_mode_old = 'NORMAL'


