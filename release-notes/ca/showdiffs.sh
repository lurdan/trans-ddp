#!/bin/bash
#===============================================================================
#
#          FILE:  showdiffs.sh
# 
#         USAGE:  ./showdiffs.sh file1 file2 ... fileN > diff
# 
#   DESCRIPTION: Show the differences with english version using
# 		 the tag "English version:" as reference 
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  subversion
#        AUTHOR:  Miguel Gea Milvaques (xerakko), xerakko@debian.org
#       COMPANY:  Debian.org
#       VERSION:  1.0
#       CREATED:  19/11/08 12:27:05 CET
#      REVISION:  ---
#===============================================================================
if [ $# -eq 0 ]; then
	TOT=*.dbk
else
	TOT=$@
fi
:>diff.ver
for i in $TOT ; do
	err=0
	ENG_SVN_VER=$(sed -n 's/<!-- English version: \(.*\) -->/\1/p' $i)
	svn  info -r$ENG_SVN_VER ../en/$i &>/dev/null || err=1
	ACT_SVN_VER=$(svn info ../en/$i |grep Revision|cut -d' ' -f2)
	if [ $err -eq 0 ]; then
		echo -n "Showing diffs for $i... (ver: $ENG_SVN_VER:$ACT_SVN_VER)" >&2
		echo "$i:$ACT_SVN_VER" >> diff.ver
		cd ../en
		svn diff -r$ENG_SVN_VER $i |tee /tmp/diff
		ADDED=$(cat /tmp/diff|grep '^+' |wc -l)
		REMOV=$(cat /tmp/diff|grep '^-' |wc -l)
		echo ". Added: $ADDED Removed: $REMOV" >&2
		cd - >/dev/null
	else
		echo "ERROR: $i has not a correct English version: $ENG_SVN_VER" >&2
	fi
done
