#!/bin/bash
#
# Script to test the build of the documentation generated
#
# This program is copyright 2011 by Javier Fernandez-Sanguino <jfs@debian.org>
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

name=release-notes  # Name of the document
formats="txt html pdf" # Formats the document is build to
# Directory to look for the published content
publishdir="publish" 
if [ -n "$PUBLISHDIR" ] ; then
    publishdir="$PUBLISHDIR"
fi

# Sanity checks:
if [ ! -e "$name.ent" ] ; then
    echo "ERROR: File $name.ent does not exist, this is required to extract information"
    exit 1
fi
if [ ! -e "Makefile" ] ; then
    echo "ERROR: File Makefile does not exist, this is required to extract information"
    exit 1
fi

# Extract the information
arches=`grep '<phrase arch=' $name.ent | sed 's/.* arch=.\([a-z0-9-]*\).*/\1/' | sort -u`
langs=`grep "^LANGUAGES " Makefile | sed 's/.*=//'`

# Check if the information we have is OK to proceeded
if [ -z "$arches" ]; then
    echo "ERROR: Cannot find a proper list of the architectures this document is built for."
    exit 1
fi
if [ -z "$langs" ]; then
    echo "ERROR: Cannot find the list of languages this document is built for."
    exit 1
fi

for lang in $langs;  do
    count=0
    okcount=0
    failcount=0
    pokcount=0
    pfailcount=0
    echo "Checking build for language '$lang'"
    for arch in $arches;  do
        for format in $formats;  do
            count=$(($count+1))
            # Check the builddir
            if [ -e "${lang}/${name}.${arch}.${format}" ] ; then
                okcount=$(($okcount+1))
# Check the publishdir
                if [ -d "$publishdir" ] ; then
                    if  [ "$format" = "html" ] ; then
                        file="${publishdir}/${arch}/${name}/index.${lang}.${format}" 
                    else
                        file="${publishdir}/${arch}/${name}.${lang}.${format}" 
                    fi
                    if [ -e "$file" ] ; then
                        pokcount=$(($pokcount+1))
                    else
                        pfailcount=$(($pfailcount+1))
                        echo -e "\tERROR: Missing $format for $arch in PUBLISHDIR '$publishdir' (language: $lang). Tried looking for '$file'."
                    fi
                fi
            else
                failcount=$(($failcount+1))
                echo -e "\tERROR: Missing build document in $format format for $arch (language: $lang)"
            fi
        done
    done
    echo "TOTAL: Build totals for for language '$lang'. BUILD OK: $okcount BUILD FAIL: $failcount of $count documents"
    if [ -d "$publishdir" ] ; then
        echo "TOTAL: Publishing totals for language '$lang'. PUBLISH OK: $pokcount PUBLISH FAIL: $pfailcount of $okcount built"
    fi
done

exit 0
