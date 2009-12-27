#######################################################################
# Build debian-reference (v2)
# vim: set ts=8:
# See README.source for explanation
#######################################################################
### basic parameters (build condition dependent)                    ALL
#######################################################################
# Build from xml only as default (package) -- for squeeze (package)
# to avoid regression caused by asciidoc 8.4.1
BUILD_MODE	:= xml
#
# If this has been addressed, enable this.
#BUILD_MODE	:= asciidoc

# Build from asciidoc as default (package) -- for lenny (local, DDP)
# Use "all" "xml" "publish" target to use this.
#BUILD_MODE	:= asciidoc

# Please note package build and ddp script overides $(PUBLISHDIR)
# if $(PUBLISHDIR) is not set, set it here for testing
PUBLISHDIR	:= $(CURDIR)/html

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
UPDATEPO:=	msgmerge --update --previous --no-wrap
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
UDEBB	:=	$(DEBM)/experimental
# language defaults
LANGALL	:=	en ja fr it es de pt-br pl zh-tw zh-cn
LANGPO	:=	   ja fr
LANGNEW	:=
LANGSGML =	$(filter-out en $(LANGPO), $(LANGALL))

# AsciiDoc source files in $(ADOC) directories
ASCSRC	:=	00_preface.txt 01_tutorial.txt 02_package.txt \
		03_sysinit.txt 04_auth.txt 05_network.txt 06_netapp.txt \
		07_xwindow.txt 08_i18nl10ntxt 09_systips.txt 10_datamngt.txt \
		11_dataconv.txt 12_program.txt 99_appendix.txt \
		copyright.txt header1.txt header2.txt $(DOCNAME).txt
# source files (local update requires these)
ASCSRCS :=	$(addprefix $(ADOC)/, $(ASCSRC))
RAWSRCS :=	$(DOCNAME).raw.xml all-popcon-results.txt packages.txt packages.bkup.txt
# source files (build prcess requires these)
ENTSRCS	:=	urls.ent datadatepop.ent datadatesize.ent popcon.ent pkgsize.ent common.ent
XMLSRCS	 =	$(ENTSRCS) $(DOCNAME).raw.xml $(addsuffix .po, $(addprefix  $(PODOC)/$(DOCNAME)., $(LANGPO))) $(addsuffix .xml, $(addprefix  $(DOCNAME)., en $(LANGPO)))

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
# Regression caused by asciidoc 8.4.1 should be addressed by 
# "-a no-inline-literal" but .... does not work.  Use lenny:
$(DOCNAME).raw.xml: $(ASCSRCS)
	asciidoc -a no-inline-literal -a 'newline=\n' -b docbook -d book -o - $(ADOC)/$(DOCNAME).txt |\
	sed -e "/<\/authorinitials>/r $(ADOC)/copyright.txt" |\
	xmllint --format -  |\
	sed -f bin/replace > $@

# -----------------------------------------------------------------------
# Remotely fetched files prior to the build after "make distclean"
# These are cleaned after "make clean"
# These will not be a part of source except datadate{pop|size}.ent
# datadate{pop|size}.ent are generated as secondary side effects

all-popcon-results.txt:
	wget -O - $(UPOPC) | zcat - > $@
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
	cat packages.main packages.contrib packages.non-free >$@
	#
	echo "<!ENTITY all-packages \"$$(grep -e '^Package:' packages.txt | wc -l)\">"			>  datadatesize.ent
	echo "<!ENTITY main-packages \"$$( grep -e '^Package:' packages.main | wc -l)\">"		>> datadatesize.ent
	echo "<!ENTITY contrib-packages \"$$(grep -e '^Package:' packages.contrib | wc -l)\">"		>> datadatesize.ent
	echo "<!ENTITY non-free-packages \"$$(grep -e '^Package:' packages.non-free | wc -l)\">"	>> datadatesize.ent
	echo "<!ENTITY pkgsize-date \"$(shell date -u +'%F %T %Z')\">"					>> datadatesize.ent
	rm packages.main packages.contrib packages.non-free

packages.bkup.txt:
	wget -O - $(UDEBB)/main/binary-$(ARCH)/Packages.bz2      | bzcat - > packages.bkup.tmp
	grep-dctrl -e -sPackage,Installed-Size -P "." packages.bkup.tmp > $@
	rm packages.bkup.tmp

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

# trick to allow building source w/o packages.txt and packages.bkup.txt and pkg.lst
pkgsize.ent:
	if ! [ -f packages.txt ]; then $(MAKE) packages.txt ; fi
	if ! [ -f packages.bkup.txt ]; then $(MAKE) packages.bkup.txt ; fi
	if ! [ -f pkg.lst ]; then $(MAKE) pkg.lst ; fi
	$(PBIN)/sizeent packages.txt packages.bkup.txt < pkg.lst	> $@

# change if there have been some change in source
common.ent: $(filter-out common.ent, $(XMLSRCS))
	echo "<!ENTITY build-date \"$(shell date -u +'%F %T %Z')\">"	>  $@
	echo "<!ENTITY arch \"$(ARCH)\">"				>> $@
	echo "<!ENTITY codename-stable   \"lenny\">"			>> $@
	echo "<!ENTITY codename-testing  \"squeeze\">"			>> $@
	echo "<!ENTITY codename-nexttesting  \"squeeze+1\">"		>> $@
	echo "<!ENTITY codename-unstable \"sid\">"			>> $@

#=======================================================================#
endif
#=======================================================================#
#########################################################################
# XML file operations                                                 ALL
#########################################################################
# Create final XML sources
# This is not cleaned after "make clean" but cleaned by "make distclean"

# replace table contents with @-@popcon*@@@ and @@@psize*@-@ and 
# fix URL referencees and table ID.
$(DOCNAME).en.xml: $(DOCNAME).raw.xml header.txt
	# use asciidoc generated xml file as main contents 
	xsltproc --novalid $(VERBOSE) $(PXSLT)/table.xsl $(DOCNAME).raw.xml |\
	$(PBIN)/colspec.py  |\
	sed -e '/<!DOCTYPE /d' -e "1r header.txt" |\
	sed -e 's/@-@amp@-@/\&/g' -e 's/@-@\([^@]\+\)@-@/\&\1;/g' > $@

# replace table contents with @-@popcon*@-@ and @-@psize*@-@ with dummy text and 
# fix URL referencees and table ID as template for translation.
$(DOCNAME).en.xmlt: $(DOCNAME).raw.xml header.txt
	# use asciidoc generated xml file as main contents 
	xsltproc --novalid $(VERBOSE) $(PXSLT)/tablet.xsl $(DOCNAME).raw.xml |\
	$(PBIN)/colspec.py  |\
	sed -e '/<!DOCTYPE /d' -e "1r header.txt" |\
	sed -e 's/@-@amp@-@/\&/g' -e 's/@-@\([^@]\+\)@-@/\&\1;/g' > $@

# trick to allow building source w/o regenerating urls.ent unneededly
urls.ent:  $(ASCSRCS)
	if ! [ -f $(DOCNAME).raw.xml ]; then $(MAKE) $(DOCNAME).raw.xml ; fi
	xsltproc --novalid $(VERBOSE) $(PXSLT)/urls.xsl $(DOCNAME).raw.xml | sort | uniq |\
	sed -e "s/&/\&amp;/g" > $@

header.txt: $(ADOC)/header1.txt urls.ent $(ADOC)/header2.txt
	cat $^ > $@

# package name list for popcon and size ent file generation
# This file is not part of source
pkg.lst: $(DOCNAME).raw.xml
	xsltproc --novalid $(VERBOSE) $(PXSLT)/pkg.xsl $< > $@

#=======================================================================#
ifneq ($(BUILD_MODE),asciidoc)
#=======================================================================#
# To avoid dependency $(DOCNAME).raw.xml: $(PODOC)/$(DOCNAME).raw.po $(DOCNAME).en.xml
$(DOCNAME).raw.xml:
	echo "You need to run \"make xml\" in lenny environment"
	exit
#=======================================================================#
endif
#=======================================================================#

#########################################################################
# POT/PO file operations                                              ALL
#########################################################################
# Create new POT file in $(PODOC) matching $(DOCNAME).en.xml
.PHONY: pot
pot: $(PODOC)/$(DOCNAME).pot $(PODOC)/urls.pot

# create pot file from template xml
$(PODOC)/$(DOCNAME).pot: $(DOCNAME).en.xmlt
	$(GETTEXT) -p $@ -m $<

# Update new PO file in $(PODOC) by POT file
$(PODOC)/$(DOCNAME).%.po: $(PODOC)/$(DOCNAME).pot
	$(UPDATEPO) $@ $<
	@echo ">>> $@:      $$(msgattrib --fuzzy        $@ |grep '^msgid'|wc -l) fuzzy translation"
	@echo ">>> $@: $$(( $$(msgattrib --untranslated $@ |grep '^msgid'|wc -l) - 1 )) untranslated"

# Make list of all "http://en.wikipedia.org/wiki/..."
$(PODOC)/wikipedia.list: $(PODOC)/$(DOCNAME).pot
	sed -ne "s/^msgid \"\(http:\/\/en\.wikipedia\.org\/wiki\/.*\)\"/\1/p" < $< > $@

