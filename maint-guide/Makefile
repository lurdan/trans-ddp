#
# Makefile for the Debian New Maintainers' Guide
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for maint-guide package build.

# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html

all: html txt ps

# generating HTML
html: $(patsubst %.sgml,%.html/index.html,$(wildcard *.sgml))

maint-guide.html/index.html: maint-guide.sgml
	debiandoc2html $<

maint-guide.%.html/index.html: maint-guide.%.sgml
	debiandoc2html -c -l $* $<

# generating plain text
txt text: $(patsubst %.sgml,%.txt,$(wildcard *.sgml))

maint-guide.txt: maint-guide.sgml
	debiandoc2text $<

maint-guide.%.txt: maint-guide.%.sgml
	debiandoc2text -l $* $<

# generating PostScript
ps: maint-guide.ps

maint-guide.ps: maint-guide.sgml
	debiandoc2latexps $<

# publishing to the DDP web pages
publish: html
	test -d $(PUBLISHDIR)/maint-guide || install -d -m 755 $(PUBLISHDIR)/maint-guide
	rm -f $(PUBLISHDIR)/maint-guide/*.html
	install -p -m 644 maint-guide*.html/*.html $(PUBLISHDIR)/maint-guide/

# validating SGML
validate:
	set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

# cleaning up
clean distclean:
	rm -f maint-guide*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*} *~
	rm -rf maint-guide*.html

.PHONY: all publish clean distclean validate
