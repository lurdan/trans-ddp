# Makefile for a manual in the Debian Documentation Project manuals.sgml
# tree.

# The directory in which this makefile resides must also contain a file
# called <directoryname>.sgml, which is the top-level file for the manual
# in this directory.

# What is the current manual's name
MANUAL :=	$(shell basename $(shell pwd))
# Where are we publishing to?
PUBLISHDIR :=	../../../public_html/manuals.html

# What do we want?
all:		publish

# This target installs the generated HTML in the published directory.
publish:	html
# 		fail if there is no PUBLISHDIR
		[ -d $(PUBLISHDIR) ] || exit 1
		rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
		install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
		install -m 644 --preserve-timestamps $(MANUAL).html/*.html \
			$(PUBLISHDIR)/$(MANUAL)/

html:		$(wildcard *.sgml)
		debiandoc2html $(MANUAL).sgml
		touch htmlmade

clean:	
		rm -rf $(MANUAL).html htmlmade

distclean:	clean

