#
# New Makefile Template (Osamu Aoki)
#
#  Build html(multi-page), txt, ps, pdf, and other formats.
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for the package build.
# ------------------------------------------------------------------- #
#                          WARNING                                    #
#         Use with caution, aimed at Woody system                     #
#   "ps" and "pdf" tends to break in some ill-configured systems      #
# ------------------------------------------------------------------- #
# Read local texmf.cnf file

export TEXMFCNF=texmf/

# Following default shall be edited by the coordinator for the entire
# set of languages.  If a subsection owner wishes to override settings,
# they can be overridden by running make with "make 'LANGS1=fi'" etc.. 

# =================================================================== #
#                 Default configuration part: Customize               #
# =================================================================== #

# The directory in which this makefile resides must also contain a file
# called <directoryname>.[<language>.]sgml, which is the top-level file
# for the manual in this directory.

# Basename for language-dependent SGML (DDP default, generated)
#MANUAL := $(notdir $(CURDIR))
MANUAL1 := reference
MANUAL2 := quick-reference

# Basename for language-independent SGML-template.
MANUAL0 := qref

# Build type: Possible values are BUILD_TYPE = web|package|sf
BUILD_TYPE  := web

# Publish directory
# This can and will be overridden by a higher level makefile
PUBLISHDIR := ~/public_html/manuals.html

# List of languages built for "distclean" target for DDP:
LANGSALL := en fr it es fi pt-br de
# List of languages built for "publish" target for DDP: pt_BR
LANGS1 := en fr it es de
# subset which has Quick Reference subset document
LANGS2 := en

# Files which affect SGML generation (excluding *.sgml)
SGMLENTS := custom.ent default.ent

