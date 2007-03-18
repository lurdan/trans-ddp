#!/bin/bash
#
# Script to find dummy packages relevant to a new release 
# (i.e. there was previously a real package but in this release
# there is a dummy package that can be removed after upgrade)
# 
# The script looks for 'dummy' in package descriptions and counts
# dependancies to determine if a package is actually dummy
# (usually dummy packages depend on 1 package, but that is not
# always the case)
#
# The script also searches for 'ease|smooth upgrades',
# 'transitional'.
# 
# It does not currently look for 'obsolete' or 
# 'remove after upgrade', but might be easily added in there.
#
# Requirement: You need a local Debian mirror for it to work
# (you should adjust the mirror location there) although only
# the Packages list of the releases are used.
#
# Useful to fill in the 'Appendix' section of the Release Notes
# (but needs REVIEW)
#
# See also: http://adn.diwi.org/wiki/index.php/Dummy
# and http://adn.diwi.org/wiki/index.php/DummyPackagesStatus
#
# (c) Javier Fernandez-Sanguino, 2005.
#
# Note:
# - The fact that there is no standard on how to setup the name and 
#   description of transitional-packages make this script give a number
#   of false positives and false negatives (that need to be found out
#   by hand). 
#
# - (Known false positive)
#   Does not work for Python or Ruby packages since many say that they 
#   are dummy but are not, in fact, transitional. They are used to depend
#   on Debian's Python/Ruby version but are not used for upgrades.
#
# - (Known false negatives)
#   It will only search i386 packages, if there are dummy packages in
#   other architectures which are not present in i386 they will not 
#   be shown. To test, change 'ARCH' below

# Location of the Packages file of the previous release
# Please CONFIGURE this:
MIRROR_DIR=/home/mirrors/debian/
#PREV_RELEASE=woody
PREV_RELEASE=sarge
CUR_RELEASE=etch
ARCH=i386

# This probably needs no changes:
PREV_RELEASE_PACK="${MIRROR_DIR}/debian.org/dists/${PREV_RELEASE}/main/binary-${ARCH}/Packages"
CUR_RELEASE_PACK="${MIRROR_DIR}/debian.org/dists/${CUR_RELEASE}/main/binary-${ARCH}/Packages"
if [ ! -e "$CUR_RELEASE_PACK" ]; then
# Try with .gz
    CUR_RELEASE_PACK="${MIRROR_DIR}/debian.org/dists/${CUR_RELEASE}/main/binary-${ARCH}/Packages.gz"
fi
if [ ! -e "$CUR_RELEASE_PACK" ]; then
# Try with .bz2
    CUR_RELEASE_PACK="${MIRROR_DIR}/debian.org/dists/${CUR_RELEASE}/main/binary-${ARCH}/Packages.bz2"
fi
if [ ! -e "$CUR_RELEASE_PACK" ]; then
    echo "ERROR: Could not find any release file for $CUR_RELEASE, looked into ${MIRROR_DIR}/debian.org/dists/${CUR_RELEASE}/main/binary-${ARCH}/"
    exit 1
fi
CUR_RELEASE_FILE=$CUR_RELEASE_PACK
if echo $CUR_RELEASE_PACK | grep -q ".gz"; then
    CUR_RELEASE_FILE=`tempfile` || { echo "Cannot create temporary file!" >&2 ; exit 1 ; }
    gzip -d -c $CUR_RELEASE_PACK >$CUR_RELEASE_FILE
fi
if echo $CUR_RELEASE_PACK | grep -q ".bz2"; then
    CUR_RELEASE_FILE=`tempfile` || { echo "Cannot create temporary file!" >&2 ; exit 1 ; }
    bzip2 -d -c $CUR_RELEASE_PACK >$CUR_RELEASE_FILE
fi

tmpfile=`tempfile` || { echo "Cannot create temporary file!" >&2 ; exit 1 ; }
trap " [ -f \"$tmpfile\" ] && /bin/rm -f -- \"$tmpfile\"" 0 1 2 3 13 15
# Find all packages that are "dummy"
grep-available -n -s Package -F Description "dummy" $CUR_RELEASE_FILE  >$tmpfile
grep-available -n -s Package -F Description "transitional" $CUR_RELEASE_FILE  >>$tmpfile
grep-available -n -s Package -r -F Description "smooth|ease upgrade" $CUR_RELEASE_FILE  >>$tmpfile

[ "$CUR_RELEASE_FILE" != "$CUR_RELEASE_PACK" ] && rm -f "$CUR_RELEASE_FILE"

cat $tmpfile | sort -u |
while read package; do
	declare -i count=0
	description=`grep-available --exact-match -s Description -P $package`
	shortdesc=`grep-available -d --exact-match -s Description -P $package`
	odescription=`grep-available --exact-match -s Description -P $package $PREV_RELEASE_PACK`
	# We don't analyse dummy packages that were not present in the
	# previous release, skip them
	[ -z "$odescription" ] && continue

	# Count the packages it depends on (dummy packages usually depend
	# only on 1)
	IFS=","
	grep-available -n --exact-match -s Depends -P $package |
	while read depended; do
		echo "$package -> $depended"
		count=$((count++))
	done
	unset IFS

	# Count check 
	if [ $count -gt 1 ] ; then
		echo -e "\t[REVIEW Is this a dummy package? Has too many dependencies]"
	fi

	# Further checks
	if [ -n "`echo $shortdesc | grep -i \"dummy package\"`" ] ; then
		if [ -n "`echo $odescription | grep -i \"dummy package\"`" ] ; then
			echo -e "\t[REVIEW: This dummy package was present in the previous release\n\tand was also dummy but it's not exactly the same]"
		elif [ "$odescription" = "$description" ] ; then
			echo -e "\t[NOTE: This dummy package was present in the previous release, REMOVE?]"
		fi
	else
# Packages that don't follow the convention of setting dummy package in the
# short description need to be reviewed
		echo -e "\t[REVIEW: This might not be a dummy package, does not follow usual notation]"
	fi
	# Separate packages with an empty line
	echo
done

exit 0
# EOS
