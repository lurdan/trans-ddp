# template makefile for a manual in the Debian Documentation Project
# manuals.sgml tree.

# Where are we publishing to?
PUBLISHDIR := /org/www.debian.org/www/doc/manuals
# How to install stuff in publish directory
install_file :=	install -p -m 664
install_dir :=	install -d -m 2775

# Manual name and its source files
manual :=	$(notdir $(CURDIR))
sources :=	$(manual).sgml $(wildcard *.sgml)

# What do we want by default?
all: $(manual).html/index.html

# This target installs the generated HTML in the published directory.
publish: $(manual).html/index.html
	[ -d $(PUBLISHDIR)/$(manual) ] || $(install_dir) $(PUBLISHDIR)/$(manual)
	$(install_file) $(manual).html/*.html $(PUBLISHDIR)/$(manual)/

$(manual).html/index.html: $(sources)
	debiandoc2html $(manual).sgml

$(manual).txt: $(sources)
	debiandoc2text $(manual).sgml

$(manual).ps $(manual).dvi $(manual).pdf: $(manual).%: $(sources)
	debiandoc2latex$* $(manual).sgml

# ensure our SGML is valid
#   (add this to the `all' rule to prevent building if not)
validate:
	nsgmls -ges -wall $(manual).sgml

clean distclean:
	rm -rf $(manual).html
	rm -f $(manual).txt $(manual).ps $(manual).dvi $(manual).pdf \
          $(manual).aux $(manual).log $(manual).man $(manual).tex \
          $(manual).toc *~ .*~ core tsa*

.PHONY: all publish clean distclean validate
