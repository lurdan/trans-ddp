# Makefile for a manual in the Debian Documentation Project qref.sgml
# tree. ("Quick Reference" DDP compatible version)
########################################################################
# make [SFILE=qref] \
#      [TLANG=en|fr|it|...] [TFILE=qref2] [BOOK=qref] \
#      [INDEX=index] [DESTDIR=target] \
#      [PHPON=] [publish] \
#      [html] [text] [ps] [pdf] [scp] [date] [clean] [tar] [update] ...
########################################################################
# source file name (No language specifier part)
SFILE		:= qref
# target file name (for html: $(TFILE).html/)
TFILE		:= qref
# HTML start page
INDEX		:= index
# default language for build
TLANG		:= en
# default language for build (LATEX related specification)
LLANG		:= en
# build flag for SGML parse.
BOOK		:= qref
# url of this build.
URLHERE		:= ddp-page
# Where are we publishing to?
#  (this can be overriden by a higher level makefile)
#PUBLISHDIR :=	../../../public_html/qref.html
PUBLISHDIR :=	../public_html
## Set alternative values by command line
# target directory for packaging

# What do we want by default? (ddp)
all:		publish

#########################################################################
# programs for SGML output / validation
#DDOC		:= -d /usr/share/sgml/debiandoc/dtd/sgml/1.0/debiandoc.dcl
DDOC		:=
DEBIANDOC2HTML	:= debiandoc2html    $(DDOC) -l $(TLANG) -c 
DEBIANDOC2TEXT	:= debiandoc2text    $(DDOC) -l $(TLANG) 
DEBIANDOC2PS	:= debiandoc2ps      $(DDOC) -l $(TLANG) -v
DEBIANDOC2PDF	:= debiandoc2pdf     $(DDOC) -l $(TLANG) -v
NSGMLS		:= nsgmls -ges -wall $(DDOC) 
# How to install stuff in publish directory
install_file    := install -p -m 664
install_dir     := install -d -m 2775

