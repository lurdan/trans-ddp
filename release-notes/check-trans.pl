#!/usr/bin/perl -w
#
# Check translation status
#
# This program is copyright 2004 by Javier Fernandez-Sanguino <jfs@debian.org>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# For more information please see
#  http://www.gnu.org/licenses/licenses.html#GPL
#

# Enable for debugging
$DEBUG = 1;

# Program configuration
$ORIGLANG="en";
$LANGS="ca cs da de es fi fr it ja ko nl pt pt_BR pt_PT ro ru sk sv vi zh_CN zh_TW";

$|=1;

$origrelease = find_current_release();

if ( $origrelease == 0 ) {
    print STDERR "Aborting: Could not find what the current release number is!\n";
    exit 1;
} 
print "DEBUG: Release is $origrelease\n" if $DEBUG;

my $minor_orig_release = minor_version($origrelease);
foreach $lang (split(" ",$LANGS)) {
    $langrelease = find_lang_release($lang);
    if ( $langrelease eq "NONE" ) {
        if ( check_po($lang) < 0 ) {
            print "ERROR: [ $lang ] has no SGML nor PO files\n";
        }
    } elsif ( $langrelease ne "EMPTY" ) {
        my $minor_lang_release = minor_version($langrelease);
        if ( $minor_lang_release < $minor_orig_release ) {
            print "$lang OUT OF DATE ($langrelease)\n";
        } elsif ( $minor_lang_release > $minor_orig_release ) {
            print "ERROR: [ $lang ] has a document version higher than current ($langrelease)\n";
        } elsif ( $langrelease eq $origrelease ) {
            print "$lang is up to date\n";
        }
    } else {
        print "ERROR: [ $lang ] could not find document version information in headers\n";
    }

}

exit 0;

sub find_current_release {
    my $release = 0;
    open (RELEASE, "$ORIGLANG/release-notes.en.sgml") or die ("Could not open release notes: $!");
    while ($release == 0 and $line = <RELEASE> ) { 
        chomp $line;
        $release = $1 if ( $line =~ /v ([\d\.]+) / ) ;
    }
    close RELEASE;
    return $release;
}

sub find_lang_release {
    my ($LANG) = @_;
    my $release = "EMPTY";
    # No SGML file or using PO files for translation
    if ( ! -e "$LANG/release-notes.$LANG.sgml" or -e "$LANG/release-notes.$LANG.po" ) {
        return "NONE";
    }
    open (RELEASE, "$LANG/release-notes.$LANG.sgml") or die ("Could not open release notes for $LANG: $!");
    while ($release eq "EMPTY" and $line = <RELEASE> ) { 
        chomp $line;
        # The header should be 
        # <!-- Translation based on English version XXX -->
        # but some do not comply with this
        $release = $1 if ( $line =~ /based on English version ([\d\.]+) / ) ;
        $release = $1 if ( $line =~ /original version: ([\d\.]+) / ) ;
    }
    close RELEASE;
    return $release;
}

sub minor_version {
    my ($version) = @_;
    my $minor = 0;
    $minor = $1 if ($version =~ /(\d+)$/ ) ;
    return $minor;
}

sub check_po {
    my ($LANG) = @_;
    # Return if o PO files for translation available
    return -1 if ( ! -e "$LANG/release-notes.$LANG.po" );
    # or if LANG is not what we expected
    return -1 if ( $LANG !~ /^[\w\_]+$/ ) ;
    # or if we don't have gettext available
    if ( ! -e "/usr/bin/msgfmt") {
        print "WARN: Cannot check PO translation for $LANG, gettext not installed\n";
        return -1;
    }
    $stats = `LC_ALL=C /usr/bin/msgfmt --stat -c -o /dev/null $LANG/release-notes.$LANG.po 2>&1`;
    print "$LANG PO stats: $stats";
    if ( $stats =~ /fuzzy/ or $stats =~ /untranslated/ ) {
            print "\t$LANG PO translation OUT OF DATE\n";
    } else {
            print "\t$LANG PO translation up to date\n";
    }
    return 0;
}
