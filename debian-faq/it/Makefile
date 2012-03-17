#
# Makefile for the Debian FAQ
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for doc-debian package build.

manual := debian-faq

currentlang := $(notdir $(CURDIR))
currentlangcn := $(subst _,-,$(shell echo $(currentlang) | tr A-Z a-z))

# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

sources := $(manual).sgml faqstatic.ent ../faqdynamic.ent $(wildcard *.sgml)

export LANG=C
# stupid debiandoc stuff uses strings in another language otherwise

all: html text ps pdf

publish: all
	test -d $(PUBLISHDIR)/$(manual) || install -d -m 755 $(PUBLISHDIR)/$(manual)
	rm -f $(PUBLISHDIR)/$(manual)/*.$(currentlangcn).html
	install -p -m 644 $(manual).$(currentlang).html/*.html $(PUBLISHDIR)/$(manual)
	install -p -m 644 $(manual)*.txt $(manual)*.ps $(manual)*.pdf $(PUBLISHDIR)/$(manual)

faqstatic.ent:
	ln -sf ../$@ .

../faqdynamic.ent:
	cd .. && $(MAKE) faqdynamic.ent

validate:
	nsgmls -ges -wall $(manual).sgml

html: $(manual).$(currentlang).html/index.$(currentlangcn).html
$(manual).$(currentlang).html/index.$(currentlangcn).html: $(sources)
	rm -rf $(manual).html $(manual).$(currentlang).html
	debiandoc2html -C -l $(currentlang).UTF-8 $<
	mv $(manual).html $(manual).$(currentlang).html

text: $(manual).$(currentlang).txt
$(manual).$(currentlang).txt: $(sources)
	debiandoc2text -l $(currentlang).UTF-8 $<
	mv $(manual).txt $(manual).$(currentlang).txt

$(manual).$(currentlang).info: $(sources)
	debiandoc2info -l $(currentlang).UTF-8 $<
# TODO: rename to .$(currentlang).info?

$(manual).$(currentlang).ps $(manual).$(currentlang).dvi $(manual).$(currentlang).pdf: \
  $(manual).$(currentlang).%: $(sources)
	debiandoc2latex$* -l $(currentlang).UTF-8 $<
	mv $(manual).$* $(manual).$(currentlang).$*

ps dvi pdf info: %: $(manual).$(currentlang).%

clean distclean:
	rm -rf $(manual)*.$(currentlang).html
	rm -f $(manual)*
	rm -f *~ .*~ core tsa*

.PHONY: all publish clean distclean validate
