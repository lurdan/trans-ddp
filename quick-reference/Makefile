#
# Makefile for the Debian New Maintainers' Guide
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for maint-guide package build.

##### CONF PART 
# this can and will be overriden by a higher level makefile

HTDOCS := $(notdir $(patsubst %/,%, $(dir $(shell pwd))))
ifeq ("$(HTDOCS)", "manuals.sgml")
# DDP site or checked out source from DDP
PUBLISHDIR := ../../../public_html/manuals.html
MANUAL := $(notdir $(shell pwd))
else
ifeq ("$(HTDOCS)", "htdocs")
# qref.sourceforge.net
PUBLISHDIR := ./
MANUAL := qref
else
# default: checked out source from qref.sourceforge.net
PUBLISHDIR := $$HOME/public_html
MANUAL := qref
endif
endif

# The cannonical language, in which the original document is
ORIG_LANG=en
# list of langs (above the canonical one)
LANGS=fr it
#LANGS=

# Because Latex is hard to work with, I just to do text for now
# When it is not a problem to enable others, we should enable the rest.
#EXTS=ps pdf txt tov info
EXTS=txt
# default language for build
TLANG           := en
# default language for build (LATEX related specification)
LLANG           := en
# build flag for SGML parse.
BOOK            := qref
##### END OF CONF PART CHANGE THE END AT YOU OWN RISK

# what will be built
HTMLDIRS=$(MANUAL).html $(foreach lang,$(LANGS),$(MANUAL).$(lang).html)
ALLFILES=$(foreach ext,$(EXTS),\
	    $(MANUAL).$(ORIG_LANG).$(ext)\
	    $(foreach lang,$(LANGS),$(MANUAL).$(lang).$(ext))\
	  )



#====[ build rules ]===========================================================
# generate anything some dirs want version.ent to be built, some not

DEBIAN=$(wildcard debian)
ifeq ($(DEBIAN),"debian")
all: version.ent $(HTMLDIRS) $(ALLFILES) publish
else
all: $(HTMLDIRS) $(ALLFILES) publish
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
#dynamic.ent: dynamic.%.ent
#	cp -f $< $@

dynamic.%.ent:
	@#echo H===$(HTDOCS)===
	@#echo M===$(MANUAL)===
	@#echo M===$(PUBLISHDIR)===
	: > $@                       # clear the file
	@echo "<!entity language \"$*\">" >> $@
	@echo "<!entity % lang-$* \"INCLUDE\">" >> $@
	@echo "<!entity booklet \"$(BOOK)\">" >> $@
	@echo "<!entity % $(BOOK) \"INCLUDE\">" >> $@

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
$(MANUAL).html: $(MANUAL).$(ORIG_LANG).sgml date.ent dynamic.en.ent
	debiandoc2html -l $(ORIG_LANG) -c $< 2>_html.error

# for translated languages
# FIXME: there is a trick because debiandoc2html does a sed 'y/.../...' 
#        which should be reverted to have the content negociation working.
#   This trick is bad. debiandoc2html should be corrected.
$(MANUAL).%.html: $(MANUAL).%.sgml date.ent dynamic.%.ent
	debiandoc2html -l $* -c $< 2>_html.$*.error
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
$(MANUAL).$(ORIG_LANG).txt: $(MANUAL).$(ORIG_LANG).sgml date.ent dynamic.%.ent
	debiandoc2text -l $(ORIG_LANG) $< 2>_txt.error

# for translated languages
$(MANUAL).%.txt: $(MANUAL).%.sgml date.ent dynamic.%.ent
	debiandoc2text -l $* $< 2>_txt.$*.error

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
publish: publish-html publish-files

#----[ publish html ]----------------------------------------------------------
publish-html: $(HTMLDIRS)
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	# install all html
	$(foreach lang,$(ORIG_LANG) $(LANGS),\
	  install -p -m 644 $(MANUAL).$(lang).html/*.html $(PUBLISHDIR)/$(MANUAL)/;)
#	# excuse me for ugly script (skip CVS directory)
	test -d $(PUBLISHDIR)/$(MANUAL)/examples \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)/examples
	install -p -m 644  --preserve-timestamps \
	 examples/[_AIOa-z]* $(PUBLISHDIR)/$(MANUAL)/examples/

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
	rm -f *.error
	rm -f dynamic.ent date.ent dynamic.??.ent


.PHONY: all html txt ps\
	publish publish-html publish-files publish-txt publish-ps\
	clean distclean validate 
