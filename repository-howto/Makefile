#
# Makefile for DDP documentation generated with xmlto etc
#
# (Repository HOWTO, How software producers can distribute software
# in .deb format, etc)

manual := $(notdir $(CURDIR))

# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

sources := $(manual).xml

all: html pdf # dvi ps # god damn dvi and ps don't work

publish: all
	test -d $(PUBLISHDIR)/$(manual) || install -d -m 755 $(PUBLISHDIR)/$(manual)
	rm -f $(PUBLISHDIR)/$(manual)/*.html
	install -p -m 644 $(manual).html $(PUBLISHDIR)/$(manual)
	install -p -m 644 $(manual).pdf $(PUBLISHDIR)/$(manual)
	install -p -m 644 $(manual).dvi $(PUBLISHDIR)/$(manual)
	install -p -m 644 $(manual).ps $(PUBLISHDIR)/$(manual)

validate:
	xmllint --noout --loaddtd --catalogs $(sources)

html: $(manual).html
$(manual).html: $(sources)
	xsltproc --catalogs -o $@ \
	/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/html/docbook.xsl \
	$<

fo: $(manual).fo
$(manual).fo: $(sources)
	xsltproc --catalogs -o $@ \
	/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/fo/docbook.xsl \
	$<

dvi: $(manual).dvi
$(manual).dvi: $(manual).fo
	xmltex --interaction=batchmode $<

ps: $(manual).ps
$(manual).ps: $(manual).dvi
	dvips $<

pdf: $(manual).pdf
$(manual).pdf: $(manual).fo
	pdfxmltex --interaction=batchmode $<

clean distclean:
	rm -f $(manual).aux $(manual).html $(manual).dvi $(manual).fo \
	$(manual).log $(manual).pdf $(manual).ps $(manual).out $(manual).toc
	rm -f *~ .*~ core tsa*

.PHONY: all publish clean distclean dvi fo html pdf ps validate
