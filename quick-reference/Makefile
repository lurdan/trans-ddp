#
# Makefile for the Debian reference
#
##### CONF PART 
# this can and will be overriden by a higher level makefile
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for package build.
# build dir type               site type            org; languages; format         
# `pwd`/.. -> manuals.sgml  -> DDP/DDP mirror       en;      ; html,txt
# `pwd`/.. -> htdocs        -> sourceforge.net      en; fr,it; html,txt
# `pwd`/.. -> $HOME         -> normal user account  en; fr,it; html,txt
# 
HTDOCS := $(notdir $(patsubst %/,%, $(dir $(shell pwd))))
ifeq ("$(HTDOCS)", "manuals.sgml")
# DDP site or checked out source from DDP
PUBLISHDIR := ../../../public_html/manuals.html
MANUAL := $(notdir $(shell pwd))
# The cannonical language, in which the original document is
ORIG_LANG := en
# list of langs (above the canonical one)
LANGS := fr it
# Because Latex is hard to work with, I just to do text for now
#EXTS := ps pdf txt tov info
EXTS := txt ps pdf
else
ifeq ("$(HTDOCS)", "htdocs")
# qref.sourceforge.net
PUBLISHDIR := .
MANUAL := qref
# The cannonical language, in which the original document is
ORIG_LANG := en
# list of langs (above the canonical one)
LANGS := 
# Because Latex is hard to work with, I just to do text for now
#EXTS=ps pdf txt tov info
EXTS := txt
else
# default: checked out source from qref.sourceforge.net
PUBLISHDIR := $$HOME/public_html
MANUAL := qref
# The cannonical language, in which the original document is
ORIG_LANG := en
# list of langs (above the canonical one)
LANGS := fr it
# Because Latex is hard to work with, I just to do text for now
#EXTS=ps pdf txt tov info
EXTS := txt
endif
endif

# build flag for SGML parse.
BOOK            := qref
##### END OF CONF PART CHANGE THE END AT YOU OWN RISK

# what will be built
HTMLDIRS=$(foreach lang,$(ORIG_LANG) $(LANGS),$(MANUAL).$(lang).html)
ALLFILES=$(foreach ext,$(EXTS),\
	    $(foreach lang,$(ORIG_LANG) $(LANGS),$(MANUAL).$(lang).$(ext))\
	  )
SGMLSRC = custom.ent default.ent qref.sgml  \
	 ./??/*.sgml ./examples/* Makefile index.php \
	 TODO PROJECT README ./bin/* 

# maximum times we're willing to run TeX to get cross-references right, if you subtract by 3
MAX_TEX_RECURSION	:= 9

#====[ build rules ]===========================================================
# generate anything some dirs want version.ent to be built, some not

DEBIAN=$(wildcard debian)
ifeq ($(DEBIAN),"debian")
all: version.ent $(HTMLDIRS) $(ALLFILES) publish
else
all: $(HTMLDIRS) $(ALLFILES) publish
endif

sf: $(HTMLDIRS) $(ALLFILES)

version.ent: debian/changelog
	./debian/rules $@

DATE            := `date --utc +"%Y.%m.%d-%H:%M"`

# --- build sgml
#
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
#	Build SGML with portion marked qref-dev in English (Testing at SF.NET)
	@if [ "$(MANUAL)" = "qref" -a "$*" = "en" ]; then \
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
$(MANUAL).%.sgml: qref.sgml 
	sed -e "s/@@@@/$*/g" $< > $(MANUAL).$*.sgml

#----[ generating HTML ]-------------------------------------------------------
# for orig_lang
#$(MANUAL).html: $(MANUAL).$(ORIG_LANG).sgml date.ent dynamic.en.ent
#	debiandoc2html -l $(ORIG_LANG) -c $< 2>_html.error

# for any  languages
# FIXME: there is a trick because debiandoc2html does a sed 'y/.../...' 
#        which should be reverted to have the content negociation working.

#   This trick is bad. debiandoc2html should be corrected.
$(MANUAL).%.html: $(MANUAL).%.sgml date.ent dynamic.%.ent
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
# for orig_lang
#$(MANUAL).$(ORIG_LANG).txt: $(MANUAL).$(ORIG_LANG).sgml date.ent dynamic.en.ent
#	debiandoc2text -l $(ORIG_LANG) $< 2>_txt.error

# for translated languages
$(MANUAL).%.txt: $(MANUAL).%.sgml date.ent dynamic.%.ent
	debiandoc2text -l $* $< 2>_txt.$*.error

#----[ generating tov ]--------------------------------------------------------
# for orig_lang
#$(MANUAL).$(ORIG_LANG).tov: $(MANUAL).$(ORIG_LANG).sgml
#	debiandoc2textov -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.tov: $(MANUAL).%.sgml date.ent dynamic.%.ent 
	debiandoc2textov -l $* $<

#----[ generating info ]-------------------------------------------------------
# for orig_lang
#$(MANUAL).$(ORIG_LANG).texinfo: $(MANUAL).$(ORIG_LANG).sgml
#	debiandoc2texinfo -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.texinfo: $(MANUAL).%.sgml date.ent dynamic.%.ent 
	debiandoc2texinfo -l $* $<

