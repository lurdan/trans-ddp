#!/bin/bash
#
# Script to check the languages present in the documentation to see
# if they validate ok
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
# Sanity checks:
if [ ! -e "Makefile" ] ; then
    echo "ERROR: File Makefile does not exist, this is required to extract information"
    exit 1
fi

# Extract the information we need
langs=`grep "^LANGUAGES " Makefile | sed 's/.*=//'`

# Check if the information we have is OK to proceeded
if [ -z "$langs" ]; then
    echo "ERROR: Cannot find the list of languages this document is built for."
    exit 1
fi

error_lang=""
ok_lang=""
for lang in $langs;  do
    make validate LANGUAGES=$lang 2>/dev/null >/dev/null
    if [ $? -ne 0 ];  then
        error_lang="$lang $error_lang"
    else
        ok_lang="$lang $ok_lang"
    fi
done

echo "Tested languages list: $langs"
echo -e "\tLanguages WITH ERRORS: $error_lang"
echo -e "\tLanguages without errors: $ok_lang"

exit 0
