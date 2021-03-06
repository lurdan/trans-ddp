#
# Makefile for the Debian History
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for $(MANUAL) package build.

# Basename for SGML
MANUAL := project-history

# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

all: html txt ps pdf

po-sources := $(wildcard po4a/po/??*.po)
sgml-from-po := $(patsubst po4a/po/%.po,$(MANUAL).%.sgml,$(po-sources))
sgml-sources := $(wildcard *.??*.sgml)
sources := $(sgml-sources) $(sgml-from-po)
# noncjk == no ps/pdf
sources_noncjk := $(filter-out project-history.ko.sgml,$(sources))

update-po $(sgml-from-po): $(MANUAL).sgml $(po-sources)
	touch po4a/po/$(MANUAL).pot
	po4a --force po4a/po4a.cfg

# generating HTML
# ugly because the normal stuff works only as PHONYs. :(
#$(MANUAL).%.html/index.%.html: $(MANUAL).%.sgml
#	debiandoc2html -c -l $* $<
html: $(sgml-from-po)
	@if [ ! -f $(MANUAL).en.html/index.en.html -o $(MANUAL).sgml -nt $(MANUAL).en.html/index.en.html ]; then \
          rm -r $(MANUAL).en.html; \
          echo debiandoc2html -C -l en.utf-8 $(MANUAL).sgml; \
	  debiandoc2html -C -l en.utf-8 $(MANUAL).sgml; \
          mv $(MANUAL).html $(MANUAL).en.html; \
        fi
	@for i in $(sources); do \
          nosuffix=$${i%.sgml}; \
	  lang=$${nosuffix#$(MANUAL).}; \
	if [ ! -f $(MANUAL).$$lang.html/index.$$lang.html -o $$i -nt $(MANUAL).$$lang.html/index.$$lang.html ]; then \
	    sgmlfile=$$nosuffix.sgml; \
	    echo debiandoc2html -C -l $$lang.utf-8 $$sgmlfile; \
            debiandoc2html -C -l $$lang.utf-8 $$sgmlfile; \
          fi; \
        done

# generating plain text
txt text: $(MANUAL).en.txt $(patsubst %.sgml,%.txt,$(sources))

$(MANUAL).en.txt: $(MANUAL).sgml
	debiandoc2text -l en.utf-8 $<
	mv $(MANUAL).txt $(MANUAL).en.txt

# NOTE: convert to koi8-r for correct text wrap with debiandoc2text, workaround #684276
$(MANUAL).ru.txt: $(MANUAL).ru.sgml
	iconv -f utf-8 -t koi8-r//translit $< \
		| debiandoc2text -l ru-ru.koi8-r - \
		| iconv -f koi8-r -t utf-8 -o $@

$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $*.utf-8 $<

# generating PostScript
ps: $(MANUAL).en.ps $(patsubst %.sgml,%.ps,$(sources_noncjk))

$(MANUAL).en.ps: $(MANUAL).sgml
	debiandoc2latexps -l en.utf-8 $<
	mv $(MANUAL).ps $(MANUAL).en.ps

$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $*.utf-8 $<

# generating Portable Document Format
pdf: $(MANUAL).en.pdf $(patsubst %.sgml,%.pdf,$(sources_noncjk))

$(MANUAL).en.pdf: $(MANUAL).sgml
	debiandoc2latexpdf -l en.utf-8 $<
	mv $(MANUAL).pdf $(MANUAL).en.pdf

$(MANUAL).%.pdf: $(MANUAL).%.sgml
	debiandoc2latexpdf -l $*.utf-8 $<

# publishing to the DDP web pages
publish: all
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	install -p -m 644 $(MANUAL)*.html/*.html $(PUBLISHDIR)/$(MANUAL)/
# possible non-POSIX syntax below.
	cd $(PUBLISHDIR)/$(MANUAL) && for file in *.en.html; do \
          ln -s $$file $${file%$${file#$${file%.en.html}}}.html; \
        done
	install -p -m 644 $(MANUAL)*.txt $(MANUAL)*.ps $(MANUAL)*.pdf $(PUBLISHDIR)/$(MANUAL)
	echo "AddCharset UTF-8 .txt" > $(PUBLISHDIR)/$(MANUAL)/.htaccess
	ln -sf $(MANUAL).en.txt $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).txt
	ln -sf $(MANUAL).en.ps $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).ps
	ln -sf $(MANUAL).en.pdf $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).pdf

# validating SGML
validate:
	@set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

# cleaning up
clean distclean:
	for suffix in txt ps dvi pdf info* log tex aux toc out sasp* tpt; do \
	  rm -f $(MANUAL)*.$$suffix; \
	done
	rm -rf $(MANUAL)*.html head.tmp body.tmp *~ $(sgml-from-po) po4a/po/$(MANUAL).pot

.PHONY: all publish clean distclean validate
.SUFFIXES:
