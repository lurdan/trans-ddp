#
# Makefile for the Debian New Maintainers' Guide
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for maint-guide package build.

SRCS = maint-guide.sgml # $(wildcard *.sgml)

# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html

all:

publish: maint-guide.html/index.html
	test -d $(PUBLISHDIR)/maint-guide || install -d -m 755 $(PUBLISHDIR)/maint-guide
	rm -f $(PUBLISHDIR)/maint-guide/*.html
	install -p -m 644 maint-guide.html/*.html $(PUBLISHDIR)/maint-guide/

validate:
	nsgmls -ges -wall maint-guide.sgml

clean distclean:
	rm -f maint-guide*.{txt,ps,dvi,pdf,info*,log,tex} *~
	rm -rf maint-guide*.html

html maint-guide.html/index.html: $(SRCS)
	debiandoc2html maint-guide.sgml

txt maint-guide.txt: $(SRCS)
	debiandoc2text maint-guide.sgml

ps maint-guide.ps: $(SRCS)
	debiandoc2latexps maint-guide.sgml

.PHONY: all publish clean distclean validate
