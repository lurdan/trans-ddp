#!/usr/bin/perl
# Find which packages have been changed by tacking a
# look at Packages.gz files (well, should be already
# de-compressed)
#
# Javier Fernandez-Sanguino Peña <jfs_at_debian.org>
# Distributed under the GNU GPL

use Getopt::Std;
# Options:
# -d = debug
# -p release = previous release 'release'
# -r release = current release 'release'
# -m dir     = use mirror directory 'dir'
# -a arch    = use architecture 'arch'
getopts('dp:r:m:a:');

# Debug
my $debug       = $opt_d || 0;
# Releases and path location 
my $prevrelease = $opt_p || "woody";
my $currelease  = $opt_r || "sarge";
my $mirrordir   = $opt_m || "/home/mirrors/debian/debian.org";
my $arch        = $opt_a || "i386";
my @releases = ( $currelease, $prevrelease ) ;
my @components =  ("main", "contrib", "non-free") ;

foreach $releasei (0 .. $#releases ) {
	my $release = $releases[$releasei];
	foreach $componenti (0 .. $#components ) {
		my $component = $components[$componenti];
		$release{$release}{$component}=$mirrordir."/dists/".$release."/".$component."/binary-".$arch."/Packages";
		die "Cannot read  $release{$release}{$component}" if  ! -r  $release{$release}{$component};
		print "Found component '$component' for release '$release' at $release{$release}{$component}\n" if $debug;
	}
}


# Global (ugly)
#global %packages;
$totalnumbers{$currelease}=0;
$totalnumbers{$prevrelease}=0;

# For each release read all the files and make a *Big* hash

foreach $file ( keys(%{$release{$prevrelease}}) ) {
	read_file($prevrelease,$release{$prevrelease}{$file});
}
foreach $file ( keys(%{$release{$currelease}}) ) {
	read_file($currelease,$release{$currelease}{$file});
}

# Once this is done compare all the packages found and their description
# or version and if they have changed say so. 
#If the package does not exist add: REMOVED

foreach $package ( keys(%{$packages{$prevrelease}}) ) {

	if ( defined $packages{$currelease}{$package} ) {
		check_packages($packages{$currelease}{$package},$packages{$prevrelease}{$package}) if  $packages{$currelease}{$package} ne $packages{$prevrelease}{$package};
	} else {
		print "$package -> REMOVED\n";
	}
} # of the foreach

# The other way around (currelease vs prevrelease)

foreach $package ( keys(%{$packages{$currelease}}) ) {

	if ( ! defined $packages{$prevrelease}{$package} ) {
		print "$package -> ADDED\n";
	}
} # of the foreach

# Final numbers:
foreach $release ( keys(%totalnumbers) ) {
	print "Total packages for ".$release.": ".$totalnumbers{$release}."\n";
} # of the foreach


exit 0;

sub check_packages {
# Checks two packages text to see if they are the same
# and determines what has changed (version, description...)
# Description changes should imply version change but not
# the other way around. Since description changes refer
# to more important changes.
	my($curpackage,$prevpackage)=@_;
	$origversion=retrieve_version($prevpackage);
	$newversion=retrieve_version($curpackage);
	print "Comparing $origversion and $newversion\n" if $debug;
# TODO: could use dpkg --compare-versions to determine
# if it's an upgrade or a downgrade here....
	if ( $origversion ne $newversion ) {
		$origtext=retrieve_text($prevpackage);
		$newtext=retrieve_text($curpackage);
		print "Comparing $origtext and $newtext\n" if $debug;
		if ( $origtext ne $newtext ) {
			print "$package -> DESCRIPTION CHANGED ($origversion -> $newversion)\n"; 
		} else {
			print "$package -> CHANGED ($origversion -> $newversion)\n"; 
		}  # of if origtext newtext
	} else  {
		print "$package -> CHANGED (NO VERSION UPDATE)\n";
	} # of if origversion newversion
	return 0;
}

sub retrieve_version {
# Retrieves the version info from the text
	my ($text)=@_;
	print "Extracting version from $text\n" if $debug;
	my $retversion="unknown";
	if ( $text =~ /^.*{(.*?)}$/ ){
		$retversion=$1;
	} 
	return $retversion;
}
sub retrieve_text {
# Retrieves the description info from the text
	my ($origtext)=@_;
	print "Extracting text from $origtext\n" if $debug;
	my $rettext="";
	if ( $origtext =~ /^(.*){.*?}$/ ){
		$rettext=$1;
	} 
	return $rettext;
}

sub read_file {
# Read in a Package file and retrieves packages for a given release
	my ($release,$file)=@_;

	open (FILE,"$file") || die ("Cannot open $file: $!");
	print "Reading $file\n" if $debug;
# Finite-state machine
# 0 - no package
# 1 - package name read
# 2 - version read
# 3 - package description read
	my $state=0;
	my $packagename="";
	my $description="";
	while (<FILE>) {
		chomp;
		if ( $state == 3 && /^$/ ){
			$packages{$release}{$packagename}=$description."{".$version."}";
			print "Found $packagename: $description ($version)\n" if $debug;
			$totalnumbers{$release}++;
			$state=0;
		}
		if ( /^$/ && $state > 0  ){
# Package that does not comply the state-machine
			$state=0;
		}
		if ( $state == 2 && /^Description: (.*)$/ ){
			$description=$1;
			$state=3;
		}
		if ( $state == 1 && /^Version: (.*)$/ ){
			$version=$1;
			$state=2;
		}
		if ( $state == 0 && /^Package: (.*)$/ ){
			$packagename=$1;
			$state=1;
		}
	}
	close FILE;

}
