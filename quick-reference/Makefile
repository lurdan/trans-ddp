#
# Makefile for the Debian New Maintainers' Guide
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for maint-guide package build.

##### CONF PART 
# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html
MANUAL = $(notdir $(shell pwd))

# The cannonical language, in which the original document is
ORIG_LANG=en
# list of langs (above the canonical one)
LANGS=fr it

EXTS=ps pdf txt tov info

# source file name (No language specifier part)
SFILE           := qref
# target file name (for html: $(TFILE).html/)
TFILE           := qref
# HTML start page
INDEX           := index
# default language for build
TLANG           := en
# default language for build (LATEX related specification)
LLANG           := en
# build flag for SGML parse.
BOOK            := qref
# url of this build.
URLHERE         := ddp-page
##### END OF CONF PART CHANGE THE END AT YOU OWN RISK

# what will be built
HTMLDIRS=$(MANUAL).html $(foreach lang,$(LANGS),$(MANUAL).$(lang).html)
ALLFILES=$(foreach ext,$(EXTS),\
	    $(MANUAL).$(ORIG_LANG).$(ext)\
	    $(foreach lang,$(LANGS),$(MANUAL).$(lang).$(ext))\
	  )



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

DATE            := `date --utc +"%Y.%m.%d-%H:%M"`

# --- build sgml
#
date.ent:
	: > $@                       # clear the file
	@echo "<!entity date \"$(DATE)\">" >> $@

# generate entities which are dynamically defined by the settings of this
# build run, generally set in the top-level config file (always make)
dynamic.ent::
	: > $@                       # clear the file
	@echo "<!entity language \"$(TLANG)\">" >> $@
	@echo "<!entity % lang-$(TLANG) \"INCLUDE\">" >> $@
	@echo "<!entity booklet \"$(BOOK)\">" >> $@
	@echo "<!entity % $(BOOK) \"INCLUDE\">" >> $@
	@echo "<!entity % $(URLHERE) \"INCLUDE\">" >> $@

# Note: This does work, but it's a hack, it
# needs to be rewritten properly (jfs)
#
# Create starting SGML for each language from template
# Actual contents are in language segrigated subdirectory
# generic rules for all the languages to each language
$(MANUAL).%.sgml: $(MANUAL).sgml 
	sed -e "s/@@@@/$*/g" $< > $(MANUAL).$*.sgml

#----[ generating HTML ]-------------------------------------------------------
# for orig_lang
$(MANUAL).html: $(MANUAL).$(ORIG_LANG).sgml date.ent dynamic.ent
	debiandoc2html -l $(ORIG_LANG) -c $<

# for translated languages
# FIXME: there is a trick because debiandoc2html does a sed 'y/.../...' 
#        which should be reverted to have the content negociation working.
#   This trick is bad. debiandoc2html should be corrected.
$(MANUAL).%.html: $(MANUAL).%.sgml
	debiandoc2html -l $* -c $<
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
# for orig_lang
$(MANUAL).$(ORIG_LANG).txt: $(MANUAL).$(ORIG_LANG).sgml
	debiandoc2text -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $* $<

#----[ generating tov ]--------------------------------------------------------
# for orig_lang
$(MANUAL).$(ORIG_LANG).tov: $(MANUAL).$(ORIG_LANG).sgml
	debiandoc2textov -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.tov: $(MANUAL).%.sgml
	debiandoc2textov -l $* $<

#----[ generating info ]-------------------------------------------------------
# for orig_lang
$(MANUAL).$(ORIG_LANG).info: $(MANUAL).$(ORIG_LANG).sgml
	debiandoc2info -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.info: $(MANUAL).%.sgml
	debiandoc2info -l $* $<

#----[ generating PostScript ]-------------------------------------------------
# for orig_lang
$(MANUAL).$(ORIG_LANG).ps: $(MANUAL).$(ORIG_LANG).sgml
	debiandoc2latexps -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $* $<

#----[ generating PDF ]--------------------------------------------------------
# for orig_lang
$(MANUAL).$(ORIG_LANG).pdf: $(MANUAL).$(ORIG_LANG).sgml
	debiandoc2latexpdf -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.pdf: $(MANUAL).%.sgml
	debiandoc2latexpdf -l $* $<

#====[ publishing to the DDP web pages ]=======================================
#publish: publish-html publish-files 
# publish-file is disabled since the files do not compile cleanly to
# PS/PDF.
publish: publish-html

#----[ publish html ]----------------------------------------------------------
publish-html: $(HTMLDIRS)
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	 # install any translated html
	$(foreach lang,$(ORIG_LANG) $(LANGS),\
	  install -p -m 644 $(MANUAL).$(lang).html/*.html $(PUBLISHDIR)/$(MANUAL)/;)
	 # install original html
	 #install -p -m 644 $(MANUAL).html/*.html \
	 #                  $(PUBLISHDIR)/$(MANUAL)/
	 # make the simlinks for html files
	 #@$(foreach file,$(wildcard  $(MANUAL).html/*.html),\
	 # name=`echo $(file) | sed 's/$(MANUAL).html\///'`; \
	 # link=`echo $$name|sed 's/.$(ORIG_LANG).html$$/.html/'`;\
	 # rm -f $$link; \
	 # echo "$$link -> $$name";\
	 # ln -s $(PUBLISHDIR)/$(MANUAL)/$$name\
	 #       $(PUBLISHDIR)/$(MANUAL)/$$link;\
	 #)

#----[ publish the files ]-----------------------------------------------------
publish-files: $(ALLFILES)
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	$(foreach ext,$(EXTS),\
	 rm -f $(PUBLISHDIR)/$(MANUAL)/*.$(ext);\
	 \
	 $(foreach lang,$(LANGS),\
	  install -p -m 644 $(MANUAL).$(lang).$(ext)\
	                    $(PUBLISHDIR)/$(MANUAL)/;)\
	 \
	 install -p -m 644 $(MANUAL).$(ORIG_LANG).$(ext)\
	                   $(PUBLISHDIR)/$(MANUAL)/;\
	 \
	 rm -f $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).$(ext);\
	 ln -s $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).$(ORIG_LANG).$(ext)\
               $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).$(ext);\
	)
# I need to think about where to put these examples.  Top part is not used.
# 2nd part needs to be adopted to above script.  Now for record only.
#	$(install_file) --preserve-timestamps \
#	  $(MANUAL).html/*.html $(PUBLISHDIR)/$(MANUAL)/
#	$(install_dir) $(PUBLISHDIR)/$(TFILE)/examples
#	# excuse me for ugly script (skip CVS)
#	$(install_file) --preserve-timestamps \
#	  $(MANUAL).html/examples/[_AIOa-z]* $(PUBLISHDIR)/$(MANUAL)/examples/


#----[ publish the ps ]--------------------------------------------------------
publish-ps: ps
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.ps
	 # install any translated ps
	$(foreach lang,$(LANGS),\
	  install -p -m 644 $(MANUAL).$(lang).ps \
	                    $(PUBLISHDIR)/$(MANUAL)/ ;)
	 # install original ps
	 install -p -m 644 $(MANUAL).$(ORIG_LANG).ps\
	                   $(PUBLISHDIR)/$(MANUAL)/
	 # make the simlinks for ps
	 rm -f $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).ps;
	 ln -s $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).$(ORIG_LANG).ps\
               $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).ps


#====[ validating SGML ]=======================================================
validate:
	set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

#====[ cleaning up ]===========================================================
clean distclean:
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*} *~
	rm -rf $(MANUAL)*.html
	rm -f $(MANUAL).??.sgml 

# Needed for Quick-Reference
# This is done in order to maintain coherence with Osamu's setup
# (in SourceForge's CVS) and keep it DDP-standard (long names)
$(MANUAL).sgml : qref.sgml
	cp $< $@ 

.PHONY: all html txt ps\
	publish publish-html publish-txt publish-ps\
	clean distclean validate 
