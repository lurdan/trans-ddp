#!/bin/bash
#
# Script to extract the package count information for a given Release
#
# (c) 2007, 2013  Javier Fernández-Sanguino <jfs@debian.org>


usage () {
	echo "$0 [mirror-directory] [arquitecture] [release]"
	echo "Prints the Debian package count for a given arquitecture in a given release."
	echo "Defaults to using the i386 arquitecture in the current published release."
}

if [ -n "$1" ] ; then
	mirror=$1
else
	mirror="/home/mirrors/debian/debian.org/"
fi
if [ -n "$2" ] ; then
	ARCH=$2 
else
	ARCH="i386"
fi
[ -n "$3" ] && RELEASE=$3 

if [ ! -e "$mirror" ] ; then 
	echo "ERROR: Cannot find the mirror directory $mirror. Aborting." >&2
	exit 1
fi

# Try to extract the release from the faqstatic.ent file
if [ -z "$RELEASE" ] && [ -r faqstatic.ent ] ; then
	RELEASE=`grep "entity releasename" faqstatic.ent  | sed -e 's/^.*"\(.*\)".*$/\1/'`
fi
if [ -z "$RELEASE" ] ; then
	RELEASE="wheezy"
	echo "WARN: Cannot obtain the release information from 'faqstatic.ent', using $RELEASE instead." >&2
fi


mainP="$mirror/dists/$RELEASE/main/binary-$ARCH/Packages.gz"
contribP="$mirror/dists/$RELEASE/contrib/binary-$ARCH/Packages.gz"
nonfreeP="$mirror/dists/$RELEASE/non-free/binary-$ARCH/Packages.gz"

if [ -e "$mainP" ] ; then
	main=`gzip -d -c $mainP | grep-dctrl -s Package -F section -r ".*" - |wc -l`
else
	echo "ERROR: Cannot find the packages file to extract the information on main: '$mainP'" >&2
	main="UNKNOWN"
fi
if [ -e "$nonfreeP" ] ; then
	nonfree=`gzip -d -c $nonfreeP | grep-dctrl -s Package -F section -r "non-free/.*" - |wc -l`
else
	echo "ERROR: Cannot find the packages file to extract the information on non-free: '$nonfreeP'" >&2
	nonfree="UNKNOWN"
fi
if [ -e "$contribP" ] ; then
	contrib=`gzip -d -c $contribP | grep-dctrl -s Package -F section -r "contrib/.*" - |wc -l`
else
	echo "ERROR: Cannot find the packages file to extract the information on non-free: '$contribP'" >&2
	contrib="UNKNOWN"
fi
       
echo "Total package count for $RELEASE"
echo "Main packages:           $main"
echo "Non-free packages:       $nonfree"
echo "Contrib packages:        $contrib"
contribnonfree=$(($nonfree+$contrib))
total=$(($main+$contrib))
echo "Non-freee + Contrib:     $contribnonfree"
echo "Total packages:          $total"

exit 0
