#
# New Makefile Template (Osamu Aoki)
#
#  Build html(multi-page), txt, ps, pdf, and other formats.
#
# $(MANUAL).xx.yyy are created in w.d.o/doc/manuals/$(MANUAL)
# xx  = en, fr, it, (LANGS)
# yyy = txt, pdf ... (EXTS)
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for the package build.
##-------------------------------------------------------------------##
##                          WARNING                                  ##
##         Use with caution, aimed at post-woody system              ##
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
MANUAL := debian-faq

# Publish directory
# This can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html

# The cannonical language, in which the original document is
ORIG_LANG := en

# List of langs (above the canonical one)
#LANGS := en de es fr it ja pl pt_BR ru
LANGS := en

# List of output format
# Possible values are EXTS=html txt tov pdf ps info
EXTS := html txt pdf

# maximum times we're willing to run TeX to get cross-references right, 
# if you subtract by 3 (taken from Adam di Carlo's boot-floppy trick)
MAX_TEX_RECURSION	:= 4

# List of publish target for DDP
publish: publish-html publish-files

# If sgml for original language does not use mid-extension
%.$(ORIG_LANG).sgml: %.sgml
	rm -f $*.$(ORIG_LANG).sgml
	ln -sf $*.sgml $*.$(ORIG_LANG).sgml

# If sgml for translated languages are in subdir
# must be enabled soon

# reverse compatibility for doc-debian (Just English)
html: $(MANUAL).en.html
	mv $(MANUAL).en.html $(MANUAL).html

txt: $(MANUAL).en.txt
	mv $(MANUAL).en.txt $(MANUAL).txt

pdf: $(MANUAL).en.pdf
	mv $(MANUAL).en.pdf $(MANUAL).pdf

# dynamic content
faqdynamic.ent:
	echo "<!entity docdate \"$(shell LC_ALL=C date +'%-d %B %Y')\">" > faqdynamic.ent
	if [ -f ../debian/changelog ]; then \
          echo "<!entity docversion \"` LC_ALL=C cd .. && dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//'`\">" >> faqdynamic.ent; \
        else \
          echo "<!entity docversion \"CVS\">" >> faqdynamic.ent; \
        fi
SOURCES := debian-faq.sgml faqstatic.ent faqdynamic.ent $(wildcard *.sgml)

# END OF CONF PART CHANGE THE END AT YOU OWN RISK
# =============================================================================

# List of html to be built
HTMLDIRS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).html)

# List of non-html EXTS
FILEEXTS := $(filter-out html,$(EXTS))

# List of non-html to be build
ALLFILES := $(foreach ext,$(FILEEXTS),\
	    $(foreach lang,$(LANGS),$(MANUAL).$(lang).$(ext))\
	  )

# List of ps to be build (compatibility)
PSFILES := $(foreach lang,$(LANGS),$(MANUAL).$(lang).ps)

# List of sgml to be build
#SGMLFILES := $(foreach lang,$(LANGS),$(MANUAL).$(lang).sgml)
SGMLFILES := $(MANUAL).sgml ru/$(MANUAL).sgml pt_BR/$(MANUAL).sgml

#====[ build rules ]===========================================================
# generate anything some dirs want version.ent to be builded, some not

DEBIAN=$(wildcard debian)
ifeq ($(DEBIAN),"debian")
all: version.ent $(HTMLDIRS) $(ALLFILES)
else
all: $(HTMLDIRS) $(ALLFILES)
endif

version.ent: debian/changelog
	./debian/rules $@


#----[ generating HTML ]-------------------------------------------------------
# FIXME: there is a trick because debiandoc2html does a sed 'y/.../...' 
#        which should be reverted to have the content negociation working.
#   This trick is bad. debiandoc2html should be corrected.
$(MANUAL).%.html: $(MANUAL).%.sgml faqstatic.ent faqdynamic.ent 
	debiandoc2html    -l $* -c $<
#	debiandoc2html -1 -l $* -c $<
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

#----[ generating plain text ]-------------------------------------------------
$(MANUAL).%.txt: $(MANUAL).%.sgml faqstatic.ent faqdynamic.ent 
	debiandoc2text -l $* $<

#----[ generating tov text ]---------------------------------------------------
$(MANUAL).%.tov: $(MANUAL).%.sgml faqstatic.ent faqdynamic.ent 
	debiandoc2textov -l $* $<

#----[ generating info ]-------------------------------------------------------
#$(MANUAL).%.info: $(MANUAL).%.sgml faqstatic.ent faqdynamic.ent 
#	debiandoc2info -l $* $<

# for now we avoid problem with above with followings
$(MANUAL).%.texinfo: $(MANUAL).%.sgml faqstatic.ent faqdynamic.ent 
	debiandoc2texinfo -l $* $<

$(MANUAL).%.info: $(MANUAL).%.texinfo
	makeinfo --force -v -o $(MANUAL).$*.info $(MANUAL).$*.texinfo

#----[ generating teTeX ]------------------------------------------------------
$(MANUAL).%.tex: $(MANUAL).%.sgml faqstatic.ent faqdynamic.ent 
	debiandoc2latex -l $* $<

#----[ generating PostScript ]-------------------------------------------------
$(MANUAL).%.ps: $(MANUAL).%.tex
#	debiandoc2latexps -l $* $<
# for now we avoid problem with above with followings
# note that I have seen bi-stable .aux files, thus we check two levels deep
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
$(MANUAL).%.pdf: $(MANUAL).%.tex
#	debiandoc2latexpdf -l $* $<
# for now we avoid problem with above with followings
# note that I have seen bi-stable .aux files, thus we check two levels deep
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

#====[ publishing to the DDP web pages ]=======================================
#----[ publish html ]----------------------------------------------------------
publish-html: $(HTMLDIRS)
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	# install all html
	@$(foreach lang,$(LANGS),\
	 install -p -m 644 $(MANUAL).$(lang).html/*.html $(PUBLISHDIR)/$(MANUAL)/;\
	)
	ln -sf $(PUBLISHDIR)/$(MANUAL)/index.$(ORIG_LANG).html\
	        $(PUBLISHDIR)/$(MANUAL)/index.html

#----[ publish all files except html ]-----------------------------------------
publish-files: $(ALLFILES)
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
	# make the symlinks for $(FILEEXTS)
	@$(foreach ext,$(FILEEXTS),\
	 ln -sf $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).$(ORIG_LANG).$(ext)\
	        $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).$(ext);\
	)

#----[ publish the ps ]--------------------------------------------------------
# Just in case external program uses this target (Doubtful)
publish-ps: $(PSFILES)
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.ps
	# install all ps
	@$(foreach lang,$(LANGS),\
	 install -p -m 644 $(MANUAL).$(lang).ps \
	                   $(PUBLISHDIR)/$(MANUAL)/ ;
	)
	# make the symlinks for ps
	ln -sf $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).$(ORIG_LANG).ps\
	       $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).ps

#====[ validating SGML ]=======================================================
validate: $(SGMLFILES)
	set -x; for i in $(SGMLFILES); do nsgmls -gues -wall $$i; done

#====[ cleaning up ]===========================================================
distclean: clean
	rm -rf $(PUBLISHDIR)/$(MANUAL)

clean:
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*,out,tov}
	rm -f *~ prior.aux pprior.aux $(MANUAL).en.sgml
	rm -rf $(MANUAL)*.html 

.PHONY: all publish\
	publish-html publish-ps publish-files\
	clean distclean validate \
	html txt ps
