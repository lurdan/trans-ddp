#
# Makefile for the Debian New Maintainers' Guide
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for maint-guide package build.

MANUAL := $(shell echo $(notdir $(CURDIR)) | perl -pe 's/-[\d.]+$$//')

# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html

all: html txt ps

# generating HTML
html: $(MANUAL).en.html/index.en.html \
  $(patsubst maint-guide.%.sgml,maint-guide.%.html/index.%.html,$(wildcard *.??.sgml))

$(MANUAL).en.html/index.en.html: $(MANUAL).sgml
	debiandoc2html -c -l en $<

$(MANUAL).%.html/index.%.html: $(MANUAL).%.sgml
	debiandoc2html -c -l $* $<

# generating plain text
txt text: $(MANUAL).en.txt $(patsubst %.sgml,%.txt,$(wildcard *.??.sgml))

$(MANUAL).en.txt: $(MANUAL).sgml
	debiandoc2text -l en $<

$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $* $<

# generating PostScript
ps: $(MANUAL).ps

$(MANUAL).ps: $(MANUAL).sgml
	debiandoc2latexps $<

# publishing to the DDP web pages
publish: html
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	install -p -m 644 $(MANUAL)*.html/*.html $(PUBLISHDIR)/$(MANUAL)/
	cd $(PUBLISHDIR)/$(MANUAL) && for i in *.en.html; do \
	  file=$$i; ln -s $$i $${file/.en/}; done

# validating SGML
validate:
	set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

# cleaning up
clean distclean:
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*} *~
	rm -rf $(MANUAL)*.html

.PHONY: all publish clean distclean validate
