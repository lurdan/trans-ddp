# Makefile, used for the developers-reference in DocBook XML

# Note: This Makefile should work perfectly without the debian/ directory.

SOURCES		:= $(wildcard *.dbk) common.ent version.ent

FORMATS		:= html txt pdf epub
LANGS           := de fr ja
TARGETS		:= $(foreach fmt,$(FORMATS),developers-reference.$(fmt)) \
		   $(foreach lng,$(LANGS), \
		       $(foreach fmt,$(FORMATS), \
		           $(lng)/developers-reference.$(fmt)))
# list of targets, that currently cannot build
#BLACKLIST	:= ja/developers-reference.pdf

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
TRANSLATE=po4a po4a/po4a.cfg

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

# This rule controls the build and installation on the website
# Logs are here: http://www-master.debian.org/build-logs/ddp/
.PHONY: publish
publish:	all
	[ -d $(PUBLISHDIR) ] || exit 1
	install -d -m 755 $(PUBLISHDIR)/developers-reference
	rm -f $(PUBLISHDIR)/developers-reference/*.html
	rm -f en && ln -sf . en
	$(foreach format,$(FORMATS),$(foreach lang,en $(LANGS),for file in $(lang)/*.$(format); do if [ -e "$$file" ]; then cp --preserve=timestamps $$file $(PUBLISHDIR)/developers-reference/$$(basename $$file .$(format)).$(lang).$(format); fi; done;))
	ln -sf index.en.html $(PUBLISHDIR)/developers-reference/index.html
	ln -sf developers-reference.en.pdf $(PUBLISHDIR)/developers-reference/developers-reference.pdf
	ln -sf developers-reference.en.txt $(PUBLISHDIR)/developers-reference/developers-reference.txt
	ln -sf developers-reference.en.epub $(PUBLISHDIR)/developers-reference/developers-reference.epub

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
	$(TRANSLATE)
	$(MAKE) $@ LINGUA=`basename $(@D)`

FORCE:
else
$(LINGUA)/%.dbk:	%.dbk po4a/$(LINGUA).po
	$(TRANSLATE)

$(LINGUA)/common.ent:	common.ent
	cd $(@D) && ln -sf ../$(@F) .
endif

developers-reference.txt:	$(CURDIR)/developers-reference.txt
%/developers-reference.txt:	$(addprefix %/,$(SOURCES))
	$(XP) $(DBK2HTML1) $(@D)/index.dbk \
	    | LC_ALL=C.UTF-8 w3m -o display_charset=UTF-8 -cols 70 -dump -no-graph -T text/html > $@

XSLT		:= xslt

developers-reference.pdf:       $(CURDIR)/developers-reference.pdf
%/developers-reference.pdf:     $(addprefix %/,$(SOURCES))
	$(DBLATEX) $(@D)/index.dbk \
	    --backend=xetex \
	    --xsl-user=$(XSLT)/user_param.xsl \
	    --xsl-user=$(XSLT)/xetex_param.xsl \
	    --param=lingua=$(@D) \
	    && mv $(@D)/index.dbk.pdf $@

developers-reference.epub:      $(CURDIR)/developers-reference.epub
%/developers-reference.epub:     $(addprefix %/,$(SOURCES))
	TOP=`pwd` && cd $(@D) && xmlto epub index.dbk && mv index.epub $(@F)

.PHONY: pot
pot:					po4a/po/developers-reference.pot
po4a/po/developers-reference.pot:	%.dbk
	$(TRANSLATE)

ifdef LINGUA
.PHONY: updatepo
updatepo:			po4a/po/$(LINGUA).po
po4a/po/$(LINGUA).po:		%.dbk
	$(TRANSLATE)
endif

tidypo:
	for po in po4a/po/*.po; do \
	    msgcat -o $$po $$po; \
	done

checkpo:
	@for po in po4a/po/*.po; do \
	    msgfmt -vv $$po; \
	done

%/version.ent:
	echo '<!ENTITY version "$(VERSION)">' >  $@
	echo '<!ENTITY pubdate "$(PUBDATE)">' >> $@

.PHONY: clean
clean:
	rm -f *.fo *.html *.pdf *.txt *.epub
	for L in $(LANGS); do rm -rf `basename ./"$$L"/`; done
	rm -f version.ent
	rm -f `find . -name "*~" -o -name "*.bak"`
	rm -f *~ *.bak .#* core

.PHONY: distclean
distclean: clean
	rm -f *.rej *.orig

# if rule bomb out, delete the target
.DELETE_ON_ERROR:
