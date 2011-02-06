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

# TODO: Once #477458 is fixed in stable remove all committed sgml files
# which are generated from a PO file (was a workaround for old po4a).

manual := release-notes

arches := $(shell grep '<phrase arch=' $(CURDIR)/$(manual).ent \
		| sed 's/.* arch=.\([a-z0-9]*\).*/\1/' | sort -u)

ifeq "$(OFFICIALWEBBUILD)" "true"
  install_file	:= install -m 2664 -p
  makedir	:= mkdir -p -m 2775
else
  install_file	:= cp -pr 
  makedir	:= mkdir -p -m 0755
endif

LANGUAGES := en cs de es fr it ja lt ml nb nl pt_BR pt ro ru sk sv vi zh_CN zh_TW be ca da
# languages without .po files
# (either original English or translators don't like .po)
DBK_LANGUAGES := en ca cs pt_BR
PO_LANGUAGES := $(filter-out $(DBK_LANGUAGES), $(LANGUAGES))
XMLROFF_LANGS=be ja ml pl vi zh_CN zh_TW
DISABLED_PDF=
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
DBLATEX=dblatex --style=db2latex \
    --xslt-opts=--nonet --no-external \
    --xsl-user=hyphenation.xsl \
    --param=draft.mode=$(draftmode) \
    --param=format=a4 \
    --param=glossterm.auto.link=1 \
    --param=latex.encoding=utf8 \
    --param=latex.unicode.use=1 \
    --param=lingua=$(LINGUA) \
    --param=monoseq.hyphenation=nohyphen
PROFILE=$(DOCBOOK_XSL)/profiling/profile.xsl
PREPROC=$(CURDIR)/preproc.xsl
DBLATEXXSL=$(CURDIR)/dblatex.xsl
XMLROFF=xmlroff --backend cairo
XMLROFF_GP=xmlroff --backend gp

FORMATS=html txt pdf

# po4a stuff
UPDATEPO=PERLLIB=lib/ PERL5LIB=lib/ po4a-updatepo --previous --format docbook
# The "--keep 0" should be removed as soon as the translations are ready
TRANSLATE=PERLLIB=lib/ po4a-translate --format docbook --keep 0

.SUFFIXES: 
.PHONY: publish all clean $(LANGUAGES-publish)

all: statistics.html
	for l in $(LANGUAGES); do \
	    for a in $(arches); do \
	        echo "Creating documents for $$a, language: $$l"; \
	        $(MAKE) LINGUA=$$l architecture=$$a $(FORMATS); \
	    done; \
	done

publish: statistics.html
	set -ex; \
	$(install_file) statistics.html $(PUBLISHDIR)/; \
	echo "AddCharset UTF-8 .txt" > $(PUBLISHDIR)/.htaccess; \
	for arch in $(arches); do \
	  $(MAKE) architecture=$$arch; \
	  $(makedir) $(PUBLISHDIR)/$$arch/$(manual); \
	  $(makedir) $(manual)-$$arch; \
	  for lang in $(LANGUAGES); do \
	    $(makedir) $(manual)-$$arch/$$lang; \
	    $(install_file) $$lang/$(manual).$$arch.html/* \
		$(PUBLISHDIR)/$$arch/$(manual)/; \
	    $(install_file) $$lang/$(manual).$$arch.txt \
		$(PUBLISHDIR)/$$arch/$(manual).$$lang.txt; \
	    $(install_file) $$lang/$(manual).$$arch.pdf \
		$(PUBLISHDIR)/$$arch/$(manual).$$lang.pdf; \
	    $(install_file) $$lang/$(manual).$$arch.html/* \
		$(manual)-$$arch/$$lang/; \
	    $(install_file) $$lang/$(manual).$$arch.txt \
		$(manual)-$$arch/$$lang/$(manual).$$lang.txt; \
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
%.fo: %.xml
	$(XP) -o $@ fo.xsl $<

%.pdf: %.fo
	USE_GP=`echo " $(GPLIST) " | grep " $$LINGUA "`; \
	if [ -n "$$USE_GP" ]; then \
	    $(XMLROFF_GP) -o $@ $<; \
	else \
	    $(XMLROFF) -o $@ $<; \
	fi
else
%.pdf: %.xml
	export TEXINPUTS="$$(pwd)/$(@D):"; \
	$(XP) $(DBLATEXXSL) $< | $(DBLATEX) --output=$@ -
endif
endif

ifneq "$(filter $(XMLROFF_LANGS),$(LINGUA))" ""
# Can't we just drop PS in favour of PDF?
%.ps: %.fo
	USE_GP=`echo " $(GPLIST) " | grep " $$LINGUA "`; \
	if [ -n "$$USE_GP" ]; then \
	    $(XMLROFF_GP) --format postscript -o $@ $<; \
	else \
	    $(XMLROFF) --format postscript -o $@ $<; \
	fi
else
%.ps: %.xml
	export TEXINPUTS="$$(pwd)/$(@D):"; \
	$(XP) $(DBLATEXXSL) $< | $(DBLATEX) --output=$@ --ps -
endif

txt::	$(LINGUA)/$(manual).$(architecture).txt
$(LINGUA)/$(manual).$(architecture).txt: \
		$(LINGUA)/$(manual).$(architecture).xml txt.xsl
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
# pseudo-arch "all" to include all text, e.g. for proof-reading
ifeq "$(architecture)" "all"
    otherarchs := ;$(subst  $(space),$(semic),$(arches))$(otherarchs)
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
	$(TRANSLATE) --master $< --po $(@:.dbk=.po) --localized $@
endif
endif

ifdef LINGUA
.PHONY:	updatepo
update-po: updatepo
updatepo:	$(patsubst en/%.dbk,$(LINGUA)/%.po-force,$(wildcard en/*.dbk))
# The next is just a PHONY target and forcible updates the PO files
#
# Note to translators: For the time begin: we can only work with po4a 0.34-2
# because that one is the one available at www-master. Different po4a bring
# different behaviours so if you are in sid please downgrade to this version
# (and put it on hold) so that you get the "right" PO files.
$(LINGUA)/%.po-force: FORCE
	@po4a_version=$$(dpkg-query -W -f '$${Version}\n' po4a); \
	if [ "$$po4a_version" != "0.34-2" ]; then \
	    echo "po4a version: '$$po4a_version'"; \
	    echo ""; \
	    echo "PO files must be updated with po4a 0.34-2 (Lenny)!"; \
	    echo ""; \
	    exit 1; \
	fi
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

.PHONY: statistics.txt
statistics.txt:
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
