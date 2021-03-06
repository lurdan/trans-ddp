#
# Makefile for the Debian reference
#
# Read local texmf.cnf file

#export TEXMFCNF=texmf/


#====[ customization ]=========================================================
##### CONF PART 
# The cannonical language, in which the original document is
ORIG_LANG := en
# All languages
ALL_LANGS := en
# target languages
LANGS := en
# Target file type (html ps pdf txt tov info)
EXTS := html pdf txt
# publish directory (default for all DDP)
# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals
# build flag for SGML parse.
MANUAL := $(notdir $(shell pwd))
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for package build.
# Key source files
SGMLMSTR := $(MANUAL).sgml
SGMLSRCS := custom.ent default.ent  dynamic.%.ent date.ent \
	    $(foreach lang, $(ALL_LANGS), $(wildcard $(lang)/*.sgml ) )
TARSRCS = img/* bin/* ??/*.sgml\
	  Makefile README
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
# CHECKME: Still used?
MAX_TEX_RECURSION	:= 4

# generate anything some dirs want version.ent to be built, some not

DEBIAN=$(wildcard debian)
ifeq ($(DEBIAN),"debian")
all: version.ent $(TARGETS)
else
all: $(TARGETS)
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
	@echo "<!entity docdate \"$(shell LC_ALL=C date +'%-d %B %Y')\">" >> $@
	@if [ -f ../debian/changelog ]; then \
	  echo "<!entity docversion \"` LC_ALL=C cd .. && dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//'`\">" >> $@; \
	else \
	  echo "<!entity docversion \"CVS\">" >> $@; \
	fi
# Note: This does work, but it's a hack, it
# needs to be rewritten properly (jfs)
#
# I know.  But for now, I need to avoid circular dependence. (OA)
#
# Create starting SGML for each language from template
# Actual contents are in language segregated subdirectory
# generic rules for all the languages to each language
$(MANUAL).%.sgml: $(SGMLMSTR)
	sed -e "s/@@@@/$*/g" $< > $(MANUAL).$*.sgml

#----[ generating HTML ]-------------------------------------------------------
# FIXME: there is a trick because debiandoc2html does a sed 'y/.../...' 
#        which should be reverted to have the content negotiation working.
#   This trick is bad. debiandoc2html should be corrected.
$(MANUAL).%.html: $(MANUAL).%.sgml $(SGMLSRCS)
	debiandoc2html -t$(MANUAL) -l $* -c $<
	@for file in `ls $(MANUAL).$*.html/*` ; do\
	 newfile=`echo $$file|\
	          sed 's/$(shell echo $*|\
	      sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ_/abcdefghijklmnopqrstuvwxyz-/'\
	                  )\.html/$*\.html/'`;\
	 if [ $$file != $$newfile ] ; then\
	   mv $$file $$newfile;\
	   echo "Rename $$file --> $$newfile";\
	 fi; \
	done   

#----[ generating plain text ]-------------------------------------------------
$(MANUAL).%.txt: $(MANUAL).%.sgml dynamic.%.ent date.ent $(SGMLSRCS)
	debiandoc2text -l $* $<

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
$(MANUAL).%.ps: $(MANUAL).%.sgml date.ent dynamic.%.ent $(SGMLSRCS)
	debiandoc2latexps -l $* $<

#----[ generating PDF ]--------------------------------------------------------
# for translated languages
$(MANUAL).%.pdf: $(MANUAL).%.sgml date.ent dynamic.%.ent $(SGMLSRCS)
	debiandoc2latexpdf -l $* $<

#====[ publishing to the DDP web pages ]=======================================
publish: publish-html publish-files
publish-all: publish-html publish-files publish-tar

#----[ publish html ]----------------------------------------------------------
publish-html: $(HTMLDIRS)
	# install for all language (html)
	@test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	@$(foreach lang,$(LANGS),\
	  rm -f $(PUBLISHDIR)/$(MANUAL)/*.$(lang).html ;\
	  install -p -m 644 $(MANUAL).$(lang).html/*.html $(PUBLISHDIR)/$(MANUAL)/;)
# 	install examples.  Excuse me for ugly script (skip CVS directory)
	@test -d $(PUBLISHDIR)/$(MANUAL)/img \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)/img
	@install -p -m 644  --preserve-timestamps \
	 img/[_A-BD-Za-z0-9]* $(PUBLISHDIR)/$(MANUAL)/img/

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
	rm -f $(MANUAL).??.sgml *.error dynamic.??.ent head.tmp body.tmp

clean: neat
	rm -f $(MANUAL)*.{txt,tov,texinfo,out,ps,pdf,info*,tar.gz} date.ent
	rm -rf $(MANUAL)*.html

distclean: clean
	rm -rf $(PUBLISHDIR)/$(MANUAL)/

scp: publish-all
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
