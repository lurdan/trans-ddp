#######################################################################
# Build debian-reference (v2)
# vim: set ts=8:
# See README.source for explanation
#######################################################################
### basic parameters (build condition dependent)                    ALL
#######################################################################
# Build with web access for local build
# BUILD_MODE default value 
BUILD_MODE_LOCAL := local
ifndef BUILD_MODE
BUILD_MODE	:= $(BUILD_MODE_LOCAL)
endif

# Please note package build and ddp script overides $(PUBLISHDIR)
# if $(PUBLISHDIR) is not set, set it here for testing
PUBLISHDIR	:= $(CURDIR)/html

# Change $(DRAFTMODE) from "yes" to "maybe" when this $(MANUAL) should go into
# production mode
#DRAFTMODE      := yes
DRAFTMODE       := maybe
export DRAFTMODE
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
TRANSLATE:=	po4a-translate  -M utf-8          --format docbook --keep $(THRESHOLD) -v 
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
LANGALL	:=	en ja fr it es de pt pt-br pl zh-tw zh-cn
LANGPO	:=	   ja fr it       pt
LANGNEW	:=
LANGSGML =	$(filter-out en $(LANGPO), $(LANGALL))

# remotely fetched data cached locally but removed for package
DATASRCS:=      all-popcon-results.txt packages.txt packages.bkup.txt
# AsciiDoc source file names in $(ADOC) directories for local update
ASC_NM	:=	00_preface.txt 01_tutorial.txt 02_package.txt \
		03_sysinit.txt 04_auth.txt 05_network.txt 06_netapp.txt \
		07_xwindow.txt 08_i18nl10n.txt 09_systips.txt 10_datamngt.txt \
		11_dataconv.txt 12_program.txt 99_appendix.txt \
		copyright.txt header1.txt header2.txt $(DOCNAME).txt
# source asciidoc files (local updates of XML source files requires these under lenny)
SRC_ASC :=	$(addprefix $(ADOC)/, $(ASC_NM))


# source XML inclusion files
SRC_ENT		:=	datadatepop.ent datadatesize.ent popcon.ent pkgsize.ent
# source PO files (build prcess requires these)
SRC_PO	:=	$(addsuffix .po, $(addprefix  $(PODOC)/$(DOCNAME)., $(LANGPO)))
# pristine source XML / PO files (package build requires these)
SRC_XML	 =	$(DOCNAME).raw.xml $(SRC_ENT) $(SRC_PO)

#######################################################################
# Build all sources to html and text pages (Default target)     ALL/DEB
#######################################################################
.PHONY: all package
# Simpler target for easy debug.
all:
	$(MAKE) po
	$(MAKE) html css

# Target for package building
package: html txt css
	$(MAKE) -C sgml all PUBLISHDIR=$(PUBLISHDIR) "LANG_ALL=$(LANGSGML)"

#######################################################################
# Build all sources to html and text pages for web (DDP on alioth)  DDP
#######################################################################
.PHONY: publish

# $(PUBLISHDIR) is set to be: /org/www.debian.org/www/doc/manuals for master-www
publish:
	-mkdir -p $(PUBLISHDIR)/debian-reference
	-rm -f $(PUBLISHDIR)/reference
	# For www.debian.org, relative symlink only
	-ln -sf debian-reference $(PUBLISHDIR)/reference
	$(MAKE) html txt css "PUBLISHDIR=$(PUBLISHDIR)/debian-reference"
	$(MAKE) -C sgml all  "PUBLISHDIR=$(PUBLISHDIR)/debian-reference" "LANG_ALL=$(LANGSGML)"

#######################################################################
# Clean targets                                                     ALL
#######################################################################
.PHONY: clean packageclean distclean

clean:
	-rm -f *.swp *~ *.tmp
	-rm -f $(PODOC)/*~ $(ADOC)/*~
	-rm -rf html
	-rm -f $(addsuffix .xml,      $(addprefix  $(DOCNAME)., $(LANGPO)))
	-rm -f $(DOCNAME).en.xml
	-rm -f $(DOCNAME).en.xmlt header.txt
	$(MAKE) -C sgml clean "LANG_ALL=$(LANGSGML)" PUBLISHDIR=$(PUBLISHDIR)

# Run distclean only for regenerating all locally cached data from remote
#                          (and all raw XML from asciidoc for lenny@local)
packageclean: clean
	# We should clean these local cached data for debian package.
	-rm -f all-popcon-results.txt packages.txt packages.bkup.txt pkg.lst

distclean: packageclean
ifeq ($(BUILD_MODE),$(BUILD_MODE_LOCAL))
	# If not from debian/rules but in local mode, 
	# remove remotely generated files to refresh.
	-rm -f $(DOCNAME).raw.xml
	-rm -f $(SRC_ENT)
endif


#########################################################################
# Local raw XML file is created from the local lenny version of asciidoc
# when building locally
#########################################################################
#=======================================================================#
ifeq ($(BUILD_MODE),$(BUILD_MODE_LOCAL))
#=======================================================================#

.SECONDARY: $(SRC_XML)
#    You can prevent automatic deletion of an intermediate file by
#    marking it as a "secondary" file.  To do this, list it as a
#    prerequisite of the special target `.SECONDARY'.  When a file is
#    secondary, `make' will not create the file merely because it does not
#    already exist, but `make' does not automatically delete the file.
#    Marking a file as secondary also marks it as intermediate.

# -----------------------------------------------------------------------
# create a raw XML source from asciidoc source
# Regression caused by asciidoc 8.4.1 should be addressed by 
# "-a no-inline-literal" but .... this does not work.  
# So I put lenny version in this source tree.
$(DOCNAME).raw.xml: $(SRC_ASC)
	bin/asciidoc -a 'newline=\n' -o - $(ADOC)/$(DOCNAME).txt |\
	sed -e "/<\/authorinitials>/r $(ADOC)/copyright.txt" |\
	xmllint --format -  |\
	sed -f bin/replace > $@
#=======================================================================#
else
#=======================================================================#
# After squeeze, $(DOCNAME).raw.xml is pristine source and should not be rebuild.
# To avoid dependency issues due to "$(DOCNAME).%.xml:", we need this target:
$(DOCNAME).raw.xml:
	echo "BUILD_MODE = \"$(BUILD_MODE)\""
	echo "You need to run \"make\" in local environment to"
	echo "create $(DOCNAME).raw.xml etc. as pristine source."
	exit 1
#=======================================================================#
endif
#=======================================================================#

#########################################################################
# Local cached data created from remote data by local updates       LOCAL
#########################################################################
# datadate{pop|size}.ent are generated as secondary side effects
# These files are not part of the packaged source

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

pkg.lst: $(DOCNAME).raw.xml
	xsltproc --novalid $(VERBOSE) $(PXSLT)/pkg.xsl $< > $@

#########################################################################
# Local base data created from cached data by local updates         LOCAL
#########################################################################
# These $(SRC_ENT) files are part of the packaged prestine source.
# These $(SRC_ENT) need to be rebuild if $(DOCNAME).raw.xml is updated.
# But these $(SRC_ENT) do not depend on $(DOCNAME).raw.xml intentionally to 
# avoid long build tine.  Beakage due to these are rare, minor and pedictable.
# To rebuild these $(SRC_ENT), do "make distclean" first.

.PHONY: xml
xml: $(DOCNAME).raw.xml $(SRC_ENT)

datadatepop.ent:
	$(MAKE) all-popcon-results.txt

datadatesize.ent:
	$(MAKE) packages.txt

popcon.ent:
	if ! [ -f $(DOCNAME).raw.xml ]; then $(MAKE) $(DOCNAME).raw.xml ; fi
	if ! [ -f all-popcon-results.txt ]; then $(MAKE) all-popcon-results.txt ; fi
	if ! [ -f pkg.lst ] || [ $(DOCNAME).raw.xml -nt pkg.lst ]; then $(MAKE) pkg.lst ; fi
	echo "<!ENTITY pop-submissions \"$(shell sed -n -e 's/^Submissions: *\([^ ]*\) *$$/\1/p' < all-popcon-results.txt)\">"	>  $@
	echo "<!ENTITY pop-architectures \"$(shell grep -e '^Architecture:' all-popcon-results.txt | wc -l)\">"			>> $@
	echo "<!ENTITY pop-packages \"$(shell grep -e '^Package:' all-popcon-results.txt | wc -l)\">"				>> $@
	TOTAL=$(shell sed -n -e 's/^Submissions: *\([^ ]*\) *$$/\1/p' < all-popcon-results.txt) ;\
	grep -e '^Package:' all-popcon-results.txt | grep -f pkg.lst | $(PBIN)/popconent $$TOTAL				>> $@

pkgsize.ent:
	if ! [ -f $(DOCNAME).raw.xml ]; then $(MAKE) $(DOCNAME).raw.xml ; fi
	if ! [ -f packages.txt ]; then $(MAKE) packages.txt ; fi
	if ! [ -f packages.bkup.txt ]; then $(MAKE) packages.bkup.txt ; fi
	if ! [ -f pkg.lst ] || [ $(DOCNAME).raw.xml -nt pkg.lst ]; then $(MAKE) pkg.lst ; fi
	$(PBIN)/sizeent packages.txt packages.bkup.txt < pkg.lst	> $@

#########################################################################
# XML file operations                                                 ALL
#########################################################################
# Create final XML sources

common.ent: $(SRC_XML)
	echo "<!ENTITY build-date \"$(shell date -u +'%F %T %Z')\">"	>  $@
	echo "<!ENTITY arch \"$(ARCH)\">"				>> $@
	echo "<!ENTITY codename-stable   \"squeeze\">"			>> $@
	echo "<!ENTITY codename-testing  \"wheezy\">"			>> $@
	echo "<!ENTITY codename-nexttesting  \"wheezy+1\">"		>> $@
	echo "<!ENTITY codename-unstable \"sid\">"			>> $@

# Update URL list header from $(DOCNAME).raw.xml
header.txt: $(ADOC)/header1.txt $(DOCNAME).raw.xml $(ADOC)/header2.txt
	cat $(ADOC)/header1.txt >  $@
	xsltproc --novalid $(VERBOSE) $(PXSLT)/urls.xsl $(DOCNAME).raw.xml | sort | uniq |\
	sed -e "s/&/\&amp;/g"   >> $@
	cat $(ADOC)/header2.txt >> $@

# Replace table contents with @-@popcon*@@@ and @@@psize*@-@ and 
# fix URL referencees and table ID.
$(DOCNAME).en.xml: $(DOCNAME).raw.xml header.txt common.ent
	# use asciidoc generated xml file as main contents 
	xsltproc --novalid $(VERBOSE) $(PXSLT)/table.xsl $(DOCNAME).raw.xml |\
	$(PBIN)/colspec.py  |\
	sed -e '/<!DOCTYPE /d' -e "1r header.txt" |\
	sed -e 's/@-@amp@-@/\&/g' -e 's/@-@\([^@]\+\)@-@/\&\1;/g' > $@

# Replace table contents with dummy text and 
# fix URL referencees and table ID as the template for translation.
# This avoids bloated PO/POT files. (tablet.xsl used insted of table.xsl)
$(DOCNAME).en.xmlt: $(DOCNAME).raw.xml header.txt
	# use asciidoc generated xml file as main contents 
	xsltproc --novalid $(VERBOSE) $(PXSLT)/tablet.xsl $(DOCNAME).raw.xml |\
	$(PBIN)/colspec.py  |\
	sed -e '/<!DOCTYPE /d' -e "1r header.txt" |\
	sed -e 's/@-@amp@-@/\&/g' -e 's/@-@\([^@]\+\)@-@/\&\1;/g' > $@

#########################################################################
# POT/PO file operations                                              ALL
#########################################################################
# Create new POT file in $(PODOC) matching $(DOCNAME).en.xml
.PHONY: pot
pot: $(PODOC)/$(DOCNAME).pot

# create pot file from template xml
$(PODOC)/$(DOCNAME).pot: $(DOCNAME).en.xmlt
	$(GETTEXT) -p $@ -m $<

.PHONY: po
po: 	$(foreach lang, $(LANGPO), $(PODOC)/$(DOCNAME).$(lang).po)

# Update new PO file in $(PODOC) by POT file
$(PODOC)/$(DOCNAME).%.po: FORCE
	$(MAKE) $(PODOC)/$(DOCNAME).pot
	$(UPDATEPO) $@ $(PODOC)/$(DOCNAME).pot

#########################################################################
# Translate XML files                                                 ALL
#########################################################################
# No *.*.add exist for French (Now OK)
#$(DOCNAME).it.xml: $(PODOC)/$(DOCNAME).it.po $(DOCNAME).en.xml
#	$(TRANSLATE) -m $(DOCNAME).en.xml -p $< -l $@

# If no addendum data, *.1.add should be created as zero length file
# Now multiple addendum files such as ja.1.add, ja.2.add, ... can be used
$(DOCNAME).%.xml: $(PODOC)/%.*.add $(DOCNAME).en.xml
	if [ -s $(PODOC)/$*.1.add ]; then \
	echo "... Addendum files used for $*: $$(ls $(PODOC)/$*.*.add)" ;\
	$(TRANSLATE) -m $(DOCNAME).en.xml $$(ls -1 $(PODOC)/$*.*.add | sed -ne 's/^\(.*\)$$/-a \1/p') -p $(PODOC)/$(DOCNAME).$*.po -l $@ ;\
	else \
	echo "... No addendum files used for $*." ;\
	$(TRANSLATE) -m $(DOCNAME).en.xml -p $(PODOC)/$(DOCNAME).$*.po -l $@ ;\
	fi

#########################################################################
# Create HTML files                                                   ALL
#########################################################################
.PHONY: css
css:
	-rm -rf $(PUBLISHDIR)/images
	mkdir -p $(PUBLISHDIR)/images
	cp -f $(PXSLT)/$(DOCNAME).css $(PUBLISHDIR)/$(DOCNAME).css
	echo "AddCharset UTF-8 .txt" > $(PUBLISHDIR)/.htaccess
	cd $(IMAGES) ; cp caution.png home.gif important.png next.gif note.png prev.gif tip.png up.gif warning.png $(PUBLISHDIR)/images

.PHONY: html1 htmli html htmls
html1:	$(foreach lang, en $(LANGPO), $(PUBLISHDIR)/$(DOCNAME).$(lang).html)
htmli:	$(foreach lang, en $(LANGPO), $(PUBLISHDIR)/index.$(lang).html)
html:	html1 htmli
htmls:	html css
$(PUBLISHDIR)/index.%.html: $(DOCNAME).%.xml $(SRC_ENT)
	-mkdir -p $(PUBLISHDIR)
	$(XP)   --stringparam root.filename index \
		--stringparam base.dir $(PUBLISHDIR)/ \
                --stringparam html.ext .$*.html \
                --stringparam html.stylesheet $(DOCNAME).css \
                xslt/style-html.xsl $<

.PHONY: txt
txt:	$(foreach lang, en $(LANGPO), $(PUBLISHDIR)/$(DOCNAME).$(lang).txt)
# txt.xsl provide work around for hidden URL links by appending them explicitly.
$(PUBLISHDIR)/$(MANUAL).%.txt: $(DOCNAME).%.xml $(SRC_ENT)
	-mkdir -p $(PUBLISHDIR)
	@test -n "`which w3m`"  || { echo "ERROR: w3m not found. Please install the w3m package." ; false ;  }
	$(XP) $(XSLT)/txt.xsl $< | LC_ALL=en_US.UTF-8 w3m -o display_charset=UTF-8 -cols 70 -dump -no-graph -T text/html > $@

.PHONY: pdf
pdf:	$(foreach lang, en $(LANGPO), $(PUBLISHDIR)/$(DOCNAME).$(lang).pdf)
# dblatex.xsl provide work around for hidden URL links by appending them explicitly.
$(PUBLISHDIR)/$(MANUAL).%.pdf: $(MANUAL).%.xml $(SRC_ENT)
	-mkdir -p $(PUBLISHDIR)
	@test -n "`which $(DBLATEX)`"  || { echo "ERROR: dblatex not found. Please install the dblatex package." ; false ;  }
	export TEXINPUTS=".:"; \
	$(XP) $(XSLT)/dblatex.xsl $<  | \
	$(DBLATEX) --style=db2latex \
		--xsl-user=$(XSLT)/hyphenation.xsl \
		--param=draft.mode=$(DRAFTMODE) \
		--param=format=a4 \
		--param=glossterm.auto.link=1 \
		--param=latex.encoding=utf8 \
		--param=latex.unicode.use=1 \
		--param=lingua=$* \
		--param=monoseq.hyphenation=nohyphen \
		--output=$@ -

#######################################################################
# Build xml/html(indexed) for testing source (local)                ALL
#######################################################################
# force rebuild when touched po file after asciidoc
.PHONY: new
new:
	$(MAKE) po
	$(MAKE) xml

#########################################################################
_ALL=en_US.UTF-8
#########################################################################
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
	$(MAKE) $(DOCNAME).en.xmlt
	$(GETTEXT) -p $(PODOC)/$(DOCNAME).pot -m $(DOCNAME).en.xmlt
	# repeat for all languages
	for $$xx in $(LANGPO) ; do \
	msguntypot -o $(PODOC)/$(DOCNAME).pot.old -n $(PODOC)/$(DOCNAME).pot $(PODOC)/$(DOCNAME).$$xx.po ;\
	done

# Used for forcing building PO files
FORCE:

