#
# New Makefile Template (Osamu Aoki)
#
#  Build html(multi-page), txt, ps, pdf, and other formats.
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for the package build.
# ------------------------------------------------------------------- #
#                          WARNING                                    #
#         Use with caution, aimed at woody system                     #
#   "ps" and "pdf" tends to break in some ill-configured system       #
# ------------------------------------------------------------------- #

# Following default shall be editted buy the cordinaor for the entire
# set of languages.  If each subsection owner wish to overide setyings,
# this can be overriden by running make with "make 'LANGS=fi'" etc.. 

# =================================================================== #
#                 Default configuration part: Customize               #
# =================================================================== #

# The directory in which this makefile resides must also contain a file
# called <directoryname>.[<language>.]sgml, which is the top-level file
# for the manual in this directory.

# Basename for language dependent sgml (DDP default, generated)
MANUAL := $(notdir $(CURDIR))

# Basename for language independent sgml-template.
MANUAL0 := qref

# Build type: Possible values are BUILD_TYPE = web|package|sf
BUILD_TYPE  := web
# Set parameters by build environment
 
ifeq ("$(BUILD_TYPE)", "web")
# DDP site or checked out source from DDP
MANUAL := debian-reference
else 
ifeq ("$(BUILD_TYPE)", "sf")
# For sourceforege remote build
MANUAL := qref
else
# Default: for Debian package
MANUAL := debian-reference
endif
endif

# Publish directory
# This can and will be overriden by a higher level makefile
PUBLISHDIR := ~/public_html/manuals.html

# List of languages build for "publish" target for DDP
LANGS := en fr it es

# Files which affect SGML generation (excluding *.sgml)
SGMLENTS := custom.ent default.ent

