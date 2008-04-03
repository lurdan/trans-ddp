#!/bin/bash

mirror="/home/mirrors/debian/debian.org/"
ARCH="i386"
RELEASE="etch"
mainP="$mirror/dists/$RELEASE/main/binary-$ARCH/Packages.gz"
contribP="$mirror/dists/$RELEASE/contrib/binary-$ARCH/Packages.gz"
nonfreeP="$mirror/dists/$RELEASE/non-free/binary-$ARCH/Packages.gz"

main=`gzip -d -c $mainP | grep-dctrl -s Package -F section -r ".*" - |wc -l`
nonfree=`gzip -d -c $nonfreeP | grep-dctrl -s Package -F section -r "non-free/.*" - |wc -l`
contrib=`gzip -d -c $contribP | grep-dctrl -s Package -F section -r "contrib/.*" - |wc -l`
       
echo "Total count for $RELEASE"
echo "Main packages:           $main"
echo "Non-free packages:       $nonfree"
echo "Contrib packages:        $contrib"
contribnonfree=$(($nonfree+$contrib))
total=$(($main+$contrib))
echo "Non-freee + Contrib:     $contribnonfree"
echo "Total packages:          $total"

exit 0
