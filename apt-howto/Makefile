#
# Makefile for the APT-HOWTO
#
# stolen from maint-guide =)
#

MANUAL := $(shell echo $(notdir $(CURDIR)) | perl -pe 's/-[\d.]+$$//')

# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html

all: html txt ps

# generating HTML
html: $(patsubst %.sgml,%.html/index.html,$(wildcard *.sgml))

$(MANUAL)-%.html/index.html: $(MANUAL)-%.sgml
	debiandoc2html -c -l $* $<

# generating plain text
txt text: $(patsubst %.sgml,%.txt,$(wildcard *.sgml))

$(MANUAL)-%.txt: $(MANUAL)-%.sgml
	debiandoc2text -l $* $<

# generating PostScript
ps: $(patsubst %.sgml,%.ps,$(wildcard *.sgml))

$(MANUAL)-%.ps: $(MANUAL)-%.sgml
	debiandoc2latexps -l $* $<

# publishing to the DDP web pages
publish: html
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	install -p -m 644 $(MANUAL)*.html/*.html $(PUBLISHDIR)/$(MANUAL)/

# validating SGML
validate:
	set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

# cleaning up
clean distclean:
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*} *~
	rm -rf $(MANUAL)*.html

.PHONY: all publish clean distclean validate
