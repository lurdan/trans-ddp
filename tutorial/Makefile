# Makefile for a manual in the Debian Documentation Project manuals.sgml
# tree.

# The directory in which this makefile resides must also contain a file
# called <directoryname>.sgml, which is the top-level file for the manual
# in this directory.

# What is the current manual's name
# MANUAL :=	$(shell basename $(shell pwd))
MANUAL :=	debian-tutorial

# Where are we publishing to?
#  (this can be overriden by a higher level makefile)
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

# What do we want by default?
all:		publish

# This target installs the generated HTML in the published directory.
publish:	$(MANUAL).html/index.html
# 		fail if there is no PUBLISHDIR
		[ -d $(PUBLISHDIR) ] || exit 1
		rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
		install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
		install -m 644 --preserve-timestamps $(MANUAL).html/*.html \
			$(PUBLISHDIR)/$(MANUAL)/

$(MANUAL).html/index.html:	$(wildcard *.sgml)
	debiandoc2html $(MANUAL).sgml

# ensure our SGML is valid
#   (add this to $(MANUAL).html rule to prevent building if not)
validate:
	nsgmls -gues $(MANUAL).sgml

# Old targets, modified by joy to replace actual name with variable,
# and other minor stuff.

all-old : $(MANUAL).tar.gz $(MANUAL).text.gz $(MANUAL).dvips.gz debtut.txt

outputs : $(MANUAL).text $(MANUAL).html $(MANUAL).dvips

$(MANUAL).dvips : $(MANUAL).sgml
	debiandoc2dvips $(MANUAL).sgml

$(MANUAL).text : $(MANUAL).sgml
	debiandoc2text $(MANUAL).sgml

$(MANUAL).html-old : $(MANUAL).sgml
	debiandoc2html $(MANUAL).sgml

$(MANUAL).tar : ChangeLog outputs COPYING
	chmod 644 $(MANUAL).text $(MANUAL).dvips ChangeLog
	chmod 755 $(MANUAL).html
	chmod 644 $(MANUAL).html/*
	tar --create --file=$(MANUAL).tar $(MANUAL).dvips $(MANUAL).text $(MANUAL).html $(MANUAL).sgml ChangeLog COPYING
	chmod 644 $(MANUAL).tar

$(MANUAL).tar.gz : $(MANUAL).tar
	gzip --force $(MANUAL).tar

$(MANUAL).dvips.gz : $(MANUAL).dvips
	cp -f $(MANUAL).dvips $(MANUAL).dvips.tmp
	gzip --force $(MANUAL).dvips.tmp
	mv -f $(MANUAL).dvips.tmp.gz $(MANUAL).dvips.gz	
	chmod 644 $(MANUAL).dvips.gz

$(MANUAL).text.gz : $(MANUAL).text
	cp -f $(MANUAL).text $(MANUAL).text.tmp
	gzip --force $(MANUAL).text.tmp
	mv -f $(MANUAL).text.tmp.gz $(MANUAL).text.gz	
	chmod 644 $(MANUAL).text.gz	

debtut.txt : $(MANUAL).text
	cp -f $(MANUAL).text debtut.txt
	todos debtut.txt
	chmod 644 debtut.txt

clean : 
	/bin/rm -rf $(MANUAL).html
	/bin/rm $(MANUAL).text
	/bin/rm $(MANUAL).dvips
	/bin/rm $(MANUAL).text.gz
	/bin/rm $(MANUAL).dvips.gz

distclean:	clean

.PHONY: all publish clean distclean validate
