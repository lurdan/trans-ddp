# Makefile for a manual in the Debian Documentation Project manuals.sgml
# tree.

# The directory in which this makefile resides must also contain a file
# called <directoryname>.sgml, which is the top-level file for the manual
# in this directory.

# What is the current manual's name
MANUAL :=	$(shell basename $(shell pwd))
# Where are we publishing to?
#  (this can be overriden by a higher level makefile)
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

# List of languages built for "publish" target for DDP
LANGS    := en fr

# List of html stamp files to be built
HTMLS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).html.stamp)

# List of txt to be built
TXTS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).txt)

# List of ps to be built
PSS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).ps)

# List of pdf to be built
PDFS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).pdf)

# What do we want by default?
all: html txt ps pdf
html: $(HTMLS)
text txt:  $(TXTS)
ps:   $(PSS)
pdf:  $(PDFS)

$(MANUAL).en.sgml:
	ln -sf $(MANUAL).sgml $@

# This target installs the generated HTML in the published directory.
publish: html txt ps pdf
# 	fail if there is no PUBLISHDIR
	[ -d $(PUBLISHDIR) ] || exit 1
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	$(foreach lang,$(LANGS),\
		install -m 644 -p $(MANUAL).$(lang).html/*.html $(PUBLISHDIR)/$(MANUAL)/; \
		$(foreach fmt,txt ps pdf,\
 		   install -p -m 644 $(MANUAL).$(lang).$(fmt) $(PUBLISHDIR)/$(MANUAL)/; \
		 ) \
	)

# HTML
# since $(MANUAL).%.html/index.%.html cannot be a target file
$(MANUAL).%.html.stamp: $(MANUAL).%.sgml
	debiandoc2html -l $* -c $<
	touch $(MANUAL).$*.html.stamp

# TXT
$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $* $<

# PS
$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $* $<

# PDF
$(MANUAL).%.pdf: $(MANUAL).%.sgml
	debiandoc2latexpdf -l $* $<

# ensure our SGML is valid
#   (add this to $(MANUAL).html rule to prevent building if not)
validate: $(foreach lang,$(LANGS),validate-$(lang))

validate-%: $(MANUAL).%.sgml
	nsgmls -gues -wall $(MANUAL).$*.sgml

clean_SUFFIXES := txt ps dvi pdf info* log tex tex-in aux toc sasp* out tov tpt hyp

clean:
	rm -rf $(MANUAL).html $(MANUAL).*.html $(MANUAL).*.html.stamp
	rm -f $(MANUAL).en.sgml
	rm -f $(addprefix $(MANUAL).*.,$(clean_SUFFIXES))
	rm -f *~ prior.aux pprior.aux *.log head.tmp body.tmp
	rm -f thb*.png
	rm -f *.tex[01]pdf *.tex[01]ps texsys.aux

distclean:	clean

.PHONY: all html txt ps pdf publish clean distclean validate
