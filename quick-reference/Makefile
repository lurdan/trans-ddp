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

export TEXMFCNF=texmf:

# do not use default suffix rules such as .tex.dvi: (uses tex, not latex!)
.SUFFIXES:

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

# Build option
BILD_OPT := 

# Basename for language-independent SGML-template and tar-ball name.
MANUAL0 := qref

# Build type: Possible values are BUILD_TYPE = web|package|sf
BUILD_TYPE  := web

# Publish directory
# This can and will be overridden by a higher level makefile
ifeq ("$(BUILD_TYPE)", "sf")
PUBLISHDIR := ~/public_html
else
PUBLISHDIR := /org/www.debian.org/www/doc/manuals
endif

# Locales for "distclean" target for the DDP:
LANGSALL := en fr it es de pt-br pl zh-tw zh-cn ja ru
# Locale list of "publish" target for the DDP full documents:
LANGS1 :=   en fr it es de pt-br pl zh-tw zh-cn ja ru
# Locale list of "publish" target for the DDP short documents:
LANGS2 :=   en fr it es de pt-br pl zh-tw zh-cn ja ru

# Files which affect SGML generation (excluding *.sgml)
SGMLENTS := default.ent

# All SGML source files
SGMLSRCS := $(foreach lang, $(LANGS1), $(MANUAL1).$(lang).sgml) \
	    $(foreach lang, $(LANGS2), $(MANUAL2).$(lang).sgml) \
	    $(foreach lang, $(LANGS1), $(wildcard $(lang)/*.sgml ) ) \
	    $(SGMLENTS)

# Name for example directory
EXAMPLE := examples

# List of examples to be copied
EXAMPLES := $(wildcard $(EXAMPLE)/*)

TARSRCS = $(EXAMPLES) bin/* texmf/* $(SGMLSRCS) Makefile README 
# =================================================================== #
#                 Build target default part: Routine                  #
# =================================================================== #
all: html txt ps pdf README

### Full guide

# List of html stamp files to be built
HTMLS1 := $(foreach lang,$(LANGS1),$(MANUAL1).$(lang).html.stamp)

# List of txt to be built
TXTS1 := $(foreach lang,$(LANGS1),$(MANUAL1).$(lang).txt)

# List of dvi to be built
DVIS1 := $(foreach lang,$(LANGS1),$(MANUAL1).$(lang).dvi)

# List of ps to be built
PSS1 := $(foreach lang,$(LANGS1),$(MANUAL1).$(lang).ps)

# List of pdf to be built
PDFS1 := $(foreach lang,$(LANGS1),$(MANUAL1).$(lang).pdf)

### QUICK guide

# List of html stamp files to be built
HTMLS2 := $(foreach lang,$(LANGS2),$(MANUAL2).$(lang).html.stamp)

# List of txt to be built
TXTS2 := $(foreach lang,$(LANGS2),$(MANUAL2).$(lang).txt)

# List of dvi to be built
DVIS2 := $(foreach lang,$(LANGS2),$(MANUAL2).$(lang).dvi)

# List of ps to be built
PSS2 := $(foreach lang,$(LANGS2),$(MANUAL2).$(lang).ps)

# List of pdf to be built
PDFS2 := $(foreach lang,$(LANGS2),$(MANUAL2).$(lang).pdf)

# =================================================================== #
#                 Build target part: Customize                        #
# =================================================================== #
# If some languages have problems building, filter-out in here.

html1: $(HTMLS1)
html2: $(HTMLS2)
html: html1 html2
text1 txt1:  $(TXTS1)
text2 txt2:  $(TXTS2)
text txt:  text1 text2
dvi1:   $(DVIS1)
dvi2:   $(DVIS2)
dvi:   dvi1 dvi2
ps1:   $(PSS1)
ps2:   $(PSS2)
ps:   ps1 ps2
pdf1:  $(PDFS1)
pdf2:  $(PDFS2)
pdf:  pdf1 pdf2
tar:  $(MANUAL1).tar.gz
publish: publish-html publish-txt publish-examples publish-ps publish-pdf
publish-all: publish publish-tar

# =================================================================== #
#                 Build rule part: If not package build               #
# =================================================================== #

## FULL
$(MANUAL1).%.ent:
	echo "<!ENTITY language \"$*\">"                 > $@
	echo "<!ENTITY % lang-$* \"INCLUDE\">"          >> $@
	echo "<!ENTITY docdate \"$$(bin/getdocdate $*)\">" >> $@
	echo "<!ENTITY docversion \"CVS\">"             >> $@
	echo "<!ENTITY % f-ref   \"INCLUDE\">" >> $@ 
	echo "<!ENTITY % q-ref   \"IGNORE\">" >> $@ 

## QUICK
$(MANUAL2).%.ent:
	echo "<!ENTITY language \"$*\">"                 > $@
	echo "<!ENTITY % lang-$* \"INCLUDE\">"          >> $@
	echo "<!ENTITY docdate \"$$(bin/getdocdate $*)\">" >> $@
	echo "<!ENTITY docversion \"CVS\">"             >> $@
	# if "Debian Quick Reference" (about 20 pages max)
	echo "<!ENTITY % f-ref   \"IGNORE\">" >> $@ 
	echo "<!ENTITY % q-ref   \"INCLUDE\">" >> $@

# Version list
README: README.org
	-bin/doc-check -ha  >README.html
	-w3m -dump -cols 78 README.html >README.txt
	sed -e "/^  ----------------------------------------------------------------------------/r README.txt"  \
	   <README.org >README
	-rm README.html README.txt

# =================================================================== #
#                 Build rule part: Routine                            #
# =================================================================== #

# SGML

# Create starting SGML for each language from the template.  Actual
# contents reside in language-segregated subdirectories.

$(MANUAL1).%.sgml: $(MANUAL0).sgml
	sed -e "s/@@LANGS@@/$*/g" \
	    -e "s/@@DIRS@@/$*/g" \
	    -e "s/@@NAME@@/$(MANUAL1)/g" \
	        $< > $(MANUAL1).$*.sgml

$(MANUAL2).%.sgml: $(MANUAL0).sgml
	sed -e "s/@@LANGS@@/$*/g" \
	    -e "s/@@DIRS@@/$*/g" \
	    -e "s/@@NAME@@/$(MANUAL2)/g" \
	        $< > $(MANUAL2).$*.sgml

# If SGML for original language "en" does not use mid-extension
#%.en.sgml: %.sgml
#	ln -sf $*.sgml $*.en.sgml

# HTML

$(MANUAL1).%.html.stamp: $(MANUAL1).%.sgml  $(MANUAL1).%.ent $(SGMLSRCS)
	ln -sf fix.html.ent fix.ent
	debiandoc2html $(BUILD_OPT) -t$(MANUAL1) -l $$(echo $* | bin/getlocale) -c $<
	bin/fixhtml $* $(MANUAL1).$*.html
# since $(MANUAL1).%.html/index.%.html cannot be a target file
	touch $(MANUAL1).$*.html.stamp

$(MANUAL2).%.html.stamp: $(MANUAL2).%.sgml  $(MANUAL2).%.ent $(SGMLSRCS)
	ln -sf fix.html.ent fix.ent
	debiandoc2html $(BUILD_OPT) -t$(MANUAL2) -l $$(echo $* | bin/getlocale) -c $<
	bin/fixhtml $* $(MANUAL2).$*.html
# since $(MANUAL2).%.html/index.%.html cannot be a target file
	touch $(MANUAL2).$*.html.stamp

# TXT

$(MANUAL1).%.txt: $(MANUAL1).%.sgml $(MANUAL1).%.ent $(SGMLSRCS)
	ln -sf fix.txt.ent fix.ent
	debiandoc2text $(BUILD_OPT) -l     $$(echo $* | bin/getlocale) $<
	bin/fixtxt $* $(MANUAL1).$*.txt

$(MANUAL2).%.txt: $(MANUAL2).%.sgml $(MANUAL2).%.ent $(SGMLSRCS)
	ln -sf fix.txt.ent fix.ent
	debiandoc2text $(BUILD_OPT) -l     $$(echo $* | bin/getlocale) $<
	bin/fixtxt $* $(MANUAL2).$*.txt

# generate LaTeX format file with all necessary languages preloaded
 
# even if language.dat is in . it isn't found without setting TEXINPUTS
# (. is always in path, so I do not understand this!)

latex.fmt: texmf/language.dat
	TEXINPUTS=$$(pwd)/texmf/:$$(kpsetool -n tex -p tex) \
	fmtutil --byfmt latex --fmtdir .

pdflatex.fmt: texmf/language.dat
	TEXINPUTS=$$(pwd)/texmf/:$$(kpsetool -n pdftex -p tex) \
	fmtutil --byfmt pdflatex --fmtdir .

# required by thumbpdf (called from debiandoc2latexpdf)
pdftex.fmt: texmf/language.dat
	TEXINPUTS=$$(pwd)/texmf/:$$(kpsetool -n pdftex -p tex) \
	fmtutil --byfmt pdftex --fmtdir .

# DVI

$(MANUAL1).%.dvi: $(MANUAL1).%.sgml $(MANUAL1).%.ent $(SGMLSRCS) latex.fmt
	ln -sf fix.latex.ent fix.ent
	bin/debiandoc2latexdvi $(BUILD_OPT) -l  $$(echo $* | bin/getlocale) $<

$(MANUAL2).%.dvi: $(MANUAL2).%.sgml $(MANUAL2).%.ent $(SGMLSRCS) latex.fmt
	ln -sf fix.latex.ent fix.ent
	bin/debiandoc2latexdvi $(BUILD_OPT) -l  $$(echo $* | bin/getlocale) $<

# PS

$(MANUAL1).%.ps: $(MANUAL1).%.sgml $(MANUAL1).%.ent $(SGMLSRCS) latex.fmt
	ln -sf fix.latex.ent fix.ent
	bin/debiandoc2latexps $(BUILD_OPT) -l  $$(echo $* | bin/getlocale) $<

$(MANUAL2).%.ps: $(MANUAL2).%.sgml $(MANUAL2).%.ent $(SGMLSRCS) latex.fmt
	ln -sf fix.latex.ent fix.ent
	bin/debiandoc2latexps $(BUILD_OPT) -l  $$(echo $* | bin/getlocale) $<

# PDF

$(MANUAL1).%.pdf: $(MANUAL1).%.sgml $(MANUAL1).%.ent $(SGMLSRCS) \
                  pdflatex.fmt pdftex.fmt %/hyperref-full.cfg
	ln -sf fix.latex.ent fix.ent
	ln -sf $*/hyperref-full.cfg hyperref.cfg
	bin/debiandoc2latexpdf $(BUILD_OPT) -l $$(echo $* | bin/getlocale) $<

$(MANUAL2).%.pdf: $(MANUAL2).%.sgml $(MANUAL2).%.ent $(SGMLSRCS) \
                  pdflatex.fmt pdftex.fmt %/hyperref-quick.cfg
	ln -sf fix.latex.ent fix.ent
	ln -sf $*/hyperref-quick.cfg hyperref.cfg
	bin/debiandoc2latexpdf $(BUILD_OPT) -l $$(echo $* | bin/getlocale) $<

# TAR

$(MANUAL0).tar.gz: $(TARSRCS)
	@tar cvzf $(MANUAL0).tar.gz $(TARSRCS)

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
	@install -p -m 644  --preserve-timestamps \
	 `find $(EXAMPLE) -type f -maxdepth 1` $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE)/
# these were for linda but lintian complains. so disabled
#	chmod 700 $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE)/go-woody
#	chmod 700 $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE)/fetchmail
#	chmod 775 $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE)/backup

# No more example for short document
#	test -d $(PUBLISHDIR)/$(MANUAL2) \
#	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL2)
#	cd $(PUBLISHDIR)/$(MANUAL2) ; rm -f $(EXAMPLE) ; ln -sf ../$(MANUAL1)/$(EXAMPLE) $(EXAMPLE)


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


publish-tar: $(MANUAL0).tar.gz
	rm -f $(PUBLISHDIR)/$(MANUAL0).tar.gz
	install -p -m 644 $(MANUAL0).tar.gz $(PUBLISHDIR)/

#====[ DDP test-script ]==============================================
web:
	$(MAKE) BUILD_TYPE=web "LANGS1=en fr" "LANGS2=en" publish-all
#====[ sourceforge maint-script ]==============================================
sf-proto:
	$(MAKE) sf-clean    BUILD_TYPE=sf LANGS1="$(LANGS1)" LANGS2="$(LANGS2)"
	$(MAKE) publish-all BUILD_TYPE=sf LANGS1="$(LANGS1)" LANGS2="$(LANGS2)"
	$(MAKE) scp-all     BUILD_TYPE=sf LANGS1="$(LANGS1)" LANGS2="$(LANGS2)"

sf:
	if [ "x$(LANGS)" = "x" ]; then \
		LANGS="en fr it es pt-br de pl zh-tw zh-cn ja ru" ;\
	fi ;\
	$(MAKE) sf-proto \
	 "LANGS1=$$LANGS" \
	 "LANGS2=$$LANGS" 

sf-test:
	$(MAKE) txt BUILD_TYPE=sf \
	 "LANGS1=en fr it es pt-br de pl zh-tw zh-cn ja ru" \
	 "LANGS2=en fr it es pt-br de pl zh-tw zh-cn ja ru"

sf-clean:
	$(MAKE) distclean   BUILD_TYPE=sf \
	 "LANGS1=en fr it es pt-br de pl zh-tw zh-cn ja ru" \
	 "LANGS2=en fr it es pt-br de pl zh-tw zh-cn ja ru"

scp-all:
	$(MAKE) scp-init BUILD_TYPE=sf
	$(MAKE) scp0     BUILD_TYPE=sf
	$(MAKE) scp1     BUILD_TYPE=sf
	$(MAKE) scp2     BUILD_TYPE=sf
	$(MAKE) scp3     BUILD_TYPE=sf

scp-init:
	echo SCP all files
#	-ssh $$SFUSER@shell.sf.net rm -R /home/groups/q/qr/qref/htdocs/Debian
	ssh $$SFUSER@shell.sf.net install -d -m 2775 -g qref /home/groups/q/qr/qref/htdocs/Debian/$(MANUAL1)/
	ssh $$SFUSER@shell.sf.net install -d -m 2775 -g qref /home/groups/q/qr/qref/htdocs/Debian/$(MANUAL1)/$(EXAMPLE)/
	ssh $$SFUSER@shell.sf.net install -d -m 2775 -g qref /home/groups/q/qr/qref/htdocs/Debian/$(MANUAL2)/

scp0:
	echo SCP README
	scp -pC README \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/
	echo SCP $(MANUAL0).tar.gz
	scp -p $(PUBLISHDIR)/$(MANUAL0).tar.gz \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/

scp1:
	echo SCP $(MANUAL1) html
	scp -prC $(PUBLISHDIR)/$(MANUAL1)/*.html \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(MANUAL1)/

	echo SCP $(MANUAL1) $(EXAMPLE)
	scp -prC $(PUBLISHDIR)/$(MANUAL1)/$(EXAMPLE)/* \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(MANUAL1)/$(EXAMPLE)/

	echo SCP $(MANUAL1) txt
	scp -prC $(PUBLISHDIR)/$(MANUAL1)/*.txt \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(MANUAL1)/

	echo SCP $(MANUAL1) PS
	scp -prC $(PUBLISHDIR)/$(MANUAL1)/*.ps \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(MANUAL1)/

	echo SCP $(MANUAL1) PDF
	scp -prC $(PUBLISHDIR)/$(MANUAL1)/*.pdf \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(MANUAL1)

scp2:
	echo SCP $(MANUAL2) html
	scp -prC $(PUBLISHDIR)/$(MANUAL2)/*.html \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(MANUAL2)/

	echo SCP $(MANUAL2) txt
	scp -prC $(PUBLISHDIR)/$(MANUAL2)/*.txt \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(MANUAL2)/

	echo SCP $(MANUAL2) PS
	scp -prC $(PUBLISHDIR)/$(MANUAL2)/*.ps \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(MANUAL2)/

	echo SCP $(MANUAL2) PDF
	scp -prC $(PUBLISHDIR)/$(MANUAL2)/*.pdf \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/Debian/$(MANUAL2)/

scp3: manual.html.stamp
	echo SCP manual.html
	scp -prC manual.html/*.html \
	$$SFUSER@shell.sf.net:/home/groups/q/qr/qref/htdocs/doc/

#====[ validating SGML ]=======================================================
validate:
	set -x; for i in $(LANGS1); do $(MAKE) validate1-$$i ; done
	set -x; for i in $(LANGS2); do $(MAKE) validate2-$$i ; done

validate1-%: $(SGMLSRCS) $(MANUAL1).%.ent 
	nsgmls -gues -wall $(MANUAL1).$*.sgml

validate2-%: $(SGMLSRCS) $(MANUAL2).%.ent 
	nsgmls -gues -wall $(MANUAL2).$*.sgml

# check hyphenations created by LaTeX against {en,...}/validLaTeX.hyphen
check-hyphen:
	for i in $(LANGS1); do $(MAKE) check-hyphen1-$$i ; done
	for i in $(LANGS2); do $(MAKE) check-hyphen2-$$i ; done

check-hyphen1-%: $(MANUAL1).%.dvi
	hyphen_show $(MANUAL1).$*.dvi $*/validLaTeX.hyphen

check-hyphen2-%: $(MANUAL2).%.dvi
	hyphen_show $(MANUAL2).$*.dvi $*/validLaTeX.hyphen

#====[ check all URLs ]========================================================
check-urls:
	for i in $(LANGS1); do $(MAKE) check-urls1-$$i ; done
	for i in $(LANGS2); do $(MAKE) check-urls2-$$i ; done

define CHECK_URLS # one argument $1: reference or quick-reference
# Bug: Woody's wget hangs during http://localhost:631 check 
	for file in $(1).$*.html/*.html; do \
	  sed 's|http://localhost:631/|Ignore this wrong URL/|g' $$file | \
	  wget --spider --non-verbose --force-html \
	       --base=$(1).$*.html/ -i - 2>&1 | \
          grep -v '^200 OK$$' | grep -v '^ *$$'; \
	done || true
endef

check-urls1-%: $(MANUAL1).%.html.stamp
	$(call CHECK_URLS,$(MANUAL1))

check-urls2-%: $(MANUAL2).%.html.stamp
	$(call CHECK_URLS,$(MANUAL2))

#====[ manual ]================================================================

manual.txt: manual.sgml
	debiandoc2text manual.sgml

manual.html.stamp: manual.sgml
	debiandoc2html manual.sgml
	touch manual.html.stamp
	
#====[ cleaning up ]===========================================================
distclean: clean
	make "PUBLISHDIR=~/public_html/" publish-clean
	make publish-clean

publish-clean:
	rm -f  $(PUBLISHDIR)/$(MANUAL0).tar.gz
	rm -Rf $(PUBLISHDIR)/$(MANUAL1)
	rm -Rf $(PUBLISHDIR)/$(MANUAL2)
	rm -f $(PUBLISHDIR)/debian-reference

clean_SUFFIXES := txt ps dvi pdf info* log tex aux toc sasp* out tov tpt hyp

clean:
	rm -f $(addprefix $(MANUAL1).*.,$(clean_SUFFIXES))
	rm -f $(addprefix $(MANUAL2).*.,$(clean_SUFFIXES))
	rm -f *~ prior.aux pprior.aux *.log typescript README README.html
	rm -f latex.fmt pdflatex.fmt pdftex.fmt
	rm -f latex.log pdflatex.log pdftex.log
	rm -f *.tex[01]pdf *.tex[01]ps
	rm -f $(MANUAL0).tar.gz fix.ent hyperref.cfg
	rm -f $(MANUAL1).*.sgml *.error $(MANUAL1).*.ent
	rm -f $(MANUAL2).*.sgml *.error $(MANUAL2).*.ent
	rm -rf $(MANUAL1)*.html *stamp
	rm -rf $(MANUAL2)*.html *stamp
	rm -f manual.txt
	rm -rf manual.html
	rm -f manual.html.stamp

.PHONY: all html text txt ps pdf files tar sf \
	html1 text1 txt1 ps1 pdf1 files1 tar1 sf1 \
	html2 text2 txt2 ps2 pdf2 files2 tar2 sf2 \
	publish publish-all publish-tar \
	publish-txt publish-html publish-ps publish-pdf \
	publish-txt1 publish-html1 publish-ps1 publish-pdf1 \
	publish-txt2 publish-html2 publish-ps2 publish-pdf2 \
	clean distclean validate

