#
# Makefile for the Debian FAQ
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for doc-debian package build.

# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html

sources := debian-faq.sgml faqstatic.ent faqdynamic.ent $(wildcard *.sgml)

export LANG=C
# stupid debiandoc stuff uses strings in another language otherwise

all: html text ps

publish: debian-faq.html/index.html
	test -d $(PUBLISHDIR)/debian-faq || install -d -m 755 $(PUBLISHDIR)/debian-faq
	rm -f $(PUBLISHDIR)/debian-faq/*.html
	install -p -m 644 debian-faq.html/*.html $(PUBLISHDIR)/debian-faq/

faqdynamic.ent:
	echo "<!entity docdate \"$(shell LC_ALL=C date +'%-d %B %Y')\">" > faqdynamic.ent
	if [ -f ../debian/changelog ]; then \
          echo "<!entity docversion \"` LC_ALL=C cd .. && dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//'`\">" >> faqdynamic.ent; \
        else \
          echo "<!entity docversion \"CVS\">" >> faqdynamic.ent; \
        fi

validate:
	nsgmls -ges -wall debian-faq.sgml

html: debian-faq.html/index.html
debian-faq.html/index.html: $(sources)
	debiandoc2html $<

text: debian-faq.txt
debian-faq.txt: $(sources)
	debiandoc2text $<

debian-faq.info: $(sources)
	debiandoc2info $<

debian-faq.ps debian-faq.dvi debian-faq.pdf: debian-faq.%: $(sources)
	debiandoc2latex$* $<

ps dvi pdf info: %: debian-faq.%

clean distclean:
	rm -rf debian-faq.html
	rm -f debian-faq.{txt,ps,dvi,pdf,info*,aux,log,man,tex,toc,sasp*}
	rm -f faqdynamic.ent *~ .*~ core tsa*

.PHONY: all publish clean distclean validate
