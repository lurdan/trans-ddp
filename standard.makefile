# Makefile for a manual in the Debian Documentation Project manuals.sgml
# tree.

# The directory in which this makefile resides must also contain a file
# called <directoryname>.sgml, which is the top-level file for the manual
# in this directory.

# Where are we, and where are we going?
HERE :=		$(shell pwd)
THISDIR :=	$(shell basename `pwd`)
TARGET :=	../../../public_html/manuals.html/$(THISDIR)
SGMLFILES := 	$(shell ls *.sgml)

# What do we want?
all:		html

# This target installs the generated HTML in the published directory.
html:		htmlmade
		-rm $(TARGET)/*.html
		install -d $(TARGET)
		cp $(THISDIR).html/*.html $(TARGET)

htmlmade:	$(SGMLFILES)
		debiandoc2html $(THISDIR).sgml
		touch htmlmade

clean:	
		-rm -rf $(THISDIR).html htmlmade

distclean:	clean