# All SGML source files
SGMLSRCS := $(foreach lang, $(LANGS), $(MANUAL).$(lang).sgml) \
	    $(foreach lang, $(LANGS), $(wildcard $(lang)/*.sgml ) ) \
	    $(SGMLENTS)

# Name for example directory
EXAMPLE := examples

# List of example to be copied
EXAMPLES := $(wildcard $(EXAMPLE)/*)


# List of all files in tar
ifeq ("$(BUILD_TYPE)", "sf")
TARSRCS = $(EXAMPLES) bin/* $(SGMLSRCS) Makefile TODO PROJECT README index.php
else
TARSRCS = $(EXAMPLES) bin/* $(SGMLSRCS) Makefile TODO PROJECT README
endif

# =================================================================== #
#                 Build target default part: Routine                  #
# =================================================================== #
# If some languages have problem building, filter-out in here.

# List of parent sgml to be build for each language
SGMLS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).sgml)

# List of html stamp files to be built
HTMLS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).html.stamp)

# List of pdf to be build
TXTS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).txt)

# List of ps to be build
PSS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).ps)

# List of pdf to be build
PDFS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).pdf)

# =================================================================== #
#                 Build target part: Customize                        #
# =================================================================== #
# If some language have problem building, filter-out in here.

all:  html txt ps pdf 
sgml: $(SGMLS)
html: $(HTMLS)
text txt:  $(TXTS)
ps:   $(PSS)
pdf:  $(PDFS)
tar:  $(MANUAL).tar.gz

publish: publish-html publish-examples publish-txt publish-ps publish-pdf
publish-all: publish publish-tar

# =================================================================== #
#                 Build rule part: If not package build               #
# =================================================================== #

dynamic.%.ent:
	echo "<!entity language \"$*\">"                 > $@
	echo "<!entity % lang-$* \"INCLUDE\">"          >> $@
	echo "<!entity docdate \"`LC_ALL=C date -R`\">" >> $@
	echo "<!entity docversion \"CVS\">"             >> $@

# =================================================================== #
#                 Build rule part: Routine                            #
# =================================================================== #

# SGML

# Create starting SGML for each language from the template.  Actual
# contents reside in language segrigated subdirectories.

$(MANUAL).%.sgml: $(MANUAL0).sgml
	sed -e "s/@@@@/$*/g" $< > $(MANUAL).$*.sgml

# If sgml for original language "en" does not use mid-extension
#%.en.sgml: %.sgml
#	ln -sf $*.sgml $*.en.sgml

# HTML

$(MANUAL).%.html.stamp: $(MANUAL).%.sgml dynamic.%.ent $(SGMLSRCS)
	debiandoc2html    -l $* -c $<
# since $(MANUAL).%.html/index.%.html can not be a target file
	touch $(MANUAL).$*.html.stamp

# TXT

$(MANUAL).%.txt: $(MANUAL).%.sgml dynamic.%.ent $(SGMLSRCS)
	debiandoc2text -l $* $<

# PS

$(MANUAL).%.ps: $(MANUAL).%.sgml dynamic.%.ent $(SGMLSRCS)
	debiandoc2latexps -l $* $<

# PDF

$(MANUAL).%.pdf: $(MANUAL).%.sgml dynamic.%.ent $(SGMLSRCS)
	debiandoc2latexpdf -l $* $<

# TAR

$(MANUAL).tar.gz: $(TARSRCS)
	@tar cvzf $(MANUAL).tar.gz $(TARSRCS)

# =================================================================== #
#                 Build rule part: Web publish                        #
# =================================================================== #

publish-html: html
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	# install all html
	@$(foreach lang,$(LANGS),\
	 install -p -m 644 $(MANUAL).$(lang).html/*.html \
	          $(PUBLISHDIR)/$(MANUAL)/ ;\
	)
# sourceforge does not have auto language select apache server.
ifeq ("$(BUILD_TYPE)", "sf")
	install -p -m 644 index.php $(PUBLISHDIR)/$(MANUAL)/
endif
# Ugly but until updating all the web pages, needs these symlinks
ifeq ("$(BUILD_TYPE)", "web")
	cd $(PUBLISHDIR) ; rm -f quick-reference ; ln -sf $(MANUAL) quick-reference
	cd $(PUBLISHDIR) ; rm -Rf reference ; ln -sf $(MANUAL) reference
endif

publish-examples: $(EXAMPLES)
	test -d $(PUBLISHDIR)/$(MANUAL)/$(EXAMPLE) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)/$(EXAMPLE)
	@install -p -m 644  --preserve-timestamps \
	 `find $(EXAMPLE) -type f -maxdepth 1` $(PUBLISHDIR)/$(MANUAL)/$(EXAMPLE)/

publish-txt:  txt
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.txt
	$(foreach lang,$(LANGS), \
	   install -p -m 644 $(MANUAL).$(lang).txt $(PUBLISHDIR)/$(MANUAL)/ ; )

publish-ps:  ps
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.ps
	$(foreach lang,$(LANGS), \
	   install -p -m 644 $(MANUAL).$(lang).ps $(PUBLISHDIR)/$(MANUAL)/ ; )

publish-pdf:  pdf
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.pdf
	$(foreach lang,$(LANGS), \
	   install -p -m 644 $(MANUAL).$(lang).pdf $(PUBLISHDIR)/$(MANUAL)/ ; )

publish-tar: $(MANUAL).tar.gz
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).tar.gz
	install -p -m 644 $(MANUAL).tar.gz $(PUBLISHDIR)/$(MANUAL)/

#====[ sourceforge maint-script ]==============================================
sf:
	$(MAKE) BUILD_TYPE=sf "LANGS=en fr it fi pt es" scp

sf-test:
	$(MAKE) BUILD_TYPE=sf "LANGS=en fr it fi pt es" text

sf-clean:
	$(MAKE) BUILD_TYPE=sf distclean

scp: publish-all
	scp -pr $(PUBLISHDIR)/$(MANUAL)/ \
	$$USER@shell.sf.net:/home/groups/q/qr/qref/htdocs/ddp

#====[ validating SGML ]=======================================================
validate:
	set -x; for i in $(LANGS); do $(MAKE) validate.$$i ; done

validate.%: $(SGMLSRCS)
	nsgmls -gues -wall $(MANUAL).$*.sgml

#====[ cleaning up ]===========================================================
distclean: clean
	rm -rf $(PUBLISHDIR)/$(MANUAL)

clean:
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*,out,tov}
	rm -f *~ prior.aux pprior.aux tar.gz.log
	rm -f $(MANUAL).??.sgml *.error dynamic.??.ent date.ent $(MANUAL).tar.gz
	rm -rf $(MANUAL)*.html *stamp

.PHONY: all html text txt ps pdf files tar sf \
	publish publish-all publish-html publish-files publish-tar \
	clean distclean validate
