#
# Makefile for the Debian FAQ
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for doc-debian package build.

SRCS = debian-faq.sgml faqstatic.ent faqdynamic.ent $(wildcard *.sgml)

# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html

all:

publish: debian-faq.html/index.html
	test -d $(PUBLISHDIR)/debian-faq || install -d -m 755 $(PUBLISHDIR)/debian-faq
	rm -f $(PUBLISHDIR)/debian-faq/*.html
	install -p -m 644 debian-faq.html/*.html $(PUBLISHDIR)/debian-faq/

faqdynamic.ent:
	echo "<!entity docdate \"$(shell date +'%-d %B %Y')\">" > faqdynamic.ent
	if [ -f ../debian/changelog ]; then \
          echo "<!entity docversion \"` LC_ALL=C cd .. && dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//'`\">" >> faqdynamic.ent; \
        else \
          echo "<!entity docversion \"CVS\">" >> faqdynamic.ent; \
        fi

validate:
	nsgmls -gues debian-faq.sgml

clean distclean:
	rm -f debian-faq.{txt,ps,dvi,pdf,info*,aux,log,man,tex,toc,sasp*} *~ .*~ core tsa*
	rm -rf debian-faq.html
	test -f ../debian/changelog || rm -f faqdynamic.ent

html debian-faq.html/index.html: $(SRCS)
	debiandoc2html debian-faq.sgml

txt debian-faq.txt: $(SRCS)
	debiandoc2text debian-faq.sgml

ps debian-faq.ps: $(SRCS)
	debiandoc2latexps debian-faq.sgml

dvi debian-faq.dvi: $(SRCS)
	debiandoc2latexdvi debian-faq.sgml

pdf debian-faq.pdf: $(SRCS)
	debiandoc2latexpdf debian-faq.sgml

info debian-faq.info: $(SRCS)
	debiandoc2info debian-faq.sgml

.PHONY: all publish clean distclean validate
