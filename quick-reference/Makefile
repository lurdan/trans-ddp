#######################################################################
# Build debian-reference (v2)
# vim: set ts=8:
#######################################################################
### basic parameters (build condition dependent)                    ALL
#######################################################################
BUILD_MODE	:= xml
# parent dir name of the SVN source checkout location
# make[1]: Entering directory `/org/www.debian.org/ddp-svn/trunk/quick-reference'
PDIR		:= $(notdir $(realpath $(CURDIR)/../..))
ifeq ($(PDIR),ddp-svn)
# Building www.debian.org
# $(PUBLISHDIR) is set to be: /org/www.debian.org/www/doc/manuals
DRPUBLISHDIR	:= $(PUBLISHDIR)/debian-reference
else
# Normally
# if $(PUBLISHDIR) is not set, set it
PUBLISHDIR	:= $(CURDIR)/html
DRPUBLISHDIR	:= $(PUBLISHDIR)
endif

# Please note package build script overides $(PUBLISHDIR)

#######################################################################
### basic parameters (build condition independent)                  ALL
#######################################################################
# base file name excluding file extension
DOCNAME :=	debian-reference
# Directories (no trailing slash)
PXSLT	:=	xslt
PBIN	:=	bin
ADOC	:=	asciidoc
PODOC	:=	po4a
IMAGES	:=	/usr/share/xml/docbook/stylesheet/nwalsh/images
# Program name and option
XP	:=	xsltproc --nonet --novalid --xinclude
#XL	:=	xmllint --nonet --noout --postvalid --xinclude
# The threshold should be 80 if translation is completed.
THRESHOLD:=	0
TRANSLATE:=	po4a-translate  -M utf-8          --format docbook --keep $(THRESHOLD)
GETTEXT	:=	po4a-gettextize -M utf-8 -L utf-8 --format docbook
UPDATEPO:=	msgmerge --update --previous
# # note: the URL is used as identifier, no HTTP is used!
# DOCBOOK_XSL=http://docbook.sourceforge.net/release/xsl/current
VERBOSE	:=
# Debian packge archive URL
#DEBM	:=	http://ftp.us.debian.org/debian/dists
DEBM	:=	http://ftp.jp.debian.org/debian/dists
# Debian popcon data source URL
UPOPC	:=	http://popcon.debian.org/all-popcon-results.txt.gz
# Debian release name and arch used
CODE	:=	sid
ARCH	:=	amd64
UDEBA	:=	$(DEBM)/$(CODE)
# language defaults
LANGALL	:=	en ja fr it es de pt-br pl zh-tw zh-cn
LANGPO	:=	ja
LANGNEW	:=
LANGSGML =	$(filter-out en $(LANGPO), $(LANGALL))

# AsciiDoc source files in $(ADOC) directories
ASCSRC	:=	00_preface.txt 01_tutorial.txt 02_package.txt \
		03_sysinit.txt 04_auth.txt 05_network.txt 06_netapp.txt \
		07_xwindow.txt 08_i18nl10ntxt 09_systips.txt 10_datamngt.txt \
		11_dataconv.txt 12_program.txt 99_appendix.txt \
		copyright.txt header.txt $(DOCNAME).txt
# source files (local update requires these)
ASCSRCS :=	$(addprefix $(ADOC)/, $(ASCSRC))
RAWSRCS :=	$(DOCNAME).raw.xml all-popcon-results.txt packages.txt
# source files (build prcess requires these)
ENTSRCS	:=	urls.ent datadatepop.ent datadatesize.ent popcon.ent pkgsize.ent common.ent
XMLSRCS	 =	$(DOCNAME).en.xml $(addsuffix .po, $(addprefix  $(PODOC)/$(DOCNAME)., $(LANGPO))) $(ENTSRCS)

#########################################################################
# Local raw XML files and base data created from asciidoc in lenny  LOCAL
#########################################################################
#=======================================================================#
ifeq ($(BUILD_MODE),asciidoc)
#=======================================================================#

.SECONDARY: $(XMLSRCS)

# -----------------------------------------------------------------------
# This is cleaned after "make clean"
# create a raw XML source from asciidoc source
$(DOCNAME).raw.xml: $(ASCSRCS)
	asciidoc -a 'newline=\n' -b docbook -d book -o - $(ADOC)/$(DOCNAME).txt |\
	sed -e "/<\/authorinitials>/r $(ADOC)/copyright.txt" |\
	xmllint --format -  > $@

# -----------------------------------------------------------------------
# Remotely fetched files prior to the build after "make distclean"
# These are cleaned after "make clean"
# These will not be a part of source except datadate{pop|size}.ent
# datadate{pop|size}.ent are generated as secondary side effects

