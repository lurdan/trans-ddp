#
# Standard Debian Documentation Project Makefile
#
# Should work both for a manual in the DDP CVS tree, and for a package build.

# basename for the manual
MANUAL		:= $(notdir $(CURDIR))
# XML source we're building
#  fixme: subdirs?
XMLFILES	:= $(wildcard [a-zA-Z]*.xml)
XML_VALIDATE	:= xmllint

# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

all: html txt ps pdf

##
## rules to build
##
# fixme: add the rules

# publishing to the DDP web pages
publish: all
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	install -p -m 644 $(MANUAL)*.html/*.html $(PUBLISHDIR)/$(MANUAL)/
#	 possible non-POSIX syntax below, but oh well
	cd $(PUBLISHDIR)/$(MANUAL) && for file in *.en.html; do \
          ln -s $$file $${file%$${file#$${file%.en.html}}}.html; \
        done
	install -p -m 644 $(MANUAL)*.txt $(MANUAL)*.ps $(MANUAL)*.pdf $(PUBLISHDIR)/$(MANUAL)
	ln -sf $(MANUAL).en.txt $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).txt
	ln -sf $(MANUAL).en.ps $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).ps
	ln -sf $(MANUAL).en.pdf $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).pdf

# validate our XML files
.PHONY: validate
validate:	$(addsuffix .validate,$(XMLFILES))

%.validate : %
	$(XML_VALIDATE) $<

%.date:	%.xml
	date +"%e %b, %Y" --reference=$< > $@

# cleaning up
clean distclean:
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,out,sasp*} *~
	rm -rf $(MANUAL)*.html

.PHONY: all publish clean distclean validate
.SUFFIXES:

# delete target if rule fails
.DELETE_ON_ERROR:
