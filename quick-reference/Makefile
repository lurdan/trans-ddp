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
# Read local texmf.cnf file
export TEXMFCNF=texmf/

# Following default shall be editted buy the cordinator for the entire
# set of languages.  If each subsection owner wish to overide settings,
# this can be overriden by running make with "make 'LANGS=fi'" etc.. 

# =================================================================== #
#                 Default configuration part: Customize               #
# =================================================================== #

# The directory in which this makefile resides must also contain a file
# called <directoryname>.[<language>.]sgml, which is the top-level file
# for the manual in this directory.

# Basename for language dependent sgml (DDP default, generated)
#MANUAL := $(notdir $(CURDIR))
MANUAL1 := reference
MANUAL2 := quick-reference

# Basename for language independent sgml-template.
MANUAL0 := qref

# Build type: Possible values are BUILD_TYPE = web|package|sf
BUILD_TYPE  := web

# Publish directory
# This can and will be overriden by a higher level makefile
PUBLISHDIR := ~/public_html/manuals.html

# List of languages build for "distclean" target for DDP:
LANGSALL := en fr it es fi pt
# List of languages build for "publish" target for DDP: pt_BR
LANGS1 := en fr it es
# subset which has Quick Reference subset document
LANGS2 := en
# apache web pages and packagename: use pt-br instead
WLANGS1=$(patsubst pt_BR,pt-br,$(LANGS1))
WLANGS2=$(patsubst pt_BR,pt-br,$(LANGS2))

# Files which affect SGML generation (excluding *.sgml)
SGMLENTS := custom.ent default.ent

# All SGML source files
SGMLSRCS := $(foreach lang, $(LANGS1), $(MANUAL1)-$(lang).sgml) \
	    $(foreach lang, $(LANGS2), $(MANUAL2)-$(lang).sgml) \
	    $(foreach lang, $(LANGS1), $(wildcard $(lang)/*.sgml ) ) \
	    $(SGMLENTS)

# Name for example directory
EXAMPLE := examples

# List of example to be copied
EXAMPLES := $(wildcard $(EXAMPLE)/*)

TARSRCS = $(EXAMPLES) bin/* texmf/* $(SGMLSRCS) Makefile README index.php

# =================================================================== #
#                 Build target default part: Routine                  #
# =================================================================== #
# If some languages have problem building, filter-out in here.

### Full guide

# List of html stamp files to be built
HTMLS1 := $(foreach lang,$(LANGS1),$(MANUAL1)-$(lang).html.stamp)

# List of pdf to be build
TXTS1 := $(foreach lang,$(LANGS1),$(MANUAL1)-$(lang).txt)

# List of ps to be build
PSS1 := $(foreach lang,$(LANGS1),$(MANUAL1)-$(lang).ps)

# List of pdf to be build
PDFS1 := $(foreach lang,$(LANGS1),$(MANUAL1)-$(lang).pdf)

### QUICK guide

# List of html stamp files to be built
HTMLS2 := $(foreach lang,$(LANGS2),$(MANUAL2)-$(lang).html.stamp)

# List of pdf to be build
TXTS2 := $(foreach lang,$(LANGS2),$(MANUAL2)-$(lang).txt)

# List of ps to be build
PSS2 := $(foreach lang,$(LANGS2),$(MANUAL2)-$(lang).ps)

# List of pdf to be build
PDFS2 := $(foreach lang,$(LANGS2),$(MANUAL2)-$(lang).pdf)

# =================================================================== #
#                 Build target part: Customize                        #
# =================================================================== #
# If some language have problem building, filter-out in here.

all: html txt ps pdf
html1: $(HTMLS1)
html2: $(HTMLS2)
html: html1 html2
text1 txt1:  $(TXTS1)
text2 txt2:  $(TXTS2)
text txt:  text1 text2
ps1:   $(PSS1)
ps2:   $(PSS2)
ps:   ps1 ps2
pdf1:  $(PDFS1)
pdf2:  $(PDFS2)
pdf:  pdf1 pdf2
tar:  $(MANUAL1).tar.gz

publish: publish-html publish-examples publish-txt publish-ps publish-pdf
publish-all: publish publish-tar

# =================================================================== #
#                 Build rule part: If not package build               #
# =================================================================== #

## FULL
$(MANUAL1)-%.ent:
	echo "<!entity language \"$*\">"                 > $@
	echo "<!entity % lang-$* \"INCLUDE\">"          >> $@
	echo "<!entity docdate \"`LC_ALL=C date -R`\">" >> $@
	echo "<!entity docversion \"CVS\">"             >> $@
	echo "<!entity % f-ref   \"INCLUDE\">" >> $@ 
	echo "<!entity % q-ref   \"IGNORE\">" >> $@ 

## QUICK
$(MANUAL2)-%.ent:
	echo "<!entity language \"$*\">"                 > $@
	echo "<!entity % lang-$* \"INCLUDE\">"          >> $@
	echo "<!entity docdate \"`LC_ALL=C date -R`\">" >> $@
	echo "<!entity docversion \"CVS\">"             >> $@
	# if "Debian Quick Reference" (20 page max)
	echo "<!entity % f-ref   \"IGNORE\">" >> $@ 
	echo "<!entity % q-ref   \"INCLUDE\">" >> $@

# =================================================================== #
#                 Build rule part: Routine                            #
# =================================================================== #

# SGML

# Create starting SGML for each language from the template.  Actual
# contents reside in language segrigated subdirectories.

$(MANUAL1)-%.sgml: $(MANUAL0).sgml
	sed -e "s/@@LANGS@@/$*/g" -e "s/@@NAME@@/$(MANUAL1)/g" \
	        $< > $(MANUAL1)-$*.sgml

$(MANUAL2)-%.sgml: $(MANUAL0).sgml
	sed -e "s/@@LANGS@@/$*/g" -e "s/@@NAME@@/$(MANUAL2)/g" \
	        $< > $(MANUAL2)-$*.sgml
# If sgml for original language "en" does not use mid-extension
#%-en.sgml: %.sgml
#	ln -sf $*.sgml $*.en.sgml

# HTML

$(MANUAL1)-%.html.stamp: $(MANUAL1)-%.sgml  $(MANUAL1)-%.ent $(SGMLSRCS)
	debiandoc2html -l $* -c $<
# since $(MANUAL1).%.html/index.%.html can not be a target file
	touch $(MANUAL1)-$*.html.stamp
$(MANUAL2)-%.html.stamp: $(MANUAL2)-%.sgml  $(MANUAL2)-%.ent $(SGMLSRCS)
	debiandoc2html -l $* -c $<
# since $(MANUAL2).%.html/index.%.html can not be a target file
	touch $(MANUAL2)-$*.html.stamp

# TXT

$(MANUAL1)-%.txt: $(MANUAL1)-%.sgml $(MANUAL1)-%.ent $(SGMLSRCS)
	debiandoc2text -l     $* $<

$(MANUAL2)-%.txt: $(MANUAL2)-%.sgml $(MANUAL2)-%.ent $(SGMLSRCS)
	debiandoc2text -l     $* $<

# PS

$(MANUAL1)-%.ps: $(MANUAL1)-%.sgml $(MANUAL1)-%.ent $(SGMLSRCS)
	debiandoc2latexps -l  $* $<

$(MANUAL2)-%.ps: $(MANUAL2)-%.sgml $(MANUAL2)-%.ent $(SGMLSRCS)
	debiandoc2latexps -l  $* $<

# PDF

$(MANUAL1)-%.pdf: $(MANUAL1)-%.sgml $(MANUAL1)-%.ent $(SGMLSRCS)
	debiandoc2latexpdf -l $* $<

$(MANUAL2)-%.pdf: $(MANUAL2)-%.sgml $(MANUAL2)-%.ent $(SGMLSRCS)
	debiandoc2latexpdf -l $* $<

# TAR

$(MANUAL1).tar.gz: $(TARSRCS)
	@tar cvzf $(MANUAL1).tar.gz $(TARSRCS)

# =================================================================== #
#                 Build rule part: Web publish                        #
# =================================================================== #

publish-html: publish-html1 publish-html2
publish-html1: html1
# Ugly but until updating all the web pages, needs these symlinks
ifeq ("$(BUILD_TYPE)", "web")
	cd $(PUBLISHDIR) ; rm -f reference
endif
	test -d $(PUBLISHDIR)/$(MANUAL1) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL1)
	rm -f $(PUBLISHDIR)/$(MANUAL1)/*.html
	rm -f $(PUBLISHDIR)/$(MANUAL1)/README
	# install all html
	@$(foreach lang,$(LANGS1),\
	 install -p -m 644 $(MANUAL1)-$(lang).html/*.html \
	          $(PUBLISHDIR)/$(MANUAL1)/ ;\
	)
# sourceforge does not have auto language select apache server.
ifeq ("$(BUILD_TYPE)", "sf")
	install -p -m 644 index.php $(PUBLISHDIR)/$(MANUAL1)/
endif
# Ugly but until updating all the web pages, needs these symlinks
ifeq ("$(BUILD_TYPE)", "web")
	cd $(PUBLISHDIR) ; rm -f debian-reference ; ln -sf $(MANUAL1) debian-reference
endif

publish-html2: html2
# Ugly but until updating all the web pages, needs these symlinks
ifeq ("$(BUILD_TYPE)", "web")
	cd $(PUBLISHDIR) ; rm -f quick-reference
endif
	test -d $(PUBLISHDIR)/$(MANUAL2) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL2)
	rm -f $(PUBLISHDIR)/$(MANUAL2)/*.html
	rm -f $(PUBLISHDIR)/$(MANUAL2)/README
	# install all html
	@$(foreach lang,$(LANGS2),\
	 install -p -m 644 $(MANUAL2)-$(lang).html/*.html \
	          $(PUBLISHDIR)/$(MANUAL2)/ ;\
	)
# sourceforge does not have auto language select apache server.
ifeq ("$(BUILD_TYPE)", "sf")
	install -p -m 644 index.php $(PUBLISHDIR)/$(MANUAL2)/
endif

publish-prep:
	$(foreach lang,$(LANGS1), \
	test -d $(PUBLISHDIR)/$(lang) \
	   || install -d -m 755 $(PUBLISHDIR)/$(lang) ; )

publish-examples: $(EXAMPLES)
	test -d $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE)
	@install -p -m 644  --preserve-timestamps \
	 `find $(EXAMPLE) -type f -maxdepth 1` $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE)/
	install -p -m 644 README $(PUBLISHDIR)/$(MANUAL1)/

publish-txt:  publish-txt1 publish-txt2

publish-txt1:  txt1 publish-prep
	$(foreach lang,$(LANGS1), \
	   rm -f $(PUBLISHDIR)/$(MANUAL1)-$(lang).txt ; \
	   install -p -m 644 $(MANUAL1)-$(lang).txt $(PUBLISHDIR)/$(lang)/ ;\
	   cd $(PUBLISHDIR)/$(lang)/ ; \
	   mv $(MANUAL1)-$(lang).txt $(MANUAL1).txt ; cd - ; )

publish-txt2:  txt2 publish-prep
	$(foreach lang,$(LANGS2), \
	   rm -f $(PUBLISHDIR)/$(MANUAL2)-$(lang).txt ; \
	   install -p -m 644 $(MANUAL2)-$(lang).txt $(PUBLISHDIR)/$(lang)/ ;\
	   cd $(PUBLISHDIR)/$(lang)/ ; \
	   mv $(MANUAL2)-$(lang).txt $(MANUAL2).txt ; cd - ; )

publish-ps: publish-ps1 publish-ps2 

publish-ps1:  ps1 publish-prep
	$(foreach lang,$(LANGS1), \
	   rm -f $(PUBLISHDIR)/$(MANUAL1)-$(lang).ps ; \
	   install -p -m 644 $(MANUAL1)-$(lang).ps $(PUBLISHDIR)/$(lang)/ ;\
	   cd $(PUBLISHDIR)/$(lang)/ ; \
	   mv $(MANUAL1)-$(lang).ps $(MANUAL1).ps  ; cd - ; )

publish-ps2:  ps2 publish-prep
	$(foreach lang,$(LANGS2), \
	   rm -f $(PUBLISHDIR)/$(MANUAL2)-$(lang).ps ; \
	   install -p -m 644 $(MANUAL2)-$(lang).ps $(PUBLISHDIR)/$(lang)/ ;\
	   cd $(PUBLISHDIR)/$(lang)/ ; \
	   mv $(MANUAL2)-$(lang).ps $(MANUAL2).ps  ; cd - ; )

publish-pdf:  publish-pdf1 publish-pdf2

publish-pdf1:  pdf1 publish-prep
	$(foreach lang,$(LANGS1), \
	   rm -f $(PUBLISHDIR)/$(MANUAL1)-$(lang).pdf ; \
	   install -p -m 644 $(MANUAL1)-$(lang).pdf $(PUBLISHDIR)/$(lang)/ ;\
	   cd $(PUBLISHDIR)/$(lang)/ ; \
	   mv $(MANUAL1)-$(lang).pdf $(MANUAL1).pdf ; cd - ; )

publish-pdf2:  pdf2 publish-prep
	$(foreach lang,$(LANGS2), \
	   rm -f $(PUBLISHDIR)/$(MANUAL2)-$(lang).pdf ; \
	   install -p -m 644 $(MANUAL2)-$(lang).pdf $(PUBLISHDIR)/$(lang)/ ;\
	   cd $(PUBLISHDIR)/$(lang)/ ; \
	   mv $(MANUAL2)-$(lang).pdf $(MANUAL2).pdf ; cd - ; )

publish-tar: $(MANUAL1).tar.gz
	rm -f $(PUBLISHDIR)/$(MANUAL1).tar.gz
	install -p -m 644 $(MANUAL1).tar.gz $(PUBLISHDIR)/

#====[ sourceforge maint-script ]==============================================
sf:
	$(MAKE) BUILD_TYPE=sf "LANGS1=en fr it fi pt es" "LANGS2=en" scp

sf-test:
	$(MAKE) BUILD_TYPE=sf "LANGS1=en fr it fi pt es" "LANGS2=en" text

sf-clean:
	$(MAKE) BUILD_TYPE=sf "LANGS1=en fr it fi pt es" "LANGS2=en" distclean 

scp: publish-all
	ssh $$SFUSER@shell.sf.net rm -R /home/groups/q/qr/qref/htdocs/Debian
	$(foreach lang,$(LANGS1), \
	  echo "Copy $(lang)" ; \
	  ssh $$SFUSER@shell.sf.net install -d /home/groups/q/qr/qref/htdocs/Debian/$(lang) ; \
	  scp -p $(PUBLISHDIR)/$(lang)/$(MANUAL1).* \
	  $$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(lang) ; )
	scp -pr $(PUBLISHDIR)/$(MANUAL1)/ \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian

	$(foreach lang,$(LANGS2), \
	  echo "Copy $(lang)" ; \
	  ssh $$SFUSER@shell.sf.net install -d /home/groups/q/qr/qref/htdocs/Debian/$(lang) ; \
	  scp -p $(PUBLISHDIR)/$(lang)/$(MANUAL2).* \
	  $$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(lang) ; )
	scp -pr $(PUBLISHDIR)/$(MANUAL2)/ \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian

	scp -p $(PUBLISHDIR)/$(MANUAL1).tar.gz \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian

#====[ validating SGML ]=======================================================
validate:
	set -x; for i in $(WLANGS1); do $(MAKE) validate1-$$i ; done
	set -x; for i in $(WLANGS2); do $(MAKE) validate2-$$i ; done

validate1-%: $(SGMLSRCS) $(MANUAL1)-%.ent 
	nsgmls -gues -wall $(MANUAL1)-$*.sgml

validate2-%: $(SGMLSRCS) $(MANUAL2)-%.ent 
	nsgmls -gues -wall $(MANUAL2)-$*.sgml

#====[ cleaning up ]===========================================================
distclean: clean
	$(foreach lang,$(LANGSALL), rm -rf $(PUBLISHDIR)/$(lang)/$(MANUAL1).* ; )
	$(foreach lang,$(LANGSALL), rm -rf $(PUBLISHDIR)/$(lang)/$(MANUAL2).* ; )
	rm -rf $(PUBLISHDIR)/$(MANUAL1).tar.gz
	rm -rf $(PUBLISHDIR)/$(MANUAL1)
	rm -rf $(PUBLISHDIR)/$(MANUAL2)
	rm -f $(PUBLISHDIR)/debian-reference

clean:
	rm -f $(MANUAL1)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*,out,tov}
	rm -f $(MANUAL2)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*,out,tov}
	rm -f *~ prior.aux pprior.aux tar.gz.log
	rm -f $(MANUAL1)-*.sgml *.error $(MANUAL1)-*.ent date.ent $(MANUAL1).tar.gz
	rm -f $(MANUAL2)-*.sgml *.error $(MANUAL2)-*.ent date.ent $(MANUAL2).tar.gz
	rm -rf $(MANUAL1)*.html *stamp
	rm -rf $(MANUAL2)*.html *stamp

.PHONY: all html text txt ps pdf files tar sf \
	html1 text1 txt1 ps1 pdf1 files1 tar1 sf1 \
	html2 text2 txt2 ps2 pdf2 files2 tar2 sf2 \
	publish publish-all publish-html publish-files publish-tar publish-prep \
	clean distclean validate