all-popcon-results.txt:
	wget -O - $(UPOPC) | zcat - > all-popcon-results.txt
	echo "<!ENTITY pop-date \"$(shell date -u +'%F %T %Z')\">" > datadatepop.ent

packages.txt:
	wget -O - $(UDEBA)/main/binary-$(ARCH)/Packages.bz2      | bzcat - > packages.main.tmp
	grep-dctrl -e -sPackage,Installed-Size -P "." packages.main.tmp > packages.main
	rm packages.main.tmp
	wget -O - $(UDEBA)/contrib/binary-$(ARCH)/Packages.bz2   | bzcat - > packages.contrib.tmp
	grep-dctrl -e -sPackage,Installed-Size -P "." packages.contrib.tmp > packages.contrib
	rm packages.contrib.tmp
	wget -O - $(UDEBA)/non-free/binary-$(ARCH)/Packages.bz2  | bzcat - > packages.non-free.tmp
	grep-dctrl -e -sPackage,Installed-Size -P "." packages.non-free.tmp > packages.non-free
	rm packages.non-free.tmp
	#sync
	#sleep 1
	cat packages.main packages.contrib packages.non-free >$@
	#
	echo "<!ENTITY all-packages \"$$(grep -e '^Package:' packages.txt | wc -l)\">"			>  datadatesize.ent
	echo "<!ENTITY main-packages \"$$( grep -e '^Package:' packages.main | wc -l)\">"		>> datadatesize.ent
	echo "<!ENTITY contrib-packages \"$$(grep -e '^Package:' packages.contrib | wc -l)\">"		>> datadatesize.ent
	echo "<!ENTITY non-free-packages \"$$(grep -e '^Package:' packages.non-free | wc -l)\">"	>> datadatesize.ent
	echo "<!ENTITY pkgsize-date \"$(shell date -u +'%F %T %Z')\">"					>> datadatesize.ent
	rm packages.main packages.contrib packages.non-free

# trick to allow building source w/o all-popcon-results.txt
datadatepop.ent:
	$(MAKE) all-popcon-results.txt

# trick to allow building source w/o packages.txt
datadatesize.ent:
	$(MAKE) packages.txt

# trick to allow building source w/o all-popcon-results.txt and pkg.lst
popcon.ent:
	if ! [ -f all-popcon-results.txt ]; then $(MAKE) all-popcon-results.txt ; fi
	if ! [ -f pkg.lst ]; then $(MAKE) pkg.lst ; fi
	echo "<!ENTITY pop-submissions \"$(shell sed -n -e 's/^Submissions: *\([^ ]*\) *$$/\1/p' < all-popcon-results.txt)\">"	>  $@
	echo "<!ENTITY pop-architectures \"$(shell grep -e '^Architecture:' all-popcon-results.txt | wc -l)\">"			>> $@
	echo "<!ENTITY pop-packages \"$(shell grep -e '^Package:' all-popcon-results.txt | wc -l)\">"				>> $@
	TOTAL=$(shell sed -n -e 's/^Submissions: *\([^ ]*\) *$$/\1/p' < all-popcon-results.txt) ;\
	grep -e '^Package:' all-popcon-results.txt | grep -f pkg.lst | $(PBIN)/popconent $$TOTAL				>> $@

# trick to allow building source w/o packages.txt and pkg.lst
pkgsize.ent:
	if ! [ -f packages.txt ]; then $(MAKE) packages.txt ; fi
	if ! [ -f pkg.lst ]; then $(MAKE) pkg.lst ; fi
	$(PBIN)/sizeent packages.txt < pkg.lst	> $@

# change if there have been some change in source
common.ent: $(filter-out common.ent, $(XMLSRCS))
	echo "<!ENTITY build-date \"$(shell date -u +'%F %T %Z')\">"	>  $@
	echo "<!ENTITY arch \"$(ARCH)\">"				>> $@
	echo "<!ENTITY codename-stable   \"lenny\">"			>> $@
	echo "<!ENTITY codename-testing  \"squeeze\">"			>> $@
	echo "<!ENTITY codename-nexttesting  \"squeeze+1\">"		>> $@
	echo "<!ENTITY codename-unstable \"sid\">"			>> $@

# -----------------------------------------------------------------------
# Create final XML sources
# This is not cleaned after "make clean" but cleaned by "make distclean"

# replace table contents with @@@popcon*@@@ and @@@psize*@@@ and 
# fix URL referencees and table ID.
$(DOCNAME).en.xml: $(DOCNAME).raw.xml $(ADOC)/header.txt
	# $$ in following becomes $ under make: 5.0.2 -> 5.0
	if [ $$(sed -n "s/^\([^.]*\.[^.]*\).*$$/\1/p" < /etc/debian_version) != "5.0" ]; then \
		echo "You must be running lenny">&2 ; exit 1 ; fi	
	# use asciidoc generated xml file as main contents 
	xsltproc --novalid $(VERBOSE) $(PXSLT)/table.xsl $(DOCNAME).raw.xml |\
	$(PBIN)/colspec.py  |\
	sed -e '/<!DOCTYPE /d' -e "1r $(ADOC)/header.txt" |\
	sed -f bin/replace > $@