# All SGML source files
SGMLSRCS := $(foreach lang, $(LANGS1), $(MANUAL1).$(lang).sgml) \
	    $(foreach lang, $(LANGS2), $(MANUAL2).$(lang).sgml) \
	    $(foreach lang, $(subst pt-br,pt,$(LANGS1)), $(wildcard $(lang)/*.sgml ) ) \
	    $(SGMLENTS)

# Name for example directory
EXAMPLE := examples

# List of examples to be copied
EXAMPLES := $(wildcard $(EXAMPLE)/*)

TARSRCS = $(EXAMPLES) bin/* texmf/* $(SGMLSRCS) Makefile README index.php

# =================================================================== #
#                 Build target default part: Routine                  #
# =================================================================== #
# If some languages have problems building, filter-out in here.

### Full guide

# List of html stamp files to be built
HTMLS1 := $(foreach lang,$(LANGS1),$(MANUAL1).$(lang).html.stamp)

# List of pdf to be built
TXTS1 := $(foreach lang,$(LANGS1),$(MANUAL1).$(lang).txt)

# List of ps to be built
PSS1 := $(foreach lang,$(LANGS1),$(MANUAL1).$(lang).ps)

# List of pdf to be built
PDFS1 := $(foreach lang,$(LANGS1),$(MANUAL1).$(lang).pdf)

### QUICK guide

# List of html stamp files to be built
HTMLS2 := $(foreach lang,$(LANGS2),$(MANUAL2).$(lang).html.stamp)

# List of pdf to be built
TXTS2 := $(foreach lang,$(LANGS2),$(MANUAL2).$(lang).txt)

# List of ps to be built
PSS2 := $(foreach lang,$(LANGS2),$(MANUAL2).$(lang).ps)

# List of pdf to be built
PDFS2 := $(foreach lang,$(LANGS2),$(MANUAL2).$(lang).pdf)

# =================================================================== #
#                 Build target part: Customize                        #
# =================================================================== #
# If some languages have problems building, filter-out in here.

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

publish-index1:
	test -d $(PUBLISHDIR)/$(MANUAL1) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL1)
ifeq ("$(BUILD_TYPE)", "web")
	# Make index page for web
	@{ \
	echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">" ; \
	echo "<html>" ;\
	echo "<head>" ;\
	echo "<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">" ;\
	echo "<title>Debian Reference</title>" ;\
	echo "</head>" ;\
	echo "<body>" ;\
	echo "<hr>" ;\
	echo "<h1>Debian Reference</h1>" ;\
	echo "<hr>" ;\
	echo "<dl>" ;\
	} > $(PUBLISHDIR)/$(MANUAL1)/index.html
	@{$(foreach lang,$(LANGS1), \
	 . makeindexhtml "$(lang)" "$(MANUAL1)" ; ) } >> $(PUBLISHDIR)/$(MANUAL1)/index.html 
	@{ \
	echo "</dl>" ;\
	echo "</body>" ;\
	echo "</html>" ;\
	} >> $(PUBLISHDIR)/$(MANUAL1)/index.html
endif

publish-index2:
	test -d $(PUBLISHDIR)/$(MANUAL2) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL2)
ifeq ("$(BUILD_TYPE)", "web")
	# Make index page for web
	@{ \
	echo "<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">" ; \
	echo "<html>" ;\
	echo "<head>" ;\
	echo "<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">" ;\
	echo "<title>Debian Quick Reference</title>" ;\
	echo "</head>" ;\
	echo "<body>" ;\
	echo "<hr>" ;\
	echo "<h1>Debian Quick Reference</h1>" ;\
	echo "<hr>" ;\
	echo "<dl>" ;\
	} > $(PUBLISHDIR)/$(MANUAL2)/index.html
	@{$(foreach lang,$(LANGS2), \
	 . makeindexhtml "$(lang)" "$(MANUAL2)" ; ) } >> $(PUBLISHDIR)/$(MANUAL2)/index.html 
	@{ \
	echo "</dl>" ;\
	echo "</body>" ;\
	echo "</html>" ;\
	} >> $(PUBLISHDIR)/$(MANUAL2)/index.html
endif


publish: publish-html publish-txt publish-ps publish-pdf \
	publish-examples publish-index1 publish-index2

publish-all: publish publish-tar

# =================================================================== #
#                 Build rule part: If not package build               #
# =================================================================== #

## FULL
$(MANUAL1).%.ent:
	echo "<!ENTITY language \"$*\">"                 > $@
	echo "<!ENTITY % lang-$* \"INCLUDE\">"          >> $@
	echo "<!ENTITY docdate \"`LC_ALL=C date -R`\">" >> $@
	echo "<!ENTITY docversion \"CVS\">"             >> $@
	echo "<!ENTITY % f-ref   \"INCLUDE\">" >> $@ 
	echo "<!ENTITY % q-ref   \"IGNORE\">" >> $@ 

## QUICK
$(MANUAL2).%.ent:
	echo "<!ENTITY language \"$*\">"                 > $@
	echo "<!ENTITY % lang-$* \"INCLUDE\">"          >> $@
	echo "<!ENTITY docdate \"`LC_ALL=C date -R`\">" >> $@
	echo "<!ENTITY docversion \"CVS\">"             >> $@
	# if "Debian Quick Reference" (20 page max)
	echo "<!ENTITY % f-ref   \"IGNORE\">" >> $@ 
	echo "<!ENTITY % q-ref   \"INCLUDE\">" >> $@

# =================================================================== #
#                 Build rule part: Routine                            #
# =================================================================== #

# SGML

# Create starting SGML for each language from the template.  Actual
# contents reside in language-segregated subdirectories.

$(MANUAL1).%.sgml: $(MANUAL0).sgml
	sed -e "s/@@LANGS@@/$*/g" \
	    -e "s/@@DIRS@@/$(subst pt-br,pt,$*)/g" \
	    -e "s/@@NAME@@/$(MANUAL1)/g" \
	        $< > $(MANUAL1).$*.sgml

$(MANUAL2).%.sgml: $(MANUAL0).sgml
	sed -e "s/@@LANGS@@/$*/g" \
	    -e "s/@@DIRS@@/$(subst pt-br,pt,$*)/g" \
	    -e "s/@@NAME@@/$(MANUAL2)/g" \
	        $< > $(MANUAL2).$*.sgml

# If SGML for original language "en" does not use mid-extension
#%.en.sgml: %.sgml
#	ln -sf $*.sgml $*.en.sgml

# HTML

$(MANUAL1).%.html.stamp: $(MANUAL1).%.sgml  $(MANUAL1).%.ent $(SGMLSRCS)
	debiandoc2html -t$(MANUAL1) -l $(subst pt-br,pt_BR,$*) -c $<
# since $(MANUAL1).%.html/index.%.html cannot be a target file
	touch $(MANUAL1).$*.html.stamp
$(MANUAL2).%.html.stamp: $(MANUAL2).%.sgml  $(MANUAL2).%.ent $(SGMLSRCS)
	debiandoc2html -t$(MANUAL2) -l $(subst pt-br,pt_BR,$*) -c $<
# since $(MANUAL2).%.html/index.%.html cannot be a target file
	touch $(MANUAL2).$*.html.stamp

# TXT

$(MANUAL1).%.txt: $(MANUAL1).%.sgml $(MANUAL1).%.ent $(SGMLSRCS)
	debiandoc2text -l     $(subst pt-br,pt_BR,$*) $<

$(MANUAL2).%.txt: $(MANUAL2).%.sgml $(MANUAL2).%.ent $(SGMLSRCS)
	debiandoc2text -l     $(subst pt-br,pt_BR,$*) $<

# PS

$(MANUAL1).%.ps: $(MANUAL1).%.sgml $(MANUAL1).%.ent $(SGMLSRCS)
	debiandoc2latexps -l  $(subst pt-br,pt_BR,$*) $<

$(MANUAL2).%.ps: $(MANUAL2).%.sgml $(MANUAL2).%.ent $(SGMLSRCS)
	debiandoc2latexps -l  $(subst pt-br,pt_BR,$*) $<

# PDF

$(MANUAL1).%.pdf: $(MANUAL1).%.sgml $(MANUAL1).%.ent $(SGMLSRCS)
	debiandoc2latexpdf -l $(subst pt-br,pt_BR,$*) $<

$(MANUAL2).%.pdf: $(MANUAL2).%.sgml $(MANUAL2).%.ent $(SGMLSRCS)
	debiandoc2latexpdf -l $(subst pt-br,pt_BR,$*) $<

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
	cd $(PUBLISHDIR) ; rm -Rf reference
	cd $(PUBLISHDIR) ; rm -Rf debian-reference
endif
	test -d $(PUBLISHDIR)/$(MANUAL1) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL1)
	rm -f $(PUBLISHDIR)/$(MANUAL1)/*.html
	rm -f $(PUBLISHDIR)/$(MANUAL1)/README
	# install all html
	@$(foreach lang,$(LANGS1),\
	 install -p -m 644 $(MANUAL1).$(lang).html/*.html \
	          $(PUBLISHDIR)/$(MANUAL1)/ ;\
	)
# Ugly but until updating all the web pages, needs these symlinks
ifeq ("$(BUILD_TYPE)", "web")
	cd $(PUBLISHDIR) ; ln -sf $(MANUAL1) debian-reference
endif

publish-html2: html2
# Ugly but until updating all the web pages, needs these symlinks
ifeq ("$(BUILD_TYPE)", "web")
	cd $(PUBLISHDIR) ; rm -Rf quick-reference
endif
	test -d $(PUBLISHDIR)/$(MANUAL2) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL2)
	rm -f $(PUBLISHDIR)/$(MANUAL2)/*.html
	rm -f $(PUBLISHDIR)/$(MANUAL2)/README
	# install all html
	@$(foreach lang,$(LANGS2),\
	 install -p -m 644 $(MANUAL2).$(lang).html/*.html \
	          $(PUBLISHDIR)/$(MANUAL2)/ ;\
	)

publish-examples: $(EXAMPLES)
	test -d $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE)
	test -d $(PUBLISHDIR)/$(MANUAL2) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL2)
	cd $(PUBLISHDIR)/$(MANUAL2) ; ln -sf ../$(MANUAL1)/$(EXAMPLE) $(EXAMPLE)
	@install -p -m 644  --preserve-timestamps \
	 `find $(EXAMPLE) -type f -maxdepth 1` $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE)/


publish-txt:  publish-txt1 publish-txt2

publish-txt1:  txt1
	# install all txt1
	test -d $(PUBLISHDIR)/$(MANUAL1) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL1)
	rm -f $(PUBLISHDIR)/$(MANUAL1)/*.txt
	# install all txt1
	@$(foreach lang,$(LANGS1),\
	 install -p -m 644 $(MANUAL1).$(lang).txt \
	          $(PUBLISHDIR)/$(MANUAL1)/ ;\
	)

publish-txt2:  txt2
	# install all txt2
	test -d $(PUBLISHDIR)/$(MANUAL2) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL2)
	rm -f $(PUBLISHDIR)/$(MANUAL2)/*.txt
	# install all txt2
	@$(foreach lang,$(LANGS2),\
	 install -p -m 644 $(MANUAL2).$(lang).txt \
	          $(PUBLISHDIR)/$(MANUAL2)/ ;\
	)


publish-ps:  publish-ps1 publish-ps2

publish-ps1:  ps1
	# install all ps1
	test -d $(PUBLISHDIR)/$(MANUAL1) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL1)
	rm -f $(PUBLISHDIR)/$(MANUAL1)/*.ps
	# install all ps1
	@$(foreach lang,$(LANGS1),\
	 install -p -m 644 $(MANUAL1).$(lang).ps \
	          $(PUBLISHDIR)/$(MANUAL1)/ ;\
	)

publish-ps2:  ps2
	# install all txt2
	test -d $(PUBLISHDIR)/$(MANUAL2) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL2)
	rm -f $(PUBLISHDIR)/$(MANUAL2)/*.ps
	# install all txt2
	@$(foreach lang,$(LANGS2),\
	 install -p -m 644 $(MANUAL2).$(lang).ps \
	          $(PUBLISHDIR)/$(MANUAL2)/ ;\
	)


publish-pdf:  publish-pdf1 publish-pdf2

publish-pdf1:  pdf1
	# install all pdf1
	test -d $(PUBLISHDIR)/$(MANUAL1) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL1)
	rm -f $(PUBLISHDIR)/$(MANUAL1)/*.pdf
	# install all pdf1
	@$(foreach lang,$(LANGS1),\
	 install -p -m 644 $(MANUAL1).$(lang).pdf \
	          $(PUBLISHDIR)/$(MANUAL1)/ ;\
	)

publish-pdf2:  pdf2
	# install all pdf2
	test -d $(PUBLISHDIR)/$(MANUAL2) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL2)
	rm -f $(PUBLISHDIR)/$(MANUAL2)/*.pdf
	# install all pdf2
	@$(foreach lang,$(LANGS2),\
	 install -p -m 644 $(MANUAL2).$(lang).pdf \
	          $(PUBLISHDIR)/$(MANUAL2)/ ;\
	)

publish-tar: $(MANUAL1).tar.gz
	rm -f $(PUBLISHDIR)/$(MANUAL1).tar.gz
	install -p -m 644 $(MANUAL1).tar.gz $(PUBLISHDIR)/

#====[ DDP test-script ]==============================================
web:
	$(MAKE) BUILD_TYPE=web "LANGS1=en fr" "LANGS2=en" publish-all
#====[ sourceforge maint-script ]==============================================
sf:
	$(MAKE) scp BUILD_TYPE=sf "LANGS1=en fr it es fi de pt-br" "LANGS2=en"

sf-test:
	$(MAKE) BUILD_TYPE=sf "LANGS1=en fr it es fi de pt-br" "LANGS2=en" txt

sf-clean:
	$(MAKE) BUILD_TYPE=sf "LANGS1=en fr it es fi de pt-br" "LANGS2=en" distclean 

scp: publish-all
	echo SCP strat
	-ssh $$SFUSER@shell.sf.net rm -R /home/groups/q/qr/qref/htdocs/Debian
	ssh $$SFUSER@shell.sf.net install -d -m 755 /home/groups/q/qr/qref/htdocs/Debian/

	echo SCP README
	scp -p README \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/

	echo SCP $(MANUAL1)
	scp -pr $(PUBLISHDIR)/$(MANUAL1)/ \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/

	echo SCP $(MANUAL2)
	scp -pr $(PUBLISHDIR)/$(MANUAL2)/ \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/

	echo SCP $(MANUAL1).tar.gz
	scp -p $(PUBLISHDIR)/$(MANUAL1).tar.gz \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/

#====[ validating SGML ]=======================================================
validate:
	set -x; for i in $(LANGS1); do $(MAKE) validate1-$$i ; done
	set -x; for i in $(LANGS2); do $(MAKE) validate2-$$i ; done

validate1-%: $(SGMLSRCS) $(MANUAL1)-%.ent 
	nsgmls -gues -wall $(MANUAL1)-$*.sgml

validate2-%: $(SGMLSRCS) $(MANUAL2)-%.ent 
	nsgmls -gues -wall $(MANUAL2)-$*.sgml

#====[ cleaning up ]===========================================================
distclean: clean
	rm -f  $(PUBLISHDIR)/$(MANUAL1).tar.gz
	rm -Rf $(PUBLISHDIR)/$(MANUAL1)
	rm -Rf $(PUBLISHDIR)/$(MANUAL2)
	rm -f $(PUBLISHDIR)/debian-reference

clean:
	rm -f $(MANUAL1)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*,out,tov}
	rm -f $(MANUAL2)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*,out,tov}
	rm -f *~ prior.aux pprior.aux tar.gz.log
	rm -f $(MANUAL1).*.sgml *.error $(MANUAL1).*.ent date.ent $(MANUAL1).tar.gz
	rm -f $(MANUAL2).*.sgml *.error $(MANUAL2).*.ent date.ent $(MANUAL2).tar.gz
	rm -rf $(MANUAL1)*.html *stamp
	rm -rf $(MANUAL2)*.html *stamp

.PHONY: all html text txt ps pdf files tar sf \
	html1 text1 txt1 ps1 pdf1 files1 tar1 sf1 \
	html2 text2 txt2 ps2 pdf2 files2 tar2 sf2 \
	publish publish-all publish-html publish-files publish-tar \
	clean distclean validate

