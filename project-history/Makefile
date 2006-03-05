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

po-sources := $(wildcard *.??*.po)
sgml-from-po := $(patsubst %.po,%.sgml,$(po-sources))
sgml-sources := $(wildcard *.??*.sgml)
sources := $(sgml-sources) $(sgml-from-po)
sources_noncjk := $(sources)

$(MANUAL).pot: $(MANUAL).sgml
	debiandoc2pot $(MANUAL).sgml > $(MANUAL).pot

$(MANUAL).%.sgml: $(MANUAL).sgml $(MANUAL).%.po
	po2debiandoc $(MANUAL).sgml $(MANUAL).$*.po > $(MANUAL).$*.sgml

update-po: $(MANUAL).pot
	for po in $(po-sources); do \
	  msgmerge --width=76 $$po $(MANUAL).pot -o $$po.new && mv $$po.new $$po; \
	done

# generating HTML
# ugly because the normal stuff works only as PHONYs. :(
#$(MANUAL).%.html/index.%.html: $(MANUAL).%.sgml
#	debiandoc2html -c -l $* $<
html:
	@if [ $(MANUAL).sgml -nt $(MANUAL).en.html/index.en.html ]; then \
          rm -r $(MANUAL).en.html; \
          echo debiandoc2html -c -l en $(MANUAL).sgml; \
          debiandoc2html -c -l en $(MANUAL).sgml; \
          mv $(MANUAL).html $(MANUAL).en.html; \
        fi
	@for i in $(sgml-sources) $(po-sources); do \
          nosuffix1=$${i%.sgml}; nosuffix=$${nosuffix1%.po}; \
	  lang=$${nosuffix#$(MANUAL).}; \
	  if [ $$i -nt $(MANUAL).$$lang.html/index.$$lang.html ]; then \
	    sgmlfile=$$nosuffix.sgml; \
	    [ $$sgmlfile != $$i ] && make $$sgmlfile; \
	    echo debiandoc2html -c -l $$lang $$sgmlfile; \
            debiandoc2html -c -l $$lang $$sgmlfile; \
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
# possible non-POSIX syntax below.
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
	for suffix in txt ps dvi pdf info* log tex aux toc out sasp* tpt; do \
	  rm -f $(MANUAL)*.$$suffix; \
	done
	rm -rf $(MANUAL)*.html head.tmp body.tmp *~ $(sgml-from-po) $(MANUAL).pot

.PHONY: all publish clean distclean validate
.SUFFIXES:
