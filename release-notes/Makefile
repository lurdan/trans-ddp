#
# Makefile for the release notes, top-level
#

# comment out this line when the release notes should go into
# production mode
#DRAFT := 1

ifeq "$(DRAFT)" "1"
    draftmode := yes
else
    draftmode := maybe
endif

manual := release-notes

arches := $(shell grep '<phrase arch=' $(CURDIR)/$(manual).ent \
		| sed 's/.* arch=.\([a-z0-9-]*\).*/\1/' | sort -u)

ifeq "$(OFFICIALWEBBUILD)" "true"
  install_file	:= install -m 2664 -p
  makedir	:= mkdir -p -m 2775
else
  install_file	:= cp -pr 
  makedir	:= mkdir -p -m 0755
endif

# WARNING - Editors and translators: the LANGUAGES list is currently sorted
# alphabetically but *NEW* languages that somebody wants to start working in
# should go to the end, that way if the language fails to build, or has errors,
# the other languages are not affected
#
# TODO - Treat 'probationary' languages independently so that they if they
# break they do not break the build for stable translations
LANGUAGES := en da de es fr it ja pt-br pt ro ru sv sk pl

# The following is a list of 'probationary' languages, these might not yet
# build fine and might break the build.  Move them over to LANGUAGES when they
# do:
DISABLED_LANGUAGES := be ca cs lt ml nb nl vi zh-cn zh-tw
ALL_LANGUAGES := $(LANGUAGES) $(DISABLED_LANGUAGES)

