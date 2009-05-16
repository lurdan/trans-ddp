#######################################################################
# Build debian-reference (v2)
# vim: set ts=8:
#######################################################################
### basic parameters
#######################################################################
# parent dir name of the SVN source checkout location (DDP=doc)
PDIR	:=	$(notdir $(realpath $(CURDIR)/../..))
# Publish directory
# This can and will be overridden by a higher level makefile
ifeq ($(PDIR),doc)
PUBLISHDIR := /org/www.debian.org/www/doc/manuals/reference
else
PUBLISHDIR := $(CURDIR)/html
endif

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
# The threshold should be 80 if translation id completed.
THRESHOLD:=	0
TRANSLATE:=	po4a-translate  -M utf-8          --format docbook --keep $(THRESHOLD)
GETTEXT	:=	po4a-gettextize -M utf-8 -L utf-8 --format docbook
UPDATEPO:=	po4a-updatepo   -M utf-8          --format docbook

# # XSL files and parameters
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
# AsciiDoc source files in $(ADOC) directories
ASCSRC	:=	00_preface.txt 01_tutorial.txt 02_package.txt \
		03_sysinit.txt 04_auth.txt 05_network.txt 06_netapp.txt \
		07_xwindow.txt 08_i18nl10ntxt 09_systips.txt 10_datamngt.txt \
		11_dataconv.txt 12_program.txt 99_appendix.txt
# source files
ASCSRCS :=	$(ADOC)/$(DOCNAME).txt $(addprefix $(ADOC)/, $(ASCSRC))
ENTSRCS	:=	urls.ent datadatepop.ent datadatesize.ent popcon.ent pkgsize.ent common.ent
XMLSRCS	:=	$(DOCNAME).en.xml $(ENTSRCS)
LANGALL	:=	en ja fr it es de pt-br pl zh-tw zh-cn
LANGPO	:=	ja
LANGNEW	:=
LANGSGML:=	$(filter-out en $(LANGPO), $(LANGALL))

#########################################################################
# Local raw XML file generated from local asciidoc prior to the build
# This is cleaned after "make clean"
#########################################################################

# create a raw XML source from asciidoc source
$(DOCNAME).raw.xml: $(ASCSRCS)
	asciidoc -a 'newline=\n' -b docbook -d book -o - $(ADOC)/$(DOCNAME).txt	> $@

#########################################################################
# Remotely fetched files prior to the build after "make distclean"
# These are cleaned after "make clean"
# These will not be a part of source except datadate{pop|size}.ent
# datadate{pop|size}.ent are generated as secondary side effects
#########################################################################

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

# package name list for popcon and size ent file generation
# This file is not part of source
pkg.lst: $(DOCNAME).raw.xml
	xsltproc --novalid $(VERBOSE) $(PXSLT)/pkg.xsl $< > $@

#########################################################################
# Create final XML sources
# This is not cleaned after "make clean" but cleaned by "make distclean"
#########################################################################
.PHONY: xml
xml:	$(XMLSRCS) $(addsufix, .xml, $(addprefix  $(DOCNAME)., $(LANGPO)))

# replace table contents with @@@popcon*@@@ and @@@psize*@@@ and 
# fix URL referencees and table ID.
$(DOCNAME).en.xml: $(DOCNAME).raw.xml $(ADOC)/header.txt
	# use 00_header.txt as header instead
	sed -f bin/replace < $(ADOC)/header.txt > $@
	# use asciidoc generated xml file as main contents 
	# (excluding header parts with sed)
	xsltproc --novalid $(VERBOSE) $(PXSLT)/table.xsl $(DOCNAME).raw.xml |\
	sed -f bin/replace | sed -n -e "1,/<\/bookinfo>/!p"	>> $@ 

# trick to allow building source w/o regenerating urls.ent unneededly
urls.ent:  $(ASCSRCS)
	if ! [ -f $(DOCNAME).raw.xml ]; then $(MAKE) $(DOCNAME).raw.xml ; fi
	xsltproc --novalid $(VERBOSE) $(PXSLT)/urls.xsl $(DOCNAME).raw.xml | sort | uniq | sed -f bin/replace	> $@

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

#########################################################################
# Create new PO file in $(PODOC)
# Use with "make LANGNEW=<language> newpo" while <language>= ja, fr, ...
#########################################################################
.PHONY: newpo
newpo: $(DOCNAME).en.xml
	if [ -z "$(LANGNEW)" ] || [ -f "$(PODOC)/$(DOCNAME).$(LANGNEW).po" ] ; then exit 1; fi
	$(GETTEXT) -m $(DOCNAME).en.xml -p $(PODOC)/$(DOCNAME).$(LANGNEW).po

#########################################################################
# Update PO files and translate English XML file
#########################################################################
.PHONY: updatepo
updatepo: $(DOCNAME).en.xml 
	$(UPDATEPO)  -m $(DOCNAME).en.xml -p $(PODOC)/$(DOCNAME).ja.po

# create translated XML file while updating PO file
$(DOCNAME).%.xml: $(PODOC)/$(DOCNAME).%.po $(DOCNAME).en.xml
	$(UPDATEPO)  -m $(DOCNAME).en.xml -p $(PODOC)/$(DOCNAME).$*.po
	$(TRANSLATE) -m $(DOCNAME).en.xml -p $(PODOC)/$(DOCNAME).$*.po -l $(DOCNAME).$*.xml

#########################################################################
# Create HTML files
#########################################################################
.PHONY: html
html:	$(foreach lang, en $(LANGPO), $(PUBLISHDIR)/$(DOCNAME).$(lang).html)  $(foreach lang, en $(LANGPO), $(PUBLISHDIR)/index.$(lang).html)

$(PUBLISHDIR)/$(DOCNAME).%.html: $(DOCNAME).%.xml $(ENTSRCS)
	$(XP)   --stringparam root.filename $(DOCNAME) \
		--stringparam base.dir $(PUBLISHDIR)/ \
                --stringparam html.ext .$*.html \
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


#######################################################################
# Utility targets
#########################################################################
# Replicate
REMOTE  := people.debian.org:public_html/pub/po4a/

.PHONY: rsync
rsync:
	-rm -rf $(PUBLISHDIR)/images
	mkdir -p $(PUBLISHDIR)/images
	cd $(IMAGES) ; cp caution.png home.gif important.png next.gif note.png prev.gif tip.png up.gif warning.png $(PUBLISHDIR)/images
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

.PHONY: test
test: guide-line.en.html
guide-line.xml: guide-line.txt
	asciidoc -a 'newline=\n' -b docbook -d book -o - $< > $@

guide-line.en.html: guide-line.xml
	$(XP)   --stringparam root.filename guide-line \
		--stringparam base.dir $(PUBLISHDIR)/ \
                --stringparam html.ext .en.html \
                --stringparam html.stylesheet xslt/$(DOCNAME).css \
                xslt/style-onehtml.xsl $<

#######################################################################
# Update source using remotely fetched data
#######################################################################
.PHONY: update
update:
	$(MAKE) distclean
	$(MAKE) $(ENTSRCS)
	endif$(MAKE) clean

#######################################################################
# Build html for web (DDP or alioth)
#######################################################################
.PHONY: all

all:
	$(MAKE) html txt
	cp -f $(PXSLT)/$(DOCNAME).css $(PUBLISHDIR)/$(DOCNAME).css
	$(MAKE) -C sgml all HTML_ROOT=$(PUBLISHDIR) "LANG_ALL=$(LANGSGML)"
	# skip if DDP
ifneq ($PDIR,doc)
	export HTMLROOT=$(PUBLISHDIR) ; bin/mkindexhtml
	$(MAKE) rsync
endif

#######################################################################
# Clean targets
#######################################################################
.PHONY: clean distclean

clean:
	-rm -f *.swp *~ *.tmp
	-rm -rf $(PUBLISHDIR)
ifneq ($PDIR,doc)
	-rm -f all-popcon-results.txt packages.txt pkg.lst
	-rm -f $(DOCNAME).*.xml
	$(MAKE) -C sgml clean "LANG_ALL=$(LANGSGML)"
endif

distclean: clean
	-rm -f *.html
	-rm -f $(ENTSRCS)
ifeq ($PDIR,doc)
	-rm -f all-popcon-results.txt packages.txt pkg.lst
	-rm -f $(DOCNAME).*.xml
	$(MAKE) -C sgml clean "LANG_ALL=$(LANGSGML)"
endif