# trick to allow building source w/o regenerating urls.ent unneededly
urls.ent:  $(ASCSRCS)
	# $$ in following becomes $ under make: 5.0.2 -> 5.0
	if [ $$(sed -n "s/^\([^.]*\.[^.]*\).*$$/\1/p" < /etc/debian_version) != "5.0" ]; then \
		echo "You must be running lenny">&2 ; exit 1 ; fi	
	if ! [ -f $(DOCNAME).raw.xml ]; then $(MAKE) $(DOCNAME).raw.xml ; fi
	xsltproc --novalid $(VERBOSE) $(PXSLT)/urls.xsl $(DOCNAME).raw.xml | sort | uniq | sed -f bin/replace	> $@

# package name list for popcon and size ent file generation
# This file is not part of source
pkg.lst: $(DOCNAME).raw.xml
	xsltproc --novalid $(VERBOSE) $(PXSLT)/pkg.xsl $< > $@


#=======================================================================#
else
#=======================================================================#
# To avoid circular dependency
$(DOCNAME).en.xml:
	echo "You need to run \"make xml\" in lenny environment"
	exit

#=======================================================================#
endif
#=======================================================================#

#########################################################################
# POT/PO file operations                                            LOCAL
#########################################################################
# Create new POT file in $(PODOC) matching $(DOCNAME).en.xml
.PHONY: pot
pot: $(PODOC)/$(DOCNAME).pot
$(PODOC)/$(DOCNAME).pot: $(DOCNAME).en.xml
	$(GETTEXT) -m $(DOCNAME).en.xml -p $(PODOC)/$(DOCNAME).pot

# Update new PO file in $(PODOC) by POT file
$(PODOC)/$(DOCNAME).%.po: $(PODOC)/$(DOCNAME).pot
	$(UPDATEPO) $(PODOC)/$(DOCNAME).$*.po $(PODOC)/$(DOCNAME).pot

# Update new PO file in $(PODOC) by POT file for English typo fix
.PHONY: typo
typo:
	-rm -f $(PODOC)/$(DOCNAME).pot.old
	cp $(PODOC)/$(DOCNAME).pot $(PODOC)/$(DOCNAME).pot.old
	$(MAKE) BUILD_MODE=asciidoc  $(DOCNAME).en.xml
	$(GETTEXT) -m $(DOCNAME).en.xml -p $(PODOC)/$(DOCNAME).pot
	# repeat for all languages
	for $$xx in $(LANGPO) ; do \
	msguntypot -o $(PODOC)/$(DOCNAME).pot.old -n $(PODOC)/$(DOCNAME).pot $(PODOC)/$(DOCNAME).$$xx.po ;\
	done

#########################################################################
# Translate XML files                                                 ALL
#########################################################################
$(DOCNAME).%.xml: $(PODOC)/$(DOCNAME).%.po $(DOCNAME).en.xml
	$(TRANSLATE) -m $(DOCNAME).en.xml -p $(PODOC)/$(DOCNAME).$*.po -l $(DOCNAME).$*.xml
	
#########################################################################
# Create HTML files                                                   ALL
#########################################################################
.PHONY: css
css:
	-rm -rf $(DRPUBLISHDIR)/images
	mkdir -p $(DRPUBLISHDIR)/images
	cp -f $(PXSLT)/$(DOCNAME).css $(DRPUBLISHDIR)/$(DOCNAME).css
	cd $(IMAGES) ; cp caution.png home.gif important.png next.gif note.png prev.gif tip.png up.gif warning.png $(DRPUBLISHDIR)/images

.PHONY: html
html:	$(foreach lang, en $(LANGPO), $(DRPUBLISHDIR)/$(DOCNAME).$(lang).html)  $(foreach lang, en $(LANGPO), $(DRPUBLISHDIR)/index.$(lang).html)

$(DRPUBLISHDIR)/$(DOCNAME).%.html: $(DOCNAME).%.xml $(ENTSRCS)
	$(XP)   --stringparam root.filename $(DOCNAME) \
		--stringparam base.dir $(DRPUBLISHDIR)/ \
                --stringparam html.ext .$*.html \
                --stringparam html.stylesheet $(DOCNAME).css \
                xslt/style-onehtml.xsl $<

