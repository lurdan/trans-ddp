#!/usr/bin/perl

use XML::DOM;
use strict;

$::valuetokeep = shift (@ARGV);
my $filename = shift (@ARGV);

$::debug = 1;

if ((! $filename) or (! $::valuetokeep)) {
    die "Usage: $0 valuetokeep filename\n";
}

my $parser = new XML::DOM::Parser;
my $doc = $parser->parsefile ($filename);
my $root = $doc->getDocumentElement;
my $attributes;

&scanChildren ($root->getChildNodes);
$doc->printToFileHandle (\*STDOUT);


sub scanChildren {
    my (@children) = @_;
    my ($child);
  child:
    foreach $child (@children) {
	if ($child->getNodeType == ELEMENT_NODE) {
	    my ($found, $nocondition);
	    my $versionequal = $child->getAttribute ("debianversionequal");
	    my $versionmin = $child->getAttribute ("debianversionmin");
	    my $versionmax = $child->getAttribute ("debianversionmax");
	    if ($versionequal) {
		if ($versionmin or $versionmax) {
		    die "Cannot have Version-min or Version-max with Version-equal";
		}
		if ($versionequal == $::valuetokeep) {
		    $found = 1;
		}
	    }
	    elsif ($versionmin) {
		if ($versionmin <= $::valuetokeep) {
		    if ($versionmax and ($versionmax >= $::valuetokeep)) {
			$found = 1;
		    }
		    elsif (! $versionmax) {
			$found = 1;
		    }
		}
	    }    
	    elsif ($versionmax) {
		if ($versionmax >= $::valuetokeep) {
		    $found = 1;
		}
	    }
	    else {
		# No attribute, no condition
		$nocondition = 1;
		$found = 1;
	    }
	    if (! $found) {
		$child->getParentNode->removeChild ($child);
	    }
	    &scanChildren ($child->getChildNodes);
	}
    }
}