# languages without .po files
# (either original English or translators don't like .po)
DBK_LANGUAGES := en ca cs
PO_LANGUAGES := $(filter-out $(DBK_LANGUAGES), $(ALL_LANGUAGES))
XMLROFF_LANGS=be ja ml vi zh-cn zh-tw
PO_FILES := $(wildcard */*.po)
DBK_FILES := $(wildcard $(patsubst %,%/*.dbk,$(DBK_LANGUAGES)))

# DISABLED_PDF are the languages we will not generate PDF versions for:
DISABLED_PDF=ja
# cairo backend of xmlroff 0.6.0 crashes on some languages (#492597)
GPLIST=ja ml vi

LANGUAGES-publish := $(addsuffix -publish,$(LANGUAGES))
LANGUAGES-clean := $(addsuffix -clean,$(LANGUAGES))

SOURCES := $(wildcard en/*.dbk)

# DocBook stuff
XP=xsltproc --nonet --novalid --xinclude \
    --stringparam draft.mode $(draftmode)
XL=xmllint --nonet --noout --postvalid --xinclude
# XSL files and parameters
# note: the URL is used as identifier, no HTTP is used!
DOCBOOK_XSL=http://docbook.sourceforge.net/release/xsl/current
# for HTML output
DBK2HTML=$(CURDIR)/html.xsl
# all in one file for text output
DBK2HTML1=$(CURDIR)/txt.xsl
#
# NOTE: to DEBUG the generation of PDFs use the '-d -V' switches
# in DBLATEX and review the temporary files generated for errors
DBLATEX=dblatex --backend=xetex --style=db2latex \
    --xslt-opts=--nonet --no-external \
    --xsl-user=hyphenation.xsl \
    --param=draft.mode=$(draftmode) \
    --param=format=a4 \
    --param=glossterm.auto.link=1 \
    --param=lingua=$(LINGUA) \
    --param=monoseq.hyphenation=nohyphen
PROFILE=$(DOCBOOK_XSL)/profiling/profile.xsl
PREPROC=$(CURDIR)/preproc.xsl
DBLATEXXSL=$(CURDIR)/dblatex.xsl
XMLROFF=xmlroff --backend cairo
XMLROFF_GP=xmlroff --backend gp

FORMATS=html txt pdf

# po4a stuff
# Mimic options that used to be hardcoded in local Locale::Po4a::Xml
PO4AOPTIONS=-o nodefault='<contrib> <editor> <indexterm> <note> <primary> <pubdate> <programlisting> <orderedlist> <screen>' -o translated='<contrib> <editor> W<programlisting> <note> <orderedlist> <pubdate> W<screen> <indexterm><primary>' -o inline='<indexterm> <primary>'
UPDATEPO=po4a-updatepo $(PO4AOPTIONS) --previous --format docbook
# The "--keep 0" should be removed as soon as the translations are ready
TRANSLATE=po4a-translate $(PO4AOPTIONS) --format docbook --keep 0

.SUFFIXES: 
.PHONY: publish all clean $(LANGUAGES-publish)

all: statistics.html
	for l in $(LANGUAGES); do \
	    for a in $(arches); do \
	        echo "Creating documents for $$a, language: $$l"; \
	        $(MAKE) LINGUA=$$l architecture=$$a $(FORMATS); \
	    done; \
	done

# TODO: Do not use 'set -e' here. if one of the files here is missing for one
# language due to a failed build the publish will break the publish for the
# other languages. 
# We could change this into a proper Makefile goal with its subtargets
# but it needs to be rewritten to do so
publish: statistics.html 
	@test -n "$(PUBLISHDIR)" || { echo "ERROR: Variable PUBLISHDIR undefined" && false ; }
	@test -d "$(PUBLISHDIR)" || { echo "ERROR: Publish dir '$(PUBLISHDIR)' does not exist" && false ; }
	@echo "Publishing to '$(PUBLISHDIR)'"
	$(install_file) statistics.html $(PUBLISHDIR)/; \
	echo "AddCharset UTF-8 .txt" > $(PUBLISHDIR)/.htaccess; \
	for arch in $(arches); do \
	  $(MAKE) architecture=$$arch; \
	  $(makedir) $(PUBLISHDIR)/$$arch/$(manual); \
	  $(makedir) $(manual)-$$arch; \
	  for lang in $(LANGUAGES); do \
	    $(makedir) $(manual)-$$arch/$$lang; \
	    [ ! -d  "$$lang/$(manual).$$arch.html/" ] || \
		$(install_file) $$lang/$(manual).$$arch.html/* \
		$(PUBLISHDIR)/$$arch/$(manual)/; \
		[ ! -e "$$lang/$(manual).$$arch.txt" ] ||  \
	    $(install_file) $$lang/$(manual).$$arch.txt \
		$(PUBLISHDIR)/$$arch/$(manual).$$lang.txt; \
		[ ! -e "$$lang/$(manual).$$arch.pdf" ] ||  \
	    $(install_file) $$lang/$(manual).$$arch.pdf \
		$(PUBLISHDIR)/$$arch/$(manual).$$lang.pdf; \
	    [ ! -d  "$$lang/$(manual).$$arch.html/" ] || \
	    $(install_file) $$lang/$(manual).$$arch.html/* \
		$(manual)-$$arch/$$lang/; \
		[ ! -e "$$lang/$(manual).$$arch.txt" ] ||  \
	    $(install_file) $$lang/$(manual).$$arch.txt \
		$(manual)-$$arch/$$lang/$(manual).$$lang.txt; \
		[ ! -e "$$lang/$(manual).$$arch.pdf" ] ||  \
	    $(install_file) $$lang/$(manual).$$arch.pdf \
		$(manual)-$$arch/$$lang/$(manual).$$lang.pdf ; \
	  done; \
	  for i in $(PUBLISHDIR)/$$arch/$(manual)/*.en.html; do \
	    ln -sf `basename $$i` $${i%.en.html}.html; \
	  done; \
	  if [ -n "$(PUBLISHTARBALL)" ]; then (cd $(manual)-$$arch \
		&& tar czf $(PUBLISHDIR)/$(manual)-$$arch.tar.gz *); fi \
	done

ifeq "$(architecture)" ""
$(FORMATS)::
	@echo "architecture variable must be set, try one of: $(arches)"
	exit 1
endif

ifdef LINGUA
html::	$(LINGUA)/$(manual).$(architecture).html/index.$(LINGUA).html
$(LINGUA)/$(manual).$(architecture).html/index.$(LINGUA).html: \
		$(LINGUA)/$(manual).$(architecture).xml html.xsl
	@test -d /usr/share/xml/docbook/stylesheet/nwalsh/images/  || { echo "ERROR: The Docbook stylesheet's images are not available. Please install the docbook-xsl package." ; false ; }
	mkdir -p $(LINGUA)/$(manual).$(architecture).html/images
	cp debian.css $(LINGUA)/$(manual).$(architecture).html
	cp /usr/share/xml/docbook/stylesheet/nwalsh/images/*.png \
	    $(LINGUA)/$(manual).$(architecture).html/images
	cd $(LINGUA) && $(XP) -o $(manual).$(architecture).html/ \
	    --stringparam html.ext .$(LINGUA).html \
	    $(DBK2HTML) $(manual).$(architecture).xml

pdf::	$(LINGUA)/$(manual).$(architecture).pdf
ps::	$(LINGUA)/$(manual).$(architecture).ps
ifneq "$(filter $(XMLROFF_LANGS),$(LINGUA))" ""
$(LINGUA)/$(manual).$(architecture).pdf: \
		$(LINGUA)/$(manual).$(architecture).fo
$(LINGUA)/$(manual).$(architecture).ps: \
		$(LINGUA)/$(manual).$(architecture).fo
$(LINGUA)/$(manual).$(architecture).fo: \
		$(LINGUA)/$(manual).$(architecture).xml fo.xsl
else
$(LINGUA)/$(manual).$(architecture).pdf: \
		$(LINGUA)/$(manual).$(architecture).xml
$(LINGUA)/$(manual).$(architecture).ps: \
		$(LINGUA)/$(manual).$(architecture).xml
endif

ifneq "$(filter $(DISABLED_PDF),$(LINGUA))" ""
%.pdf: %.xml
	echo "PDF for $$LINGUA currently disabled." > $@
else
ifneq "$(filter $(XMLROFF_LANGS),$(LINGUA))" ""
%.fo: %.xml xmlroff.xsl
	$(XP) xmlroff.xsl $< |$(XP) --output $@ fo.xsl -

%.pdf: %.fo
	@test -n "`which xmlroff`"  || { echo "ERROR: xmlroff not found. Please install the xmlroff package." ; false ;  }
	USE_GP=`echo " $(GPLIST) " | grep " $$LINGUA "`; \
	if [ -n "$$USE_GP" ]; then \
	    $(XMLROFF_GP) -o $@ $<; \
	else \
	    $(XMLROFF) -o $@ $<; \
	fi
else
%.pdf: %.xml
	@test -n "`which dblatex`"  || { echo "ERROR: dblatex not found. Please install the dblatex package." ; false ;  }
	export TEXINPUTS="$$(pwd)/$(@D):"; \
	$(XP) $(DBLATEXXSL) $< | $(DBLATEX) --output=$@ -
endif
endif

ifneq "$(filter $(XMLROFF_LANGS),$(LINGUA))" ""
# Can't we just drop PS in favour of PDF?
%.ps: %.fo
	@test -n "`which xmlroff`"  || { echo "ERROR: xmlroff not found. Please install the xmlroff package." ; false ;  }
	USE_GP=`echo " $(GPLIST) " | grep " $$LINGUA "`; \
	if [ -n "$$USE_GP" ]; then \
	    $(XMLROFF_GP) --format postscript -o $@ $<; \
	else \
	    $(XMLROFF) --format postscript -o $@ $<; \
	fi
else
%.ps: %.xml
	@test -n "`which dblatex`"  || { echo "ERROR: dblatex not found. Please install the dblatex package." ; false ;  }
	export TEXINPUTS="$$(pwd)/$(@D):"; \
	$(XP) $(DBLATEXXSL) $< | $(DBLATEX) --output=$@ --ps -
endif

txt::	$(LINGUA)/$(manual).$(architecture).txt
$(LINGUA)/$(manual).$(architecture).txt: \
		$(LINGUA)/$(manual).$(architecture).xml txt.xsl
	@test -n "`which xsltproc`"  || { echo "ERROR: xsltproc not found. Please install the xsltproc package." ; false ;  }
	@test -n "`which w3m`"  || { echo "ERROR: w3m not found. Please install the w3m package." ; false ;  }
	$(XP) $(DBK2HTML1) $< \
	    | w3m -o display_charset=UTF-8 -cols 70 -dump -no-graph -T text/html > $@

# profiling for architecture, needed by all output formats
condition := ;
ifeq "$(DRAFT)" "1"
    condition := fixme
endif
space := $(undef) $(undef)
semic := $(undef);$(undef)
otherarchs := $(subst  $(space),$(semic), \
	$(addprefix not-,$(filter-out $(architecture),$(arches))))
ifneq "$(filter $(architecture),i386 amd64 powerpc)" ""
    condition := $(condition);g-i
endif

ifneq "$(filter $(architecture),mips mipsel)" ""
    initrd := $(condition);no-initrd
else
    initrd := $(condition);uses-initrd
endif
# differentiate Linux and non-Linux archs
ifneq "$(filter $(architecture),kfreebsd-i386 kfreebsd-amd64)" ""
    otherarchs := $(otherarchs);not-linux
else
    otherarchs := $(otherarchs);linux
endif
# pseudo-arch "all" to include all text, e.g. for proof-reading
ifeq "$(architecture)" "all"
    otherarchs := ;$(subst  $(space),$(semic),$(arches) linux not-linux)$(otherarchs)
    condition := $(condition);g-i;no-initrd;
endif

$(LINGUA)/$(manual).$(architecture).xml: \
		$(patsubst en/%,$(LINGUA)/%,$(SOURCES)) $(manual).ent
	$(XP) --stringparam profile.arch "$(architecture)$(otherarchs)" \
	      --stringparam profile.condition "$(condition)" \
	    $(PROFILE) $(@D)/$(manual).dbk | $(XP) $(PREPROC) - > $@
endif

FORCE:

# There must be an easier way than recursive make!
.PRECIOUS:		%.dbk
ifndef LINGUA
%.dbk: FORCE
	$(MAKE) $@ LINGUA=`basename $(@D)`

else
ifeq "$(findstring  $(LINGUA) , $(DBK_LANGUAGES) )" ""
$(LINGUA)/%.dbk:	en/%.dbk $(LINGUA)/%.po
	@test -n "`which po4a`"  || { echo "ERROR: po4a not found. Please install the po4a package." ; false ;  }
	$(TRANSLATE) --master $< --po $(@:.dbk=.po) --localized $@
endif
endif

ifdef LINGUA
.PHONY:	updatepo
update-po: updatepo
updatepo:	$(patsubst en/%.dbk,$(LINGUA)/%.po-force,$(wildcard en/*.dbk))
# The next is just a PHONY target and forcible updates the PO files
$(LINGUA)/%.po-force: FORCE
	$(UPDATEPO) --master en/$*.dbk --po $(LINGUA)/$*.po

validate:	$(patsubst en/%,$(LINGUA)/%,$(SOURCES))
	$(XL) $(LINGUA)/$(manual).dbk
endif

tidypo:
ifdef LINGUA
	for po in $(wildcard $(LINGUA)/*.po); do \
	    msgcat $$po > $$po.tmp && mv $$po.tmp $$po; \
	done
else
	for po in $(wildcard */*.po); do \
	    msgcat $$po > $$po.tmp && mv $$po.tmp $$po; \
	done
