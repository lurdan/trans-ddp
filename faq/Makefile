#
# Makefile for the Debian FAQ
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for doc-debian package build.

manual := debian-faq

currentlang := en
currentlangcn := $(shell echo $(currentlang) | tr A-Z a-z | tr - _)

# this can and will be overridden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

sources := $(manual).sgml faqstatic.ent faqdynamic.ent $(wildcard *.sgml)

export LANG=C
# stupid debiandoc stuff uses strings in another language otherwise

all: html text ps pdf

publish: all
	test -d $(PUBLISHDIR)/$(manual) || install -d -m 755 $(PUBLISHDIR)/$(manual)
	rm -f $(PUBLISHDIR)/$(manual)/*.$(currentlangcn).html
	install -p -m 644 $(manual).$(currentlang).html/*.html $(PUBLISHDIR)/$(manual)
# possible non-POSIX syntax below. fuck POSIX.
	cd $(PUBLISHDIR)/$(manual) && for file in *.en.html; do \
          ln -sf $$file $${file%$${file#$${file%.en.html}}}.html; \
        done
	install -p -m 644 $(manual)*.txt $(manual)*.ps $(manual)*.pdf $(PUBLISHDIR)/$(manual)
	ln -sf $(manual).en.txt $(PUBLISHDIR)/$(manual)/$(manual).txt
	ln -sf $(manual).en.ps $(PUBLISHDIR)/$(manual)/$(manual).ps
	ln -sf $(manual).en.pdf $(PUBLISHDIR)/$(manual)/$(manual).pdf
	@[ ! -d ru ] || $(MAKE) -C ru $@
	@[ ! -d pt_BR ] || $(MAKE) -C pt_BR $@
	@[ ! -d it ] || $(MAKE) -C it $@
	@[ ! -d pl ] || $(MAKE) -C pl $@
	@[ ! -d es ] || $(MAKE) -C es $@
	@[ ! -d fr ] || $(MAKE) -C fr $@

faqdynamic.ent:
	echo "<!entity docdate \"$(shell LC_ALL=C date +'%-d %B %Y')\">" > faqdynamic.ent
	if [ -f ../debian/changelog ]; then \
          echo "<!entity docversion \"` LC_ALL=C cd .. && dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//'`\">" >> faqdynamic.ent; \
        else \
          echo "<!entity docversion \"CVS\">" >> faqdynamic.ent; \
        fi

validate:
	nsgmls -ges -wall $(manual).sgml

html: $(manual).$(currentlang).html/index.$(currentlangcn).html
	@[ ! -d ru ] || $(MAKE) -C ru $@
	@[ ! -d pt_BR ] || $(MAKE) -C pt_BR $@
	@[ ! -d it ] || $(MAKE) -C it $@
	@[ ! -d pl ] || $(MAKE) -C pl $@
	@[ ! -d es ] || $(MAKE) -C es $@
	@[ ! -d fr ] || $(MAKE) -C fr $@

$(manual).$(currentlang).html/index.$(currentlangcn).html: $(sources)
	rm -rf $(manual).html $(manual).$(currentlang).html
	debiandoc2html -c -l $(currentlang) $<
	mv $(manual).html $(manual).$(currentlang).html

text: $(manual).$(currentlang).txt
	@[ ! -d ru ] || $(MAKE) -C ru $@
	@[ ! -d pt_BR ] || $(MAKE) -C pt_BR $@
	@[ ! -d it ] || $(MAKE) -C it $@
	@[ ! -d pl ] || $(MAKE) -C pl $@
	@[ ! -d es ] || $(MAKE) -C es $@
	@[ ! -d fr ] || $(MAKE) -C fr $@

$(manual).$(currentlang).txt: $(sources)
	debiandoc2text -l $(currentlang) $<
	mv $(manual).txt $(manual).$(currentlang).txt

$(manual).$(currentlang).info: $(sources)
	debiandoc2info -l $(currentlang) $<
# TODO: rename to .$(currentlang).info?

$(manual).$(currentlang).ps $(manual).$(currentlang).dvi $(manual).$(currentlang).pdf: \
  $(manual).$(currentlang).%: $(sources)
	debiandoc2latex$* -l $(currentlang) $<
	mv $(manual).$* $(manual).$(currentlang).$*

ps dvi pdf info: %: $(manual).$(currentlang).%
	@[ ! -d ru ] || $(MAKE) -C ru $@
	@[ ! -d pt_BR ] || $(MAKE) -C pt_BR $@
	@[ ! -d it ] || $(MAKE) -C it $@
	@[ ! -d pl ] || $(MAKE) -C pl $@
	@[ ! -d es ] || $(MAKE) -C es $@
	@[ ! -d fr ] || $(MAKE) -C fr $@

clean distclean:
	rm -rf $(manual)*.$(currentlang).html
	rm -f $(manual)*.{txt,ps,dvi,pdf,info*,aux,log,man,tex,toc,out,tpt,sasp*}
	rm -f faqdynamic.ent *~ .*~ core tsa*
	@[ ! -d ru ] || $(MAKE) -C ru $@
	@[ ! -d pt_BR ] || $(MAKE) -C pt_BR $@
	@[ ! -d it ] || $(MAKE) -C it $@
	@[ ! -d pl ] || $(MAKE) -C pl $@
	@[ ! -d es ] || $(MAKE) -C es $@
	@[ ! -d fr ] || $(MAKE) -C fr $@

.PHONY: all publish clean distclean validate