# this for is used for dependencies
DEPENDS		:=  dynamic.ent default.ent custom.ent date.ent \
		    $(wildcard $(TLANG)/*.sgml) \
		    $(wildcard examples/*)
#############################################################################

DATE		:= `date --utc +"%Y.%m.%d-%H:%M"`

date.ent:
	: > $@			     # clear the file
	@echo "<!entity date \"$(DATE)\">" >> $@

# generate entities which are dynamically defined by the settings of this
# build run, generally set in the top-level config file (alway make)
dynamic.ent::
	: > $@			     # clear the file
	@echo "<!entity language \"$(TLANG)\">" >> $@
	@echo "<!entity % lang-$(TLANG) \"INCLUDE\">" >> $@
	@echo "<!entity booklet \"$(BOOK)\">" >> $@
	@echo "<!entity % $(BOOK) \"INCLUDE\">" >> $@
	@echo "<!entity % $(URLHERE) \"INCLUDE\">" >> $@

# Create starting SGML for each language from template
# Actual contents are in language segrigated subdirectory
# generic rules for all the languages to each language
$(TFILE).$(TLANG).sgml: $(SFILE).sgml
	sed -e "s/@@@@/$(TLANG)/g" $< > $@

# this is for php driven sf.net page
.PHONY: web
web: $(TFILE).html/$(INDEX).$(TLANG).html $(DEPENDS)
$(TFILE).html/$(INDEX).$(TLANG).html: $(TFILE).$(TLANG).sgml $(DEPENDS)
	$(DEBIANDOC2HTML) -t $(INDEX) -b $(TFILE) $< 2>_html-web.$(TLANG).err

# publish for ddp
.PHONY:	publish
publish: webs
	# fail if there is no PUBLISHDIR
	[ -d $(PUBLISHDIR) ] || exit 1
	rm -f $(PUBLISHDIR)/$(TFILE)/*.html
	$(install_dir) $(PUBLISHDIR)/$(TFILE)
	$(install_file) --preserve-timestamps \
	  $(TFILE).html/*.html $(PUBLISHDIR)/$(TFILE)/

# web page (auto-select language)
webs: date.ent
	make TLANG=en LLANG=en TFILE=$(TFILE) SFILE=$(SFILE) web
	make TLANG=fr LLANG=fr TFILE=$(TFILE) SFILE=$(SFILE) web
	make TLANG=it LLANG=it TFILE=$(TFILE) SFILE=$(SFILE) web
	# copy accompanying scripts from archive.
	cp -ap examples/ $(TFILE).html/
	# make sure link is not there first
	-rm -f $(TFILE)
	ln -sf $(TFILE).html $(TFILE)

.PHONY: update
update: sourceforge

.PHONY:	sourceforge
sourceforge: webs
	make TLANG=en LLANG=en TFILE=$(TFILE) SFILE=$(SFILE) text
	make TLANG=fr LLANG=fr TFILE=$(TFILE) SFILE=$(SFILE) text
	make TLANG=it LLANG=it TFILE=$(TFILE) SFILE=$(SFILE) text
	make tar
	# SF.NET server requires extention to be php
	cp -f index.php $(TFILE).html/index.php

# this is alternative html build for debian package 
# (Separate directory for language)
.PHONY: html
html: $(TLANG)/$(INDEX).html
$(TLANG)/$(INDEX).$(TLANG).html: $(TFILE).$(TLANG).sgml $(DEPENDS)
	$(DEBIANDOC2HTML) -t $(INDEX) -b $(TLANG) $< 2>_html.$(TLANG).err
	cd $(TLANG).html ; ln -sf $(INDEX).$(TLANG).html $(INDEX).html

.PHONY: text
text: $(TFILE).$(TLANG).txt	
$(TFILE).$(TLANG).txt: $(TFILE).$(TLANG).sgml $(DEPENDS)
#	$(DEBIANDOC2TEXT) $< 2>_text.err
	$(DEBIANDOC2TEXT) -O $< > $(TFILE).$(TLANG).txt 2>_text.$(TLANG).err

.PHONY:	tar
tar:
	tar cvzf $(TFILE).tar.gz *.ent $(SFILE).sgml $(SFILE).??.sgml  \
	         ./??/*.sgml ./examples/* Makefile index.php

.PHONY: ps
ps: $(TFILE).$(TLANG).ps
$(TFILE).$(TLANG).ps: $(TFILE).$(TLANG).sgml $(DEPENDS)
#	$(DEBIANDOC2PS) -O $< > $(TFILE).ps # trouble ??ace condition?
### if debiandoc* confuses when output file has long extention, use below.
#	-$(DEBIANDOC2PS) -b $(TFILEA).$(LINGUA) $<
# or
	$(DEBIANDOC2PS) -O $< > $(TFILE).ps 2>_ps.$(TLANG).err
	mv $(TFILE).ps $(TFILE).$(TLANG).ps

.PHONY: pdf
pdf: $(TFILE).$(TLANG).pdf
$(TFILE).$(TLANG).pdf: $(TFILE).$(TLANG).sgml $(DEPENDS)
#	$(DEBIANDOC2PDF) -O $< > $@ # trouble ?? race condition?
### if debiandoc* confuses when output file has long extention, use below.
#	-$(DEBIANDOC2PDF) -b $(TFILEA).$(LINGUA) $<
# or
	$(DEBIANDOC2PDF) -O $< > $(basename $(basename $@)).pdf 2>_pdf.$(TLANG).err
	mv $(basename $(basename $@)).pdf $@

# remote update source forge using woody box
scp: scpps scppdf

scpps: ps
	scp $(TFILE).$(TLANG).ps $$USER@shell.sf.net:/home/groups/q/qr/qref/htdocs/$(TFILE).$(TLANG).ps

#scppdf: pdf
scppdf: pdf
	scp $(TFILE).$(TLANG).pdf $$USER@shell.sf.net:/home/groups/q/qr/qref/htdocs/$(TFILE).$(TLANG).pdf


# ensure our SGML is valid for all TLANG
.PHONY: validate
validate:
	make TLANG=en TFILE=qref SFILE=qref lint
	make TLANG=fr TFILE=qref SFILE=qref lint
	make TLANG=it TFILE=qref SFILE=qref lint

# ensure our SGML is valid for a language
.PHONY: lint
lint: $(TFILE).$(TLANG).sgml $(DEPENDS)
#	@echo "Verifying SGML validity for language $(LINGUA):"
	$(NSGMLS) $(TFILE).$(TLANG).sgml
#	@echo "Checking for deprecated entity references:"
#	nsgmls -oentity /usr/lib/sgml/declaration/debiandoc.decl \
#	  $(TFILE).$(TLANG).sgml 2>/dev/null | sed -e '/^IMSG/!d' -e 's/^I/   /'

.PHONY:	scps
scps:
	make TLANG=en LLANG=en TFILE=$(TFILE) SFILE=$(SFILE) scp
	make TLANG=fr LLANG=fr TFILE=$(TFILE) SFILE=$(SFILE) scp
	make TLANG=it LLANG=en TFILE=$(TFILE) SFILE=$(SFILE) scp

.PHONY:	tar-web
tar-web: webs
	cd $(TFILE).html ; tar cvzf ../$(TFILE)-web.tar.gz .

.PHONY:	tar0
tar0:
	-tar cvzf ../$(TFILE).tar.gz .

.PHONY:	clean-junk
clean-junk: 
	-rm -f *.log *.aux *.bak *.out *.sasp* *.toc *.tex *.dvi
	-rm -f date.ent dynamic.ent *.??.sgml *.err
	-rm -f *~ *.orig \#* *.tar.gz

.PHONY:	clean
clean: clean-junk
	-rm -f *.txt *.pdf *.ps
	-rm -rf en.html fr.html it.html
	-rm -rf qref.html
	-rm -rf qref

.PHONY: distclean
distclean:	clean
