#
# Makefile for the Debian Repository HOWTO
#

manual := repository-howto

# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

sources := $(manual).xml

all: html

publish: all
	test -d $(PUBLISHDIR)/$(manual) || install -d -m 755 $(PUBLISHDIR)/$(manual)
	rm -f $(PUBLISHDIR)/$(manual)/*.html
	install -p -m 644 $(manual).html $(PUBLISHDIR)/$(manual)

validate:
	nsgmls -s -wxml $(sources)

html: $(manual).html
$(manual).html: $(sources)
	xmlto html-nochunks $<
	tidy -mq $@

clean distclean:
	rm -f $(manual).html
	rm -f *~ .*~ core tsa*

.PHONY: all publish clean distclean validate