# Make list of untranslated "http://en.wikipedia.org/wiki/..."
$(PODOC)/wikipedia.%.list: $(PODOC)/$(DOCNAME).%.po
	sed -ne "s/^msgstr \"\(http:\/\/en\.wikipedia\.org\/wiki\/.*\)\"/\1/p" < $< > $@

# Translate all
$(PODOC)/wikipedia.%.pot: $(PODOC)/wikipedia.list
	bin/interwiki $* "PRINT" < $< > $@

# Translate untranslated
$(PODOC)/wikipedia.%.po: $(PODOC)/wikipedia.%.list
	bin/interwiki $* "NO"   < $< > $@

# Update new PO file in $(PODOC) by POT file for English typo fix
.PHONY: typo
typo:
	-rm -f $(PODOC)/$(DOCNAME).pot.old
	cp $(PODOC)/$(DOCNAME).pot $(PODOC)/$(DOCNAME).pot.old
	$(MAKE) BUILD_MODE=asciidoc  $(DOCNAME).en.xmlt
	$(GETTEXT) -p $(PODOC)/$(DOCNAME).pot -m $(DOCNAME).en.xmlt
	# repeat for all languages
	for $$xx in $(LANGPO) ; do \
	msguntypot -o $(PODOC)/$(DOCNAME).pot.old -n $(PODOC)/$(DOCNAME).pot $(PODOC)/$(DOCNAME).$$xx.po ;\
	done

#########################################################################
# Translate XML files                                                 ALL
#########################################################################
$(DOCNAME).ja.xml: $(PODOC)/$(DOCNAME).ja.po $(PODOC)/addendum1.ja $(DOCNAME).en.xml
	$(TRANSLATE) -m $(DOCNAME).en.xml -a $(PODOC)/addendum1.ja -p $< -l $@

$(DOCNAME).%.xml: $(PODOC)/$(DOCNAME).%.po $(DOCNAME).en.xml
	$(TRANSLATE) -m $(DOCNAME).en.xml -p $< -l $@
	
#########################################################################
# Create HTML files                                                   ALL
#########################################################################
.PHONY: css
css:
	-rm -rf $(PUBLISHDIR)/images
	mkdir -p $(PUBLISHDIR)/images
	cp -f $(PXSLT)/$(DOCNAME).css $(PUBLISHDIR)/$(DOCNAME).css
	cd $(IMAGES) ; cp caution.png home.gif important.png next.gif note.png prev.gif tip.png up.gif warning.png $(PUBLISHDIR)/images

.PHONY: html
html:	$(foreach lang, en $(LANGPO), $(PUBLISHDIR)/$(DOCNAME).$(lang).html)  $(foreach lang, en $(LANGPO), $(PUBLISHDIR)/index.$(lang).html)

$(PUBLISHDIR)/$(DOCNAME).%.html: $(DOCNAME).%.xml $(ENTSRCS)
	$(XP)   --stringparam root.filename $(DOCNAME) \
		--stringparam base.dir $(PUBLISHDIR)/ \
                --stringparam html.ext .$*.html \
                --stringparam admon.graphics 0 \
                --stringparam callout.graphics 0 \
                --stringparam navig.graphics 0 \
                --stringparam html.stylesheet $(DOCNAME).css \
                xslt/style-onehtml.xsl $<

$(PUBLISHDIR)/index.%.html: $(DOCNAME).%.xml $(ENTSRCS)
	$(XP)   --stringparam root.filename index \
		--stringparam base.dir $(PUBLISHDIR)/ \
                --stringparam html.ext .$*.html \
                --stringparam html.stylesheet $(DOCNAME).css \
                xslt/style-html.xsl $<

.PHONY: txt
txt:	$(foreach lang, en $(LANGPO), $(PUBLISHDIR)/$(DOCNAME).$(lang).txt)
#  Build rule for TXT (non-English)
#  #  (UTF-8 compatibility of debiandoc2text is limitted)
$(PUBLISHDIR)/$(DOCNAME).%.txt: $(PUBLISHDIR)/$(DOCNAME).%.html
	LC_ALL=en_US.UTF-8 w3m -dump -cols 65 -T text/html $(PUBLISHDIR)/$(DOCNAME).$*.html >$@


#########################################################################
# Utility targets                                                     ALL
#########################################################################
# Replicate
REMOTE  := people.debian.org:public_html/pub/po4a/

.PHONY: rsync
rsync:
	rsync --exclude=all-popcon-results.txt --exclude=packages.txt --exclude=packages.bkup.txt --exclude=pkg.lst --exclude="debian-reference.*.xml" \
		-rpt --delete-after . $(REMOTE)
	# somehow rsync does 700, fixit
	ssh people.debian.org "chmod ugo+rX public_html/pub/po4a"

