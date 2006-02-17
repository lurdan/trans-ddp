#!/usr/bin/perl -w
# 
# "Count" languages for which a translation is available in the DDP
# useful for presentations :-)
#
# (c) 2006 Javier Fernandez-Sanguino, jfs@debian.org
# 
# This code is distributed under the GNU GPL version 2
# 
open (LIST,'find . -name "*.??.sgml" -o -name "*.??_??.sgml" |') or die ("Cannot execute: $?");
while (<LIST>) {
	chomp;
	$langs{$1} ++ if /.*?\.(\w{2}|\w{2}_\w{2})\.sgml/;
}
close LIST;
open (LIST,'find . -type d -name "??" -o -name "??_??" |') or die ("Cannot execute: $?");
while (<LIST>) {
	chomp;
	$langs{$1} ++ if /^\.\/(\w+)\/(\w{2}|\w{2}_\w{2})$/;
}
close LIST;


foreach $lang (sort { $langs{$b} <=> $langs{$a} } keys %langs) {
	print $lang." ";
	print "+"x$langs{$lang};
	print "\n";
}