# Buggy, Top must be moved manually

#----[ generating info ]-------------------------------------------------------
# for orig_lang
#$(MANUAL).$(ORIG_LANG).info: $(MANUAL).$(ORIG_LANG).sgml
#	debiandoc2info -l $(ORIG_LANG) -c $<

# for translated languages
#$(MANUAL).%.info: $(MANUAL).%.sgml date.ent dynamic.%.ent 
#	debiandoc2info -l $* $<

# for now we avoid problem
$(MANUAL).%.info: $(MANUAL).%.texinfo
	@#makeinfo -v -o $(MANUAL).$*.info $(MANUAL).$*.texinfo
	makeinfo --force -v -o $(MANUAL).$*.info $(MANUAL).$*.texinfo


#----[ generating teTeX ]------------------------------------------------------
$(MANUAL).%.tex: $(MANUAL).%.sgml date.ent dynamic.%.ent 
	debiandoc2latex -l $* $<

#----[ generating PostScript ]-------------------------------------------------
# for orig_lang
#$(MANUAL).$(ORIG_LANG).ps: $(MANUAL).$(ORIG_LANG).sgml date.ent dynamic.%.ent 
#	debiandoc2latexps -l $(ORIG_LANG) -c $<

# for translated languages
#$(MANUAL).%.ps: $(MANUAL).%.sgml date.ent dynamic.%.ent 
#	debiandoc2latexps -l $* $<

# debiandoc2latexps is broken. Imitate Makefile in boot-floppies
$(MANUAL).%.ps:	$(MANUAL).%.tex
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
# for orig_lang
#$(MANUAL).$(ORIG_LANG).pdf: $(MANUAL).$(ORIG_LANG).sgml
#	debiandoc2latexpdf -l $(ORIG_LANG) -c $<

# for translated languages
#$(MANUAL).%.pdf: $(MANUAL).%.sgml date.ent dynamic.%.ent 
#	debiandoc2latexpdf -l $* $<

# debiandoc2latexpdf is broken. Imitate Makefile in boot-floppies
$(MANUAL).%.pdf:	$(MANUAL).%.tex
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
	@$(foreach lang,$(ORIG_LANG) $(LANGS),\
	  rm -f $(PUBLISHDIR)/$(MANUAL)/*.$(lang).html ;\
	  install -p -m 644 $(MANUAL).$(lang).html/*.html $(PUBLISHDIR)/$(MANUAL)/;)
# 	install examples.  Excuse me for ugly script (skip CVS directory)
	@test -d $(PUBLISHDIR)/$(MANUAL)/examples \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)/examples
	@install -p -m 644  --preserve-timestamps \
	 examples/[_AIOa-z]* $(PUBLISHDIR)/$(MANUAL)/examples/
ifeq ("$(HTDOCS)", "htdocs")
	install -p -m 644 index.php $(PUBLISHDIR)/$(MANUAL)/
endif

#----[ publish the files ]-----------------------------------------------------
publish-files: $(ALLFILES)
	@echo "# install for ext=$(EXTS), LANGS=$(LANGS), and ORIG_LANG=$(ORIG_LANG)"
	@test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	@$(foreach ext,$(EXTS),\
	 $(foreach lang,$(ORIG_LANG) $(LANGS),\
	  rm -f $(PUBLISHDIR)/$(MANUAL)/*.$(lang).$(ext);\
	  install -p -m 644 $(MANUAL).$(lang).$(ext)\
	                    $(PUBLISHDIR)/$(MANUAL)/;)\
	)
	@$(foreach ext,$(EXTS),\
	  if [ "$(ORIG_LANG)" != "" ] ; then\
	    ( cd $(PUBLISHDIR)/$(MANUAL); \
	      rm -f $(MANUAL).$(ext);\
	      ln -s $(MANUAL).$(ORIG_LANG).$(ext) $(MANUAL).$(ext); \
	    ) \
	  fi\
	)

#----[ publish tar.gz files ]--------------------------------------------------
publish-tar: $(MANUAL).tar.gz
	# install tar
	@test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	@rm -f $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).tar.gz
	@install -p -m 644 $(MANUAL).tar.gz $(PUBLISHDIR)/$(MANUAL)/

#====[ validating SGML ]=======================================================
validate:
	set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

#====[ Saving SGML tar ]=======================================================
.PHONY:	tar
tar: $(MANUAL).tar.gz
$(MANUAL).tar.gz: $(SGMLSRC)
	# make tar
	@tar cvzf $(MANUAL).tar.gz $(SGMLSRC) 2>_tar.error 1>&2
	
#====[ cleaning up ]===========================================================
neat:
	rm -f $(MANUAL)*.{dvi,log,tex,aux,toc,sasp*} *~
	rm -f $(MANUAL).??.sgml *.error dynamic.??.ent

clean distclean: neat
	rm -f $(MANUAL)*.{txt,ps,pdf,info*,tar.gz} date.ent
	rm -rf $(MANUAL)*.html

publishclean:
	rm -Rf $(PUBLISHDIR)/$(MANUAL)/*

.PHONY: all sf\
	publish publish-html publish-files publish-tar \
	neat clean distclean publishclean validate
