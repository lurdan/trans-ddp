#!/usr/bin/env python
# vim: set sts=4 expandtab:
"""
moin2ascii - convert a moinmoin text file to an AsciiDoc

Copyright (C) 2009 Osamu Aoki, GPL
"""

import sys, os, re

VERSION = '1.0.1'

def process_text(line):
#    line = re.sub(r"\\",'@bslash@',line)
    line = re.sub(r"\\",r'\\',line)
    line = re.sub(r"\~",r'\~',line)
    line = re.sub(r"\^",r'\^',line)
    line = re.sub(r"\*",r'\*',line)
    line = re.sub(r'{{{',r'`',line)
    line = re.sub(r'}}}',r'`',line)
    line = re.sub(r"'''",r'**',line)
    line = re.sub(r"''",r'__',line)
    line = re.sub(r"'",r"\'",line)
#    line = re.sub(r"\&",r'&amp;',line)
#    line = re.sub(r"\<",r'&gt;',line)
#    line = re.sub(r"\>",r'&lt;',line)
    line = re.sub(r'\[\[([^|]+)\|([^]]+)\]\]',r'\1[\2]',line)
    line = re.sub(r'\[\[([^|]+)\\]\]',r'\1[\1]',line)
    return line

def process_indent(line):
    if re.match(r'^=',line):
        line = re.sub(r'^=(.*) =+',r'==\1',line)
    elif line[0:2] == ' *':
        line = "-" + line[2:]
    elif line[0:3] == '  *':
        line = "--" + line[3:]
    elif re.match(r'^ +[0-9]\.',line):
        line = line[1:]
    elif line[0:3] == '/!\\':
        line = "WARNING:" + line[3:]
    elif line[0:3] == r'<!>':
        line = "CAUTION:" + line[3:]
    elif line[0:3] == r'{i}':
        line = "TIP:" + line[3:]
    elif line[0:3] == r'(!)':
        line = "NOTE:" + line[3:]
    line =  process_text(line)
    if line[0:2] == '--':
        line = " *" + line[2:]
    return line

def process_table(line):
    line = re.sub(r'\|\| *([^ ].*[^ ]) *\|\|',r'\1',line)
    items = re.split(r' *\|\| *',line,8)
    i = 0
    for item in items:
        items[i] = process_text(item)
        i = i + 1
    return items

if __name__ == '__main__':

    m2a_mode = 'NORMAL'
    m2a_table_mode = 0
    m2a_table_popcon = 0

    for line in sys.stdin.readlines():
        line=line[0:-1]
        if line == r"{{{#!plain":
            line = "{{{"
        if m2a_mode != 'SCREEN':
            if line[0:2] == '##':
                print "//" + line[2:]
            elif line[0:2] == '||':
                if m2a_mode == 'NORMAL':
                    table_items = [[]]
                    table_rows = 0
                    table_cols = 0
                    table_cols_width = [0]
                    table_item =  process_table(line)
                    table_title = table_item[0]
                    if len(table_item) != 1:
                        table_pkg = table_item[1] # '', '1', '2'
                    else:
                        table_pkg =0
                    print "\n." + table_title
                    print '[grid="all"]'
                    m2a_mode = 'TABLE_HEAD'
                elif m2a_mode == 'TABLE_HEAD':
                    line = re.sub("'''",'',line)
                    table_items =  [process_table(line)]
                    i = 0
                    m2a_mode = 'TABLE_BODY'
                elif m2a_mode == 'TABLE_BODY':
                    table_item =  process_table(line)
                    if table_pkg == "1":
                        table_item[1] = "@@@popcon1@@@"
                        table_item[2] = "@@@psize1@@@"
                    if table_pkg == "2":
                        table_item[2] = "@@@popcon2@@@"
                        table_item[3] = "@@@psize2@@@"
                    table_items = table_items + [table_item]
                    m2a_mode = 'TABLE_BODY'
            else:
                if m2a_mode == 'TABLE_BODY':
                    # now time to print table
                    table_rows = len(table_items)
                    # find table_cols_width
                    table_cols_width = [0,0,0,0,0,0,0,0,0]
                    for table_item in table_items:
                        i = 0
                        for item in table_item:
                            table_cols_width[i] = max(table_cols_width[i], len(item))
                            i = i + 1
                    # print ruler
                    ruler1 = ""
                    ruler2 = ""
                    i = 0
                    for item in table_cols_width:
                        if item != 0:
                            ruler1 = ruler1 + "`" + ( "-" * item )
                            ruler2 = ruler2 + "-" + ( "-" * item )
                    print ruler1
                    # print table_items
                    j = 0
                    for table_item in table_items:
                        i = 0
                        for item in table_item:
                            print item + " " * (table_cols_width[i] - len(item)),
                            i = i + 1
                        print ""
                        j = j + 1
                        if j == 1:
                            print ruler2
                    print ruler2

                    m2a_mode = 'NORMAL'

                # so this is normal text
                if re.match("^{{{$", line):
                    print ''
                    print '--------------------'
                    m2a_mode = 'SCREEN'
                elif re.match("^ +{{{$", line):
                    print ' +\n--------------------'
                    m2a_mode = 'SCREEN'
                else:
                    if re.match("^ +\*", line):
                        if m2a_mode != 'BULLET':
                            print ""
                            m2a_mode = 'BULLET'
                    else:
                            m2a_mode = 'NORMAL'
                    print process_indent(line)
        else:
            if re.match("^}}}$", line):
                print '--------------------'
                m2a_mode = 'NORMAL'
            else:
                print line
                m2a_mode = 'SCREEN'

""" 
Design: Convert text depending on mode:

MODE = NORMAL
-------------

This is default mode.
This can be base text including buletted/numerated list items.

Processing:
+ Ajust header leads: "s/^=/==/"
+ Adjust buletted/numerated list items.
+ /!\ for "WARNING"
+ <!> for "CAUTION"
+ {i} for "TIP"
+ (!) for "NOTE"
+ content text adjustments and processing

MODE = TABLE
------------

This is table section.
It starts at a line matching "^||"
It ends at a line matching "^[^|][^|]"

Processing:
+ The first line is translated to "TITLE of TABLE".
+ .. If first line contains 2,3,4th argument, they are processed (popcon/size).
     Insert: @@@popcon@@@, @@@size@@@
+ The second line is translated to "HEADER".
+ content text adjustments and processing

MODE = SCREEN
-------------

This is screen section.
It starts at a line matching "^{{{" or "^ {{{"
It ends at a line matching "^}}}"

Processing:
+ verbatim copy as screen ....
+ In case of "^ {{{", continuation of indented list item.

process_line()
------------------
Content text adjustments and processing inclises folowing
+ format converting
 * URL: [[http://...|...]]          --> http://...[...]
 * URL: [[http://...]]              --> http://...
 * The verbatim text are {{{....}}} --> +++....++++
 * ''' for strong *
 * ''  for italics _
 * @{@...@}@ to new style (predefined)
+ reporting to stderr
 * normal text with funny strings
 * @{@...@}@ unprocessed
"""
