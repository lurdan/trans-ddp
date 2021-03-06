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

langs ?= ru pt_BR it pl es fr de uk zh_CN

export LANG=C
# stupid debiandoc stuff uses strings in another language otherwise

all: po4a-translate html text ps pdf

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
	for lang in $(langs); do [ ! -d $$lang ] || $(MAKE) -C $$lang $@; done

faqdynamic.ent:
	echo "<!entity docdate \"$(shell LC_ALL=C date +'%-d %B %Y')\">" > faqdynamic.ent
	if [ -f debian/changelog ]; then \
          echo "<!entity docversion \"` LC_ALL=C dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//'`\">" >> faqdynamic.ent; \
        else \
          echo "<!entity docversion \"CVS\">" >> faqdynamic.ent; \
        fi

update-po: faqdynamic.ent
	po4a --force --previous --no-translations --rm-backups po4a/po4a.cfg

po4a-translate: faqdynamic.ent
	po4a --keep 0 --previous --rm-backups po4a/po4a.cfg # --localized-charset UTF-8
	sed -i 's/<.*heading>//g' fr/*sgml

validate:
	nsgmls -ges -wall $(manual).sgml

html: $(manual).$(currentlang).html/index.$(currentlangcn).html
	for lang in $(langs); do [ ! -d $$lang ] || $(MAKE) -C $$lang $@; done

$(manual).$(currentlang).html/index.$(currentlangcn).html: $(sources)
	rm -rf $(manual).html $(manual).$(currentlang).html
	debiandoc2html -c -l $(currentlang) $<
	mv $(manual).html $(manual).$(currentlang).html

text: $(manual).$(currentlang).txt
	for lang in $(langs); do [ ! -d $$lang ] || $(MAKE) -C $$lang $@; done

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
	for lang in $(langs); do [ ! -d $$lang ] || $(MAKE) -C $$lang $@; done

clean distclean:
	rm -rf $(manual)*.$(currentlang).html
	rm -f $(manual)*.{txt,ps,dvi,pdf,info*,aux,log,man,tex,toc,out,tpt,sasp*}
	rm -f *.tmp
	rm -f $(manual)*.{txt,ps,pdf}.gz
	rm -f faqdynamic.ent *~ .*~ core tsa*
	for lang in $(langs); do [ ! -d $$lang ] || $(MAKE) -C $$lang $@; done

.PHONY: all publish clean distclean validate update-po po4a-translate
