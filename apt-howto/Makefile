#
# Makefile for the APT HOWTO
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for $(MANUAL) package build.

# increase pool size for Korean documents in Woody
export TEXMFCNF=../quick-reference/texmf:

export PATH:=../quick-reference/bin/:${PATH}

# Basename for SGML
MANUAL := $(shell echo $(notdir $(CURDIR)) | perl -pe 's/-[\d.]+$$//')

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
	  langbar=`echo $$lang | perl -pe 's/(\w\w)-(\w\w)/"$$1_".uc($$2)/e'`; \
	  if [ $$i -nt $(MANUAL).$$lang.html/index.$$langfoo.html ]; then \
            echo debiandoc2html -c -l $$langbar $$i "($$langfoo)"; \
            debiandoc2html -c -l $$langbar $$i; \
          fi; \
	done

# generating plain text
txt text: $(patsubst %.sgml,%.txt,$(wildcard *.??*.sgml))

$(MANUAL).pt-br.txt: $(MANUAL).pt-br.sgml
	debiandoc2text -l pt_BR $<

$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $* $<

# generating PostScript
#texfriendly := $(filter-out $(MANUAL).ko.sgml,$(wildcard *.??*.sgml))
texfriendly := $(wildcard *.??*.sgml)
ps: $(patsubst %.sgml,%.ps,$(texfriendly))

$(MANUAL).pt-br.ps: $(MANUAL).pt-br.sgml
	debiandoc2latexps -l pt_BR $<

$(MANUAL).el.ps: $(MANUAL).el.sgml
	@echo Locale 'el' not yet supported
	
$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $* $<

# generating Portable Document Format
pdf: $(patsubst %.sgml,%.pdf,$(texfriendly))

$(MANUAL).pt-br.pdf: $(MANUAL).pt-br.sgml
	debiandoc2latexpdf -l pt_BR $<

$(MANUAL).el.pdf: $(MANUAL).el.sgml
	@echo Locale 'el' not yet supported
	
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
