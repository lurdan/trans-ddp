#
# Makefile for the Debian New Maintainers' Guide
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for $(MANUAL) package build.

# Basename for SGML
MANUAL := $(shell echo $(notdir $(CURDIR)) | perl -pe 's/-[\d.]+$$//')

# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

all: html txt ps pdf

sources := $(wildcard *.??*.sgml)
sources_noncjk := $(filter-out maint-guide.zh_CN.sgml,$(filter-out maint-guide.ja.sgml,$(filter-out maint-guide.ko.sgml,$(sources))))

# generating HTML
# ugly because the normal stuff works only as PHONYs. :(
#$(MANUAL).%.html/index.%.html: $(MANUAL).%.sgml
#	debiandoc2html -c -l $* $<
html:
	rm -rf *html
	@if /usr/bin/test \( ! -e $(MANUAL).en.html/index.en.html \) -o \( $(MANUAL).sgml -nt $(MANUAL).en.html/index.en.html \); then \
          echo debiandoc2html -c -l en $(MANUAL).sgml; \
          debiandoc2html -c -l en $(MANUAL).sgml; \
          mv $(MANUAL).html $(MANUAL).en.html; \
        fi
	@for i in *.??*.sgml; do \
          j=$${i#$(MANUAL).}; lang=$${j%.sgml}; \
	  if /usr/bin/test \( ! -e $(MANUAL).$$lang.html/index.$$lang.html \) -o \( $$i -nt $(MANUAL).$$lang.html/index.$$lang.html \); then \
            echo debiandoc2html -c -l $$lang $$i; \
            debiandoc2html -c -l $$lang $$i; \
          fi; \
        done

# generating plain text
txt text: $(MANUAL).en.txt $(patsubst %.sgml,%.txt,$(sources))

$(MANUAL).en.txt: $(MANUAL).sgml
	debiandoc2text -l en $<
	mv $(MANUAL).txt $(MANUAL).en.txt

$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $* $<

# generating PostScript
ps: $(MANUAL).en.ps $(patsubst %.sgml,%.ps,$(sources_noncjk))

$(MANUAL).en.ps: $(MANUAL).sgml
	debiandoc2latexps -l en $<
	mv $(MANUAL).ps $(MANUAL).en.ps

$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $* $<

# generating Portable Document Format
pdf: $(MANUAL).en.pdf $(patsubst %.sgml,%.pdf,$(sources_noncjk))

$(MANUAL).en.pdf: $(MANUAL).sgml
	debiandoc2latexpdf -l en $<
	mv $(MANUAL).pdf $(MANUAL).en.pdf

$(MANUAL).%.pdf: $(MANUAL).%.sgml
	debiandoc2latexpdf -l $* $<

# publishing to the DDP web pages
publish: all
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	install -p -m 644 $(MANUAL)*.html/*.html $(PUBLISHDIR)/$(MANUAL)/
# possible non-POSIX syntax below. fuck POSIX.
	cd $(PUBLISHDIR)/$(MANUAL) && for file in *.en.html; do \
          ln -s $$file $${file%$${file#$${file%.en.html}}}.html; \
        done
	install -p -m 644 $(MANUAL)*.txt $(MANUAL)*.ps $(MANUAL)*.pdf $(PUBLISHDIR)/$(MANUAL)
	ln -sf $(MANUAL).en.txt $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).txt
	ln -sf $(MANUAL).en.ps $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).ps
	ln -sf $(MANUAL).en.pdf $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).pdf

# validating SGML
validate:
	@set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

# cleaning up
clean distclean:
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,out,sasp*,tpt} *~
	rm -rf $(MANUAL)*.html

.PHONY: all publish clean distclean validate
.SUFFIXES:
