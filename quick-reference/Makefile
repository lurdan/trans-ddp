#
# Makefile for the Debian reference
#
#====[ customization ]=========================================================
##### CONF PART 
# The cannonical language, in which the original document is
ORIG_LANG := en
# All languages
ALL_LANGS := en fr it pt es
# target languages
LANGS := en
# Target file type (html ps pdf txt tov info)
EXTS := html txt
# publish directory (default for all DDP)
# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html
# build flag for SGML parse.
BOOK    := qref
# Document type, dev always include, stable, always exclude, 
# default, include for english
#DOCTYPE := dev
#DOCTYPE := default
#DOCTYPE := stable
DOCTYPE := default
# Set parameters by build environment
# build dir type               site type      languages  ; format         
# `pwd`/.. -> manuals.sgml -> DDP/DDP mirror  en, fr, it ; html,txt, ps, pdf
# `pwd`/.. -> htdocs       -> sourceforge.net en         ; html
# `pwd`/.. -> $HOME        -> normal account  en         ; html
# 
HTDOCS := $(notdir $(patsubst %/,%, $(dir $(shell pwd))))
ifeq ("$(HTDOCS)", "manuals.sgml")
# DDP site or checked out source from DDP
PUBLISHDIR := ../../../public_html/manuals.html
MANUAL := $(notdir $(shell pwd))
else
# default: checked out source at home directory
PUBLISHDIR := $$HOME/public_html
MANUAL := qref
endif
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for package build.
# Key source files
SGMLMSTR := qref.sgml
SGMLSRCS := custom.ent default.ent  dynamic.%.ent date.ent \
	    $(foreach lang, $(ALL_LANGS), $(wildcard $(lang)/*.sgml ) )
TARSRCS = examples/* bin/* ??/*.sgml\
	  Makefile index.php TODO PROJECT README
ALLSRCS := $(SGMLSRCS)


##### END OF CONF PART
#====[ build rules ]===========================================================
# what will be built
TARGETS := $(foreach ext,$(EXTS),\
	    $(foreach lang,$(LANGS),$(MANUAL).$(lang).$(ext))\
	  )
HTMLDIRS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).html)
FILEEXTS = $(filter-out html,$(EXTS))
ALLFILES = $(foreach ext,$(FILEEXTS),\
	    $(foreach lang,$(LANGS),$(MANUAL).$(lang).$(ext))\
	  )

# maximum times we're willing to run TeX to get cross-references right, 
# if you subtract by 3
MAX_TEX_RECURSION	:= 6

# generate anything some dirs want version.ent to be built, some not

DEBIAN=$(wildcard debian)
ifeq ($(DEBIAN),"debian")
all: version.ent $(TARGETS) publish
else
all: $(TARGETS) publish
endif

version.ent: debian/changelog
	./debian/rules $@

DATE := `date --utc +"%Y.%m.%d-%H:%M"`

date.ent:
	: > $@                       # clear the file
	@echo "<!entity date \"$(DATE)\">" >> $@

# generate entities which are dynamically defined by the settings of this
# build run, generally set in the top-level config file (always make)

dynamic.%.ent:
	: > $@                       # clear the file
	@echo "<!entity language \"$*\">" >> $@
	@echo "<!entity % lang-$* \"INCLUDE\">" >> $@
	@echo "<!entity booklet \"$(BOOK)\">" >> $@
	@echo "<!entity % $(BOOK) \"INCLUDE\">" >> $@
	@echo "<!entity docdate \"$(shell LC_ALL=C date +'%-d %B %Y')\">" >> $@
	@if [ -f ../debian/changelog ]; then \
	  echo "<!entity docversion \"` LC_ALL=C cd .. && dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//'`\">" >> $@; \
	else \
	  echo "<!entity docversion \"CVS\">" >> $@; \
	fi
#	Build SGML with portion marked qref-dev if LANGS=en or DOCTYPE=dev.
	@if [ "x$(DOCTYPE)" = "xdev" ]; then \
	  echo "<!entity % qref-dev \"INCLUDE\">" >> $@; \
	elif [ "x$(DOCTYPE)" = "xdefault" -a "x$(LANGS)" = "xen" ]; then \
	  echo "<!entity % qref-dev \"INCLUDE\">" >> $@; \
	else \
	  echo "<!entity % qref-dev \"IGNORE\">" >> $@; \
	fi
# Note: This does work, but it's a hack, it
# needs to be rewritten properly (jfs)
#
# I know.  But for now, I need to avoid circular dependence. (OA)
#
# Create starting SGML for each language from template
# Actual contents are in language segrigated subdirectory
# generic rules for all the languages to each language
$(MANUAL).%.sgml: $(SGMLMSTR)
	sed -e "s/@@@@/$*/g" $< > $(MANUAL).$*.sgml

#----[ generating HTML ]-------------------------------------------------------
# FIXME: there is a trick because debiandoc2html does a sed 'y/.../...' 
#        which should be reverted to have the content negociation working.
#   This trick is bad. debiandoc2html should be corrected.
$(MANUAL).%.html: $(MANUAL).%.sgml $(SGMLSRCS)
	debiandoc2html -l $* -c $< 2>_html.$*.error
	@for file in `ls $(MANUAL).$*.html/*` ; do\
	 newfile=`echo $$file|\
	          sed 's/$(shell echo $*|\
	      sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ_/abcdefghijklmnopqrstuvwxyz-/'\
	                  )\.html/$*\.html/'`;\
	 if [ $$file != $$newfile ] ; then\
	   mv $$file $$newfile;\
	   echo "Rename $$file --> $$newfile";\
	 fi\
	done;   

#----[ generating plain text ]-------------------------------------------------
$(MANUAL).%.txt: $(MANUAL).%.sgml dynamic.%.ent date.ent $(SGMLSRCS)
	debiandoc2text -l $* $< 2>_txt.$*.error

#----[ generating tov ]--------------------------------------------------------
$(MANUAL).%.tov: $(MANUAL).%.sgml dynamic.%.ent date.ent $(SGMLSRCS)
	debiandoc2textov -l $* $<

#----[ generating info ]-------------------------------------------------------
$(MANUAL).%.texinfo: $(MANUAL).%.sgml dynamic.%.ent date.ent $(SGMLSRCS)
	debiandoc2texinfo -l $* $<
# Buggy, Top must be moved manually

#----[ generating info ]-------------------------------------------------------
#$(MANUAL).%.info: $(MANUAL).%.sgml date.ent dynamic.%.ent 
#	debiandoc2info -l $* $<

# for now we avoid problem
$(MANUAL).%.info: $(MANUAL).%.texinfo dynamic.%.ent date.ent $(SGMLSRCS)
	@#makeinfo -v -o $(MANUAL).$*.info $(MANUAL).$*.texinfo
	makeinfo --force -v -o $(MANUAL).$*.info $(MANUAL).$*.texinfo


#----[ generating teTeX ]------------------------------------------------------
$(MANUAL).%.tex: $(MANUAL).%.sgml dynamic.%.ent date.ent $(SGMLSRCS)
	debiandoc2latex -l $* $<

#----[ generating PostScript ]-------------------------------------------------
#$(MANUAL).%.ps: $(MANUAL).%.sgml date.ent dynamic.%.ent 
#	debiandoc2latexps -l $* $<

# debiandoc2latexps is broken. Imitate Makefile in boot-floppies
$(MANUAL).%.ps:	$(MANUAL).%.tex dynamic.%.ent date.ent $(SGMLSRCS)
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
$(MANUAL).%.pdf: $(MANUAL).%.tex dynamic.%.ent date.ent $(SGMLSRCS)
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

#====[ publishing to the DDP web pages ]=======================================
publish: publish-html publish-files publish-tar

#----[ publish html ]----------------------------------------------------------
publish-html: $(HTMLDIRS)
	# install for all language (html)
	@test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	@$(foreach lang,$(LANGS),\
	  rm -f $(PUBLISHDIR)/$(MANUAL)/*.$(lang).html ;\
	  install -p -m 644 $(MANUAL).$(lang).html/*.html $(PUBLISHDIR)/$(MANUAL)/;)
# 	install examples.  Excuse me for ugly script (skip CVS directory)
	@test -d $(PUBLISHDIR)/$(MANUAL)/examples \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)/examples
	@install -p -m 644  --preserve-timestamps \
	 examples/[_AIOa-z]* $(PUBLISHDIR)/$(MANUAL)/examples/
ifneq ("$(HTDOCS)", "manuals.sgml")
	install -p -m 644 index.php $(PUBLISHDIR)/$(MANUAL)/
endif

#----[ publish the files ]-----------------------------------------------------
publish-files: $(ALLFILES)
	@echo "# install for ext=$(EXTS), LANGS=$(LANGS), and ORIG_LANG=$(ORIG_LANG)"
	@test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	@$(foreach ext,$(FILEEXTS),\
	 $(foreach lang,$(ORIG_LANG) $(LANGS),\
	  rm -f $(PUBLISHDIR)/$(MANUAL)/*.$(lang).$(ext);\
	  install -p -m 644 $(MANUAL).$(lang).$(ext)\
	                    $(PUBLISHDIR)/$(MANUAL)/;\
	  )\
	)
ifeq ("$(HTDOCS)", "manuals.sgml")
	# soft link $(FILEEXTS)
	@$(foreach ext,$(FILEEXTS),\
	  if [ "$(ORIG_LANG)" != "" ] ; then\
	    ( cd $(PUBLISHDIR)/$(MANUAL); \
	      rm -f $(MANUAL).$(ext);\
	      ln -s $(MANUAL).$(ORIG_LANG).$(ext) $(MANUAL).$(ext); \
	    ) \
	  fi ;\
	)
endif

#----[ publish tar.gz files ]--------------------------------------------------
publish-tar: $(MANUAL).tar.gz
	# install tar
	@test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	@rm -f $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).tar.gz
	@install -p -m 644 $(MANUAL).tar.gz $(PUBLISHDIR)/$(MANUAL)/

#====[ validating SGML ]=======================================================
validate: $(SGMLSRCS)
	set -x; for i in $(wildcard $(MANUAL).*.sgml); \
	  do nsgmls -ges -wall $$i; done

#====[ Saving SGML tar ]=======================================================
.PHONY:	tar
tar: $(MANUAL).tar.gz
$(MANUAL).tar.gz: $(TARSRCS)
	# make tar
	@tar cvzf $(MANUAL).tar.gz $(TARSRCS) 2>_tar.error 1>&2
	
#====[ cleaning up ]===========================================================
neat:
	rm -f $(MANUAL)*.{dvi,log,tex,aux,toc,sasp*} *~
	rm -f $(MANUAL).??.sgml *.error dynamic.??.ent

clean: neat
	rm -f $(MANUAL)*.{txt,tov,texinfo,out,ps,pdf,info*,tar.gz} date.ent
	rm -rf $(MANUAL)*.html

distclean: clean
	rm -rf $(PUBLISHDIR)/$(MANUAL)/

scp: publish
	scp -pr $(PUBLISHDIR)/$(MANUAL)/ \
	$$USER@shell.sf.net:/home/groups/q/qr/qref/htdocs/qref

debug: 
	# TARGETS   = $(TARGETS)
	# HTMLDIRS  = $(HTMLDIRS)
	# ALLFILES  = $(ALLFILES)
#	# SGMLSRCS  = $(SGMLSRCS)
	# MANUAL    = $(MANUAL)
	# EXTS     = $(EXTS)
	# FILEEXTS = $(FILEEXTS)

.PHONY: all scp target tar validate debug\
	publish xpublish publish-html publish-files publish-tar \
	neat clean distclean 
	# 	$(TARGETS) $(HTMLDIRS)