.PHONY: url 

# check url for everything
url: url-sanity url-ja url-check-en url-check-ja

# check url sanity
url-sanity: $(DOCNAME).en.xml
	@echo "----- Duplicate URL references (start) -----"
	-sed -ne "/^<\!ENTITY/s/<\!ENTITY \([^ ]*\) .*$$/\" \1 \"/p"  < $< | uniq -d | xargs -n 1 grep $< -e  | grep -e "^<\!ENTITY"
	@echo "----- Duplicate URL references (end) -----"

#	<!ENTITY abi "http://en.
url-ja: $(DOCNAME).ja.xml
	@echo "-----  Wikipedia URL references (start) -----"
	-grep "^<\!ENTITY [^ ][^ ]*  *\"http:\/\/en\." < $< | wc -l
	-grep "^<\!ENTITY [^ ][^ ]*  *\"http:\/\/$*\." < $< | wc -l
	@echo "----- Wikipedia URL references (end) -----"

# sanity check for url
url-check-%: $(DOCNAME).%.xml
	@echo "----- URL check $* (start) -----"
	@sed -ne "/^<\!ENTITY/s/<\!ENTITY [^ ]* \"\(.*\)\">$$/\"\1\"/p"  < $< | uniq | xargs -n 1 wget -O /dev/null -nv || echo "**************************************************************"
	@echo "----- URL check $* (end) -----"

#######################################################################
# Update source using remotely fetched data                         ALL
#######################################################################
.PHONY: update
update:
	$(MAKE) distclean
	$(MAKE) BUILD_MODE=asciidoc xml
	$(MAKE) clean

#######################################################################
# Build html for web (DDP or alioth)                                ALL
#######################################################################
.PHONY: publish

# $(PUBLISHDIR) is set to be: /org/www.debian.org/www/doc/manuals for master-www
publish:
	-mkdir -p $(PUBLISHDIR)/debian-reference
	-rm -f $(PUBLISHDIR)/reference
	# For www.debian.org, relative symlink only
	-ln -sf debian-reference $(PUBLISHDIR)/reference
	$(MAKE) html txt css BUILD_MODE=asciidoc PUBLISHDIR=$(PUBLISHDIR)/debian-reference "LANGPO=$(LANGPO)"
	$(MAKE) -C sgml all PUBLISHDIR=$(PUBLISHDIR)/debian-reference "LANG_ALL=$(LANGSGML)"
#	ls -lR $(PUBLISHDIR)

#######################################################################
# Build xml/html for testing source (local)                         ALL
#######################################################################
.PHONY: new
new:
	# making sure to rebuild all from asciidoc and po
	touch asciidoc/00_preface.txt

.PHONY: po
po:	
	# update po files from updated raw.xml
	$(MAKE) BUILD_MODE=xml $(XMLSRCS) "LANGPO=$(LANGPO)"

.PHONY: po-test
po-test:	
	# build translated html/text pages from from raw.xml and po
	# This is to test result of translation quickly
	$(MAKE) BUILD_MODE=xml html txt css "LANGPO=$(LANGPO)"

.PHONY: xml
xml: new
	$(MAKE) BUILD_MODE=asciidoc $(XMLSRCS) "LANGPO=$(LANGPO)"

.PHONY: all
all:
	$(MAKE) BUILD_MODE=asciidoc html txt css "LANGPO=$(LANGPO)"
	$(MAKE) -C sgml all PUBLISHDIR=$(PUBLISHDIR) "LANG_ALL=$(LANGSGML)"
#	# skip if DDP
#	export HTMLROOT=$(PUBLISHDIR) ; bin/mkindexhtml
#	if [ $$USER = "osamu" ]; then $(MAKE) rsync ; fi

#######################################################################
# Clean targets                                                     ALL
#######################################################################
.PHONY: clean clean-data distclean

clean:
	-rm -f *.swp *~ *.tmp
	-rm -rf html
	-rm -f $(PODOC)/*~
	-rm -f urls.ent pkg.lst header.txt
	-rm -f $(addsuffix .xml, $(addprefix  $(DOCNAME)., $(LANGPO)))
	-rm -f $(DOCNAME).en.xml $(DOCNAME).en.xmlt
	$(MAKE) -C sgml clean "LANG_ALL=$(LANGSGML)" PUBLISHDIR=$(PUBLISHDIR)

clean-data: clean
	-rm -f all-popcon-results.txt packages.txt packages.bkup.txt pkg.lst

distclean: clean-data
	-rm -f $(ENTSRCS)


