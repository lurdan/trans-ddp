#
# Makefile for the Securing Debian HOWTO (copied from Makefile.intln)
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for the package build.

##### CONF PART 
# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

# Darn, I should have named dir and file the same way
#MANUAL = $(notdir $(shell pwd))
MANUAL = securing-debian-howto

LNPUBDIRMAN=$(PUBLISHDIR)/$(MANUAL)/

# The cannonical language, in which the original document is
ORIG_LANG=en
# list of langs (above the canonical one)
# LANGS=$(shell ls $(MANUAL).*.sgml|sed 's/.*$(MANUAL)\.\([^.]*\)\.sgml/\1/')
#
# Since portuguese is not yet in debiandoc format we cannot publish it until it is
#
LANGS = es ja ru it de 

EXTS=txt info
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

#----[ generating HTML ]-------------------------------------------------------
# for orig_lang
$(MANUAL).html: $(MANUAL).sgml
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
$(MANUAL).$(ORIG_LANG).txt: $(MANUAL).sgml
	debiandoc2text -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $* $<

#----[ generating tov ]--------------------------------------------------------
# for orig_lang
$(MANUAL).$(ORIG_LANG).tov: $(MANUAL).sgml
	debiandoc2textov -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.tov: $(MANUAL).%.sgml
	debiandoc2textov -l $* $<

#----[ generating info ]-------------------------------------------------------
# for orig_lang
$(MANUAL).$(ORIG_LANG).info: $(MANUAL).sgml
	debiandoc2info -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.info: $(MANUAL).%.sgml
	debiandoc2info -l $* $<

#----[ generating PostScript ]-------------------------------------------------
# for orig_lang
$(MANUAL).$(ORIG_LANG).ps: $(MANUAL).sgml
	debiandoc2latexps -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $* $<

#----[ generating PDF ]--------------------------------------------------------
# for orig_lang
$(MANUAL).$(ORIG_LANG).pdf: $(MANUAL).sgml
	debiandoc2latexpdf -l $(ORIG_LANG) -c $<

# for translated languages
$(MANUAL).%.pdf: $(MANUAL).%.sgml
	debiandoc2latexpdf -l $* $<

#====[ publishing to the DDP web pages ]=======================================
publish: publish-html publish-files

#----[ publish html ]----------------------------------------------------------
publish-html: $(HTMLDIRS)
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	 # install any translated html
	$(foreach lang,$(LANGS),\
	  install -p -m 644 $(MANUAL).$(lang).html/*.html $(PUBLISHDIR)/$(MANUAL)/;)
	 # install original html
	 install -p -m 644 $(MANUAL).html/*.html \
	                   $(PUBLISHDIR)/$(MANUAL)/
	 # make the symlinks for html files
	 @$(foreach file,$(wildcard  $(MANUAL).html/*.html),\
	  name=`echo $(file) | sed 's/$(MANUAL).html\///'`; \
	  link=`echo $$name|sed 's/.$(ORIG_LANG).html$$/.html/'`;\
	  echo "$$link -> $$name";\
	  ln -sf $$name\
	        $(PUBLISHDIR)/$(MANUAL)/$$link;\
	 )

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
	 ln -sf $(MANUAL).$(ORIG_LANG).$(ext)\
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
	 # make the symlinks for ps
	 ln -sf $(MANUAL).$(ORIG_LANG).ps\
               $(PUBLISHDIR)/$(MANUAL)/$(MANUAL).ps


#====[ validating SGML ]=======================================================
validate:
	set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

#====[ cleaning up ]===========================================================
clean distclean:
	rm -f securing-debian-howto*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,tpt,sasp*} *~
	rm -rf securing-debian-howto*.html

.PHONY: all html txt ps\
	publish publish-html publish-txt publish-ps\
	clean distclean validate
