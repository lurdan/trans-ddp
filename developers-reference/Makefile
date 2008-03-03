# Makefile, used for the developers-reference in DocBook XML

# Note: This Makefile should work perfectly without the debian/ directory.

SOURCES		:= $(wildcard *.dbk) common.ent version.ent

FORMATS		:= html txt pdf
LANGS           := fr ja
TARGETS		:= $(foreach fmt,$(FORMATS),developers-reference.$(fmt)) \
		   $(foreach lng,$(LANGS), \
		       $(foreach fmt,$(FORMATS), \
		           $(lng)/developers-reference.$(fmt)))
# list of targets, that currently cannot build
BLACKLIST	:= ja/developers-reference.pdf

# hopefully overwritten by caller, e.g. debian/rules
VERSION=unknown
PUBDATE=unknown

# programs for creating output
XP=xsltproc --nonet --novalid --xinclude
XL=xmllint --nonet --noout --postvalid --xinclude
# dblatex 0.2.8 has some problems (e.g. #465221 and Japanese does
# not build)
# Alternatives:
# - docbook2pdf (seems to die on UTF-8, #431085); and
# - fop is currently in contrib, but can go to main, see #366783
# - xmlroff (not mature enough, #182445)
DBLATEX=dblatex --style=db2latex
# The "--keep 0" should be removed as soon as the translations are ready
TRANSLATE=po4a-translate --format docbook --keep 0

# XSL files and parameters
# note: the URL is used as identifier, no HTTP is used!
DOCBOOK_XSL=http://docbook.sourceforge.net/release/xsl/current
# for HTML output
DBK2HTML=$(CURDIR)/html.xsl
# all in one file for text output
DBK2HTML1=$(CURDIR)/txt.xsl

.PHONY:	all
all:    $(filter-out $(BLACKLIST), $(TARGETS))

.PHONY: validate
validate:			$(SOURCES)
	$(XL) index.dbk

%/validate:			$(addprefix %/,$(SOURCES))
	cd $(@D) && $(XL) index.dbk

.PHONY: developers-reference.html %/developers-reference.html
developers-reference.html:	$(CURDIR)/index.html
%/developers-reference.html:	$(addprefix %/,index.html)
	@true

.PRECIOUS:			%/index.html
index.html:			$(CURDIR)/developers-reference.html
%/index.html:			$(addprefix %/,$(SOURCES))
	cd $(@D) && $(XP) $(DBK2HTML) index.dbk

# There must be an easier way than recursive make!
.PRECIOUS:		%.dbk %.ent
ifndef LINGUA
%.dbk %.ent: FORCE
	$(MAKE) $@ LINGUA=`basename $(@D)`

FORCE:
else
$(LINGUA)/%.dbk:	%.dbk $(patsubst %.dbk,po4a/$(LINGUA)/%.po,%.dbk)
	$(TRANSLATE) -m $< -p po4a/$(@:.dbk=.po) -l $@

$(LINGUA)/common.ent:	common.ent
	cd $(@D) && ln -sf ../$(@F) .
endif

developers-reference.txt:	$(CURDIR)/developers-reference.txt
%/developers-reference.txt:	$(addprefix %/,$(SOURCES))
	$(XP) $(DBK2HTML1) $(@D)/index.dbk \
	    | w3m -cols 65 -dump -T text/html > $@

developers-reference.pdf:       $(CURDIR)/developers-reference.pdf
%/developers-reference.pdf:     $(addprefix %/,$(SOURCES))
	TOP=`pwd` && cd $(@D) && $(DBLATEX) index.dbk \
	    && mv index.dbk.pdf $(@F)

.PHONY: pot
pot:				$(patsubst %.dbk,po4a/po/%.pot,$(SOURCES))
po4a/po/%.pot:			%.dbk
	po4a-gettextize --format docbook --master $< --po $@

ifdef LINGUA
.PHONY: updatepo
updatepo:			$(patsubst %.dbk,po4a/$(LINGUA)/%.po,$(SOURCES))
po4a/$(LINGUA)/%.po:		%.dbk
	po4a-updatepo --format docbook --master $< --po $@
endif

%/version.ent:
	echo '<!ENTITY version "$(VERSION)">' >  $@
	echo '<!ENTITY pubdate "$(PUBDATE)">' >> $@

.PHONY: clean
clean:
	rm -f *.fo *.html *.pdf *.txt
	for L in $(LANGS); do rm -rf `basename ./"$$L"/`; done
	rm -f version.ent
	rm -f `find . -name "*~" -o -name "*.bak"`
	rm -f *~ *.bak .#* core

.PHONY: distclean
distclean: clean
	rm -f *.rej *.orig

# if rule bomb out, delete the target
.DELETE_ON_ERROR:
