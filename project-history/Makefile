# Makefile for a manual in the Debian Documentation Project manuals.sgml
# tree.

# Due to policy for DOP, posting web page from this tree is terminated.
# Despite it, i will keep this alive so any one can see where users-guide/ 
# came from :)

# The directory in which this makefile resides must also contain a file
# called <directoryname>.sgml, which is the top-level file for the manual
# in this directory.

# What is the current manual's name
MANUAL :=	$(shell basename $(shell pwd))
# Where are we publishing to?
#  (this can be overriden by a higher level makefile)
PUBLISHDIR :=	../../../public_html/manuals.html

.SUFFIXES: .sgml .txt .html

.sgml.txt:
	debiandoc2text $*.sgml

# What do we want by default?
all:		publish

# This target installs the generated HTML in the published directory.
publish:	$(MANUAL).html/index.html
# 		fail if there is no PUBLISHDIR
		[ -d $(PUBLISHDIR) ] || exit 1
		rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
# With these commented out, you will not see web page
#		install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
#		install -m 644 --preserve-timestamps $(MANUAL).html/*.html \
#			$(PUBLISHDIR)/$(MANUAL)/

$(MANUAL).html/index.html:	$(wildcard *.sgml)
		debiandoc2html $(MANUAL).sgml

# ensure our SGML is valid
#   (add this to $(MANUAL).html rule to prevent building if not)
validate:
		nsgmls -gues $(MANUAL).sgml

clean:
		rm -rf $(MANUAL).html

distclean:	clean

.PHONY: all publish clean distclean validate
