#!/bin/bash
#
# Script to find dummy packages relevant to a new release 
# (i.e. there was previously a real package but in this release
# there is a dummy package that can be removed after upgrade)
#
# Useful to fill in the 'Appendix' section of the Release Notes
# (but needs REVIEW)
#
# (c) Javier Fernandez-Sanguino, 2004.
#
# Note:
# - The fact that there is no standard on how to setup the name and 
#   description of transitional-packages make this script give a number
#   of false positives and false negatives (that need to be found out
#   by hand). The script could also try searching for 
#   'ease|smooth upgrades' or 'transitional' or 'obsolete' or 
#   'remove after upgrade' too
# - (Known false positive)
#   Does not work for python packages since many say that they are dummy
#   but are not, in fact, transitional

# Location of the Packages file of the previous release
# Please CONFIGURE this:
MIRROR_DIR=/home/mirrors/debian/
PREV_RELEASE=woody
CUR_RELEASE=sarge

# This probably needs no changes:
PREV_RELEASE_PACK="${MIRROR_DIR}/debian.org/dists/${PREV_RELEASE}/main/binary-i386/Packages"
CUR_RELEASE_PACK="${MIRROR_DIR}/debian.org/dists/${CUR_RELEASE}/main/binary-i386/Packages"

# Find all packages that are "dummy"
grep-available -n -s Package -F Description "dummy" $CUR_RELEASE_PACK |
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