$(DRPUBLISHDIR)/index.%.html: $(DOCNAME).%.xml $(ENTSRCS)
	$(XP)   --stringparam root.filename index \
		--stringparam base.dir $(DRPUBLISHDIR)/ \
                --stringparam html.ext .$*.html \
                --stringparam html.stylesheet $(DOCNAME).css \
                xslt/style-html.xsl $<

.PHONY: txt
txt:	$(foreach lang, en $(LANGPO), $(DRPUBLISHDIR)/$(DOCNAME).$(lang).txt)
#  Build rule for TXT (non-English)
#  #  (UTF-8 compatibility of debiandoc2text is limitted)
$(DRPUBLISHDIR)/$(DOCNAME).%.txt: $(DRPUBLISHDIR)/$(DOCNAME).%.html
	LC_ALL=en_US.UTF-8 w3m -dump -cols 65 -T text/html $(DRPUBLISHDIR)/$(DOCNAME).$*.html >$@


#########################################################################
# Utility targets                                                     ALL
#########################################################################
# Replicate
REMOTE  := people.debian.org:public_html/pub/po4a/

.PHONY: rsync
rsync:
	rsync --exclude=all-popcon-results.txt --exclude=packages.txt --exclude=pkg.lst --exclude="debian-reference.*.xml" \
		-rpt --delete-after . $(REMOTE)
	# somehow rsync does 700, fixit
	ssh people.debian.org "chmod ugo+rX public_html/pub/po4a"

.PHONY: url-check
# sanity check for url
url-check: urls.lst
	@echo "----- Duplicate URL references (start) -----"
	-sed -ne "s/<\!ENTITY \([^ ]*\) .*$$/\" \1 \"/p"  < $< | uniq -d | xargs -n 1 grep $< -e  
	@echo "----- Duplicate URL references (end) -----"
	@echo "----- URL check (start) -----"
	@sed -ne "s/<\!ENTITY [^ ]* \"\(.*\)\">$$/\"\1\"/p"  < $< | uniq | xargs -n 1 wget -O /dev/null -nv
	@echo "----- URL check (end) -----"

#######################################################################
# Update source using remotely fetched data                         ALL
#######################################################################
.PHONY: update
update:
	$(MAKE) distclean
	$(MAKE) xml
	$(MAKE) clean

#######################################################################
# Build html for web (DDP or alioth)                                ALL
#######################################################################
.PHONY: publish

publish:
	-mkdir -p $(DRPUBLISHDIR)
#	-rm -rf $(DRPUBLISHDIR)/debian-reference
	-rm -f $(PUBLISHDIR)/reference
	-ln -sf $(DRPUBLISHDIR) $(PUBLISHDIR)/reference
	$(MAKE) html txt css PUBLISHDIR=$(PUBLISHDIR) "LANGPO=$(LANGPO)"
	$(MAKE) -C sgml all PUBLISHDIR=$(DRPUBLISHDIR) "LANG_ALL=$(LANGSGML)"
#	ls -lR $(PUBLISHDIR)

#######################################################################
# Build xml/html for testing source (local)                         ALL
#######################################################################
.PHONY: xml
xml:	
	$(MAKE) BUILD_MODE=asciidoc $(XMLSRCS) "LANGPO=$(LANGPO)"

.PHONY: all
all:
	# making sure to rebuild all
	touch asciidoc/00_preface.txt
	$(MAKE) BUILD_MODE=asciidoc html txt css "LANGPO=$(LANGPO)"
	$(MAKE) -C sgml all PUBLISHDIR=$(DRPUBLISHDIR) "LANG_ALL=$(LANGSGML)"
#	# skip if DDP
#	export HTMLROOT=$(PUBLISHDIR) ; bin/mkindexhtml
#	if [ $$USER = "osamu" ]; then $(MAKE) rsync ; fi

#######################################################################
# Clean targets                                                     ALL
#######################################################################
.PHONY: clean distclean

clean:
	-rm -f *.swp *~ *.tmp
	-rm -rf html
	-rm -f $(PODOC)/*~
ifneq ($(PDIR),ddp-svn)
	-rm -f all-popcon-results.txt packages.txt pkg.lst
	-rm -f $(addsuffix .xml, $(addprefix  $(DOCNAME)., $(LANGPO)))
	-rm -f $(DOCNAME).raw.xml
	$(MAKE) -C sgml clean "LANG_ALL=$(LANGSGML)" PUBLISHDIR=$(DRPUBLISHDIR)
endif

distclean: clean
	-rm -f *.html
	-rm -f $(ENTSRCS)
ifeq ($(PDIR),ddp-svn)
	-rm -f all-popcon-results.txt packages.txt pkg.lst
	-rm -f $(DOCNAME).*.xml
	$(MAKE) -C sgml distclean "LANG_ALL=$(LANGSGML)" PUBLISHDIR=$(DRPUBLISHDIR)
endif

