#
# New Makefile Template (Osamu Aoki)
#
#  Build html(multi-page), txt, ps, pdf, and other formats.
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for the package build.
##-------------------------------------------------------------------##
##                          WARNING                                  ##
##         Use with caution, aimed at woody system                   ##
##   "ps" and "pdf" tends to break in some ill-configured system     ##
##-------------------------------------------------------------------##

# You must clean before any html build/publish



# ============================================================================
# CONF PART

# The directory in which this makefile resides must also contain a file
# called <directoryname>.sgml, which is the top-level file for the manual
# in this directory.

# Basename for sgml
#MANUAL := $(notdir $(shell pwd))

# Publish directory
# This can and will be overriden by a higher level makefile
#PUBLISHDIR := ../../../public_html/manuals.html

# The cannonical language, in which the original document is
ORIG_LANG := en

# List of langs (above the canonical one be included)
LANGS := en fr it
# For other languages to be build, run make with "make LANGS=fi" etc..
# Please do not add new languages until debian.sgml, tips.sgml, tune.sgml,
# support.sgml, titletoc.sgml, kernel.sgml, preface.sgml, install.sgml,
# and woody.sgml are all translated.

# List of output format
# Possible values are EXTS=html txt tov pdf ps info
EXTS := html ps pdf txt

# Build type
# Possible values are BUILD_TYPE = web|package|sf
BUILD_TYPE  := web

# List of publish target for DDP
all: html

publish: publish-files publish-html publish-examples

publish-all: publish publish-tar

# Set parameters by build environment
 
ifeq ("$(BUILD_TYPE)", "web")
# DDP site or checked out source from DDP
MANUAL := reference
PUBLISHDIR := ../../../public_html/manuals.html
else 
ifeq ("$(BUILD_TYPE)", "sf")
# For sourceforege remote build
MANUAL := qref
PUBLISHDIR := $$HOME/public_html
else
# Default: for Debian package
MANUAL := debian-reference
PUBLISHDIR := .
endif
endif
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for package build.
# Key source files
SGMLMSTR := qref.sgml
SGMLSRCS := custom.ent default.ent  dynamic.%.ent \
	    $(foreach lang, $(LANGS), $(wildcard $(lang)/*.sgml ) )

# generate entities which are dynamically defined by the settings of this
# build run, generally set in the top-level config file (always make)
# Make sure to enable locale by "dpkg-reconfigure locales".
# LOCALE needs fix

dynamic.%.ent:
	: > $@                       # clear the file
	echo "<!entity language \"$*\">" >> $@
	echo "<!entity % lang-$* \"INCLUDE\">" >> $@
ifneq ("$(BUILD_TYPE)", "package")
	echo "<!entity docdate \"`LC_ALL=C date -R`\">" >> $@
	echo "<!entity docversion \"CVS\">" >> $@
else
	echo "<!entity docversion \"$(shell \
		LC_ALL=C \
		dpkg-parsechangelog | \
		grep '^Version: ' | \
		sed 's/^Version: *//')\">" >> $@
	echo "<!entity docdate \"$(shell \
		LC_ALL=C \
		dpkg-parsechangelog | \
		grep '^Date: ' | \
		sed 's/^Date: *//')\">" >> $@
endif

# Create starting SGML for each language from template
# Actual contents are in language segrigated subdirectory
# generic rules for all the languages to each language

$(MANUAL).%.sgml: $(SGMLMSTR)
	sed -e "s/@@@@/$*/g" $< > $(MANUAL).$*.sgml

# If sgml for original language does not use mid-extension
#%.$(ORIG_LANG).sgml: %.sgml
#	cp -f $*.sgml $*.$(ORIG_LANG).sgml

sf:
	$(MAKE) BUILD_TYPE=sf scp

scp: publish-all
	scp -pr $(PUBLISHDIR)/$(MANUAL)/ \
	$$USER@shell.sf.net:/home/groups/q/qr/qref/htdocs/ddp

#----[ publish tar.gz files ]--------------------------------------------------
ifeq ("$(BUILD_TYPE)", "sf")
TARSRCS = examples/* bin/* ??/*.sgml\
	  Makefile index.php TODO PROJECT README
else
TARSRCS = examples/* bin/* ??/*.sgml\
	  Makefile TODO PROJECT README
endif

tar: $(MANUAL).tar.gz

$(MANUAL).tar.gz: $(TARSRCS)
	# make tar
	@tar cvzf $(MANUAL).tar.gz $(TARSRCS) >tar.gz.log


publish-tar: $(MANUAL).tar.gz
	# install tar
	@test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	@rm -f $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).tar.gz
	@install -p -m 644 $(MANUAL).tar.gz $(PUBLISHDIR)/$(MANUAL)/


publish-examples:
# 	install examples.  Excuse me for ugly script (skip CVS directory)
	@test -d $(PUBLISHDIR)/$(MANUAL)/examples \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)/examples
	@install -p -m 644  --preserve-timestamps \
	 examples/[_AIOa-z]* $(PUBLISHDIR)/$(MANUAL)/examples/


# END OF CONF PART CHANGE THE END AT YOU OWN RISK
# =============================================================================
# Build target (If some language have problem building, filter-out in here)

# List of html index files to be built
HTMLFILES := $(foreach lang,$(LANGS),$(MANUAL).$(lang).html.stamp)
html: $(HTMLFILES)

# List of pdf to be build (compatibility)
TXTFILES := $(foreach lang,$(LANGS),$(MANUAL).$(lang).txt)
txt: $(TXTFILES)

# List of ps to be build (compatibility)
PSFILES := $(foreach lang,$(LANGS),$(MANUAL).$(lang).ps)
ps: $(PSFILES)

# List of pdf to be build (compatibility)
PDFFILES := $(foreach lang,$(LANGS),$(MANUAL).$(lang).ps)
pdf: $(PDFFILES)

# List of sgml to be build
SGMLFILES := $(foreach lang,$(LANGS),$(MANUAL).$(lang).sgml)

# List of non-html EXTS
FILEEXTS := $(filter-out html,$(EXTS))

# List of non-html to be build
ALLFILES := $(foreach ext,$(FILEEXTS),\
	    $(foreach lang,$(LANGS),$(MANUAL).$(lang).$(ext))\
	  )
files: $(ALLFILES)

#----[ generating HTML ]-------------------------------------------------------
# FIXME: there is a trick because debiandoc2html does a sed 'y/.../...' 
#        which should be reverted to have the content negociation working.
#   This trick is bad. debiandoc2html should be corrected.

$(MANUAL).%.html.stamp: $(MANUAL).%.sgml $(SGMLSRCS)
	debiandoc2html    -l $* -c $<
	@echo "cleaning up file extensions";\
	for file in `ls $(MANUAL).$*.html/*` ; do\
	 newfile=`echo $$file|\
	          sed 's/$(shell echo $*|\
	      sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ_/abcdefghijklmnopqrstuvwxyz-/'\
	                  )\.html/$*\.html/'`;\
	 if [ $$file != $$newfile ] ; then\
	   mv $$file $$newfile;\
	 fi\
	done;
# since $(MANUAL).%.html/index.%.html can not be a target
	touch $(MANUAL).$*.html.stamp

#----[ generating plain text ]-------------------------------------------------
$(MANUAL).%.txt: $(MANUAL).%.sgml $(SGMLSRCS)
	debiandoc2text -l $* $<

#----[ generating tov text ]---------------------------------------------------
$(MANUAL).%.tov: $(MANUAL).%.sgml $(SGMLSRCS)
	debiandoc2textov -l $* $<

#----[ generating info ]-------------------------------------------------------
$(MANUAL).%.info: $(MANUAL).%.sgml
	debiandoc2info -l $* $<

# for now we avoid problem with above with followings
#$(MANUAL).%.texinfo: $(MANUAL).%.sgml $(SGMLSRCS)
#	debiandoc2texinfo -l $* $<

#$(MANUAL).%.info: $(MANUAL).%.texinfo
#	cp $(MANUAL).$*.texinfo $(MANUAL)-keep.$*.texinfo
#	makeinfo --force -v -o $(MANUAL).$*.info $(MANUAL).$*.texinfo

#----[ generating PostScript ]-------------------------------------------------
#$(MANUAL).%.ps: $(MANUAL).%.sgml $(SGMLSRCS)
#	debiandoc2latexps -l $* $<

#----[ generating PDF ]--------------------------------------------------------
#$(MANUAL).%.pdf: $(MANUAL).%.sgml $(SGMLSRCS)
#	debiandoc2latexpdf -l $* $<

#====[ publishing to the DDP web pages ]=======================================
#----[ publish html ]----------------------------------------------------------
publish-html: html
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	# install all html
	@$(foreach lang,$(LANGS),\
	 install -p -m 644 $(MANUAL).$(lang).html/*.html $(PUBLISHDIR)/$(MANUAL)/;\
	)
ifeq ("$(BUILD_TYPE)", "sf")
	install -p -m 644 index.php $(PUBLISHDIR)/$(MANUAL)/
	cd $(PUBLISHDIR) ; rm -f quick-reference ; ln -sf $(MANUAL) quick-reference
endif

#----[ publish all files except html ]-----------------------------------------
publish-files: files
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	# clear all old non-html: $(FILEEXTS)
	@$(foreach ext,$(FILEEXTS),\
	 if [ "$(ext)" == "info" ] ; then \
	  rm -f $(PUBLISHDIR)/$(MANUAL)/*.info*;\
	 else \
	  rm -f $(PUBLISHDIR)/$(MANUAL)/*.$(ext);\
	 fi ;\
	)
	# install all non-html: $(FILEEXTS)
	@$(foreach ext,$(FILEEXTS),\
	 $(foreach lang,$(LANGS),\
	  if [ "$(ext)" == "info" ] ; then \
	   install -p -m 644 $(MANUAL).$(lang).info* $(PUBLISHDIR)/$(MANUAL)/;\
	  else \
	   install -p -m 644 $(MANUAL).$(lang).$(ext) $(PUBLISHDIR)/$(MANUAL)/;\
	  fi ;\
	 )\
	)
# DDP
ifeq ("$(BUILD_TYPE)", "web")
	# make the symlinks for $(FILEEXTS)
	@$(foreach ext,$(FILEEXTS),\
	  if [ "$(ORIG_LANG)" != "" ] ; then\
	    ( cd $(PUBLISHDIR)/$(MANUAL); \
	      rm -f $(MANUAL).$(ext);\
	      ln -s $(MANUAL).$(ORIG_LANG).$(ext) $(MANUAL).$(ext); \
	    ) \
	  fi ;\
	)
	@$(foreach ext,$(FILEEXTS),\
	 $(foreach lang,$(ORIG_LANG) $(LANGS),\
	   ( cd $(PUBLISHDIR)/$(MANUAL) ; \
	     rm -f quick-reference.$(lang).$(ext);\
	     ln -sf $(MANUAL).$(lang).$(ext) quick-reference.$(lang).$(ext);\
	    ) ;\
	  )\
	)
endif

#====[ validating SGML ]=======================================================
validate: $(MANUAL).en.sgml dynamic.en.ent 
	set -x; for i in $(MANUAL).en.sgml; do nsgmls -gues -wall $$i; done

#====[ cleaning up ]===========================================================
distclean: clean
	rm -rf $(PUBLISHDIR)/$(MANUAL)

clean:
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*,out,tov}
	rm -f *~ prior.aux pprior.aux tar.gz.log
	rm -f $(MANUAL).??.sgml *.error dynamic.??.ent date.ent $(MANUAL).tar.gz
	rm -rf $(MANUAL)*.html *.stamp build-stamp

.PHONY: all html txt ps pdf files tar sf \
	publish publish-all publish-html publish-files publish-tar \
	clean distclean validate

###########--------------------------------------------------------------
# maximum times we're willing to run TeX to get cross-references right, 
# if you subtract by 3
MAX_TEX_RECURSION	:= 6
#----[ generating teTeX ]------------------------------------------------------
$(MANUAL).%.tex: $(MANUAL).%.sgml dynamic.%.ent  $(SGMLSRCS)
	debiandoc2latex -l $* $<

#----[ generating PostScript ]-------------------------------------------------
#$(MANUAL).%.ps: $(MANUAL).%.sgml date.ent dynamic.%.ent 
#	debiandoc2latexps -l $* $<

# debiandoc2latexps is broken. Imitate Makefile in boot-floppies
$(MANUAL).%.ps:	$(MANUAL).%.tex dynamic.%.ent  $(SGMLSRCS)
#	 note that I have seen bi-stable .aux files, thus we check two levels deep
	@-cp -pf prior.aux pprior.aux 2>/dev/null
	@-cp -pf $(basename $<).aux prior.aux 2>/dev/null
#	 fail if we don't have pdflatex correctly installed
	@kpsewhich latex.fmt >/dev/null
#	 due to a bug in debiandoc2latex2e output, this might fail
	@-latex '\nonstopmode\input{$<}' >/dev/null 
	# see $(@:.ps=.log) for details
	dvips -t `cat /etc/papersize` -o $(MANUAL).$*.ps $(MANUAL).$*
	@set -e								;\
	if ! cmp $(basename $<).aux prior.aux 2>/dev/null &&		\
	   ! cmp $(basename $<).aux pprior.aux 2>/dev/null; then	\
		if expr $(MAKELEVEL) '<' $(MAX_TEX_RECURSION) >/dev/null;\
		then							\
		   echo ">>> remaking $@ (take $(MAKELEVEL))"		;\
		   rm -f $@						;\
		   $(MAKE) $@						;\
		else							\
		   echo "E: $@ needs remaking, but we have reached max. level, $(MAX_TEX_RECURSION)" ;\
		fi							\
	fi
	@rm -f prior.aux pprior.aux

#----[ generating PDF ]--------------------------------------------------------
# for translated languages
#$(MANUAL).%.pdf: $(MANUAL).%.sgml date.ent dynamic.%.ent 
#	debiandoc2latexpdf -l $* $<

# debiandoc2latexpdf is broken. Imitate Makefile in boot-floppies
$(MANUAL).%.pdf: $(MANUAL).%.tex dynamic.%.ent $(SGMLSRCS)
#	 note that I have seen bi-stable .aux files, thus we check two levels deep
	@-cp -pf prior.aux pprior.aux 2>/dev/null
	@-cp -pf $(basename $<).aux prior.aux 2>/dev/null
#	 fail if we don't have pdflatex correctly installed
	@kpsewhich pdflatex.fmt >/dev/null
#	 due to a bug in debiandoc2latex2e output, this might fail
	@-pdflatex '\nonstopmode\input{$<}' >/dev/null 
	# see $(@:.pdf=.log) for details
	@set -e								;\
	if ! cmp $(basename $<).aux prior.aux 2>/dev/null &&		\
	   ! cmp $(basename $<).aux pprior.aux 2>/dev/null; then	\
		if expr $(MAKELEVEL) '<' $(MAX_TEX_RECURSION) >/dev/null;\
		then							\
		   echo ">>> remaking $@ (take $(MAKELEVEL))"		;\
		   rm -f $@						;\
		   $(MAKE) $@						;\
		else							\
		   echo "E: $@ needs remaking, but we have reached max. level, $(MAX_TEX_RECURSION)" ;\
		fi							\
	fi
	@rm -f prior.aux pprior.aux
