#
# Makefile for the Debian FAQ
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for doc-debian package build.

currentlang := pt_BR
currentlangcn := pt-br

# this can and will be overriden by a higher level makefile
PUBLISHDIR := $(CURDIR)/../../manuals.html

sources := debian-faq.sgml ../faqstatic.ent ../faqdynamic.ent $(wildcard *.sgml)

export LANG=C
# stupid debiandoc stuff uses strings in another language otherwise

all: html text ps pdf

publish: debian-faq.$(currentlang).html/index.$(currentlangcn).html
	test -d $(PUBLISHDIR)/debian-faq || install -d -m 755 $(PUBLISHDIR)/debian-faq
	rm -f $(PUBLISHDIR)/debian-faq/*.$(currentlangcn).html
	install -p -m 644 debian-faq.$(currentlang).html/*.html $(PUBLISHDIR)/debian-faq/

../faqdynamic.ent:
	cd .. && $(MAKE) faqdynamic.ent

validate:
	nsgmls -ges -wall debian-faq.sgml

html: debian-faq.$(currentlang).html/index.$(currentlangcn).html
debian-faq.$(currentlang).html/index.$(currentlangcn).html: $(sources)
	debiandoc2html -c -l $(currentlang) $<
	mv debian-faq.html debian-faq.$(currentlang).html

text: debian-faq.$(currentlang).txt
debian-faq.$(currentlang).txt: $(sources)
	debiandoc2text -l $(currentlang) $<

debian-faq.$(currentlang).info: $(sources)
	debiandoc2info -l $(currentlang) $<

debian-faq.$(currentlang).ps debian-faq.$(currentlang).dvi debian-faq.$(currentlang).pdf: \
  debian-faq.$(currentlang).%: $(sources)
	debiandoc2latex$* -l $(currentlang) $<

ps dvi pdf info: %: debian-faq.$(currentlang).%

clean distclean:
	rm -rf debian-faq*.$(currentlang).html
	rm -f debian-faq*.{txt,ps,dvi,pdf,info*,aux,log,man,tex,toc,sasp*}
	rm -f *~ .*~ core tsa*

.PHONY: all publish clean distclean validate