endif

ifndef LINGUA

# Iterate over all PO based languages only
updatepo:
	for l in $(PO_LANGUAGES); do \
	    $(MAKE) $@ LINGUA=$$l; \
	done

%:
	for l in $(LANGUAGES); do \
	    $(MAKE) $@ LINGUA=$$l; \
	done
endif

clean::
	rm -f relnotes.tar.bz2 statistics.txt statistics.html messages.mo
	find -maxdepth 1 -name '$(manual)-*' -type d -exec rm -fr {} \;
clean:: $(LANGUAGES-clean)

$(LANGUAGES-clean):
	LINGUA=$(subst -clean,,$@); \
	cd $$LINGUA; \
	echo " $(DBK_LANGUAGES) " | grep -q " $$LINGUA " || rm -f *.dbk; \
	rm -rf *~ .*~ $(manual).*.html $(manual).*.txt $(manual).*.pdf \
	    $(manual).*.ps $(manual).*.xml ifxetex.sty body.tmp head.tmp \
	    release-notes.*.tpt release-notes.*.fo

printarches:
	@echo $(arches)

statistics.txt: $(PO_FILES) $(DBK_FILES)
	( \
	    LANG=C; export LANG; \
	    for l in $(PO_LANGUAGES); do \
		echo -n "$$l: "; \
	        msgcat --use-first $$l/*.po | msgfmt --statistics - 2>&1 ; \
	    done; \
	) > $@
	LANG=C ./transcount $(DBK_LANGUAGES) >> $@

statistics.html: statistics.txt
	./statspage $< > $@
