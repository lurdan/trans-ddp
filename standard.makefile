#
# Standard Debian Documentation Project Makefile
#
# Should work both for a manual in the DDP CVS tree, and for a package build.

# Basename for SGML
MANUAL := $(notdir $(CURDIR))

# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

all: html txt ps pdf

# generating HTML
# ugly because the normal stuff works only as PHONYs. :(
#$(MANUAL).%.html/index.%.html: $(MANUAL).%.sgml
#	debiandoc2html -c -l $* $<
html:
	@for i in *.??*.sgml; do \
          j=$${i#$(MANUAL).}; lang=$${j%.sgml}; \
          langfoo=`echo $$lang | tr 'A-Z_' 'a-z-'`; \
	  if [ $$i -nt $(MANUAL).$$lang.html/index.$$langfoo.html ]; then \
            echo debiandoc2html -c -l $$lang $$i "($$langfoo)"; \
            debiandoc2html -c -l $$lang $$i; \
          fi; \
        done

# generating plain text
txt text: $(patsubst %.sgml,%.txt,$(wildcard *.??*.sgml))

$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $* $<

# generating PostScript
texfriendly := $(filter-out $(MANUAL).ko.sgml,$(filter-out $(MANUAL).ja.sgml,$(wildcard *.??*.sgml)))
ps: $(patsubst %.sgml,%.ps,$(texfriendly))

$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $* $<

# generating Portable Document Format
pdf: $(patsubst %.sgml,%.pdf,$(texfriendly))

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
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,out,sasp*} *~
	rm -rf $(MANUAL)*.html

.PHONY: all publish clean distclean validate
.SUFFIXES:
