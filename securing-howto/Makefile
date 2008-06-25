#
# Based  Makefile Template from Osamu Aoki
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
MANUAL := securing-debian-howto

# Basename for language-independent SGML-template.
MANUAL0 := $(MANUAL)

# Build type: Possible values are BUILD_TYPE = web|package
BUILD_TYPE  := web

# Publish directory
# This can and will be overridden by a higher level makefile
PUBLISHDIR := ~/public_html/manuals.html

# List of languages built for "distclean" target for DDP:
LANGSALL := en de fr es it ru ja zh-cn
# List of languages built for "publish" target for DDP
#LANGS    := en de fr pt-br
LANGS    := es
# This are all the languages, not all are compiled for DDP
# due to them being out of dte
#LANGS    := en de fr es it ru ja zh-cn pt-br

# Files which affect SGML generation (excluding *.sgml)
SGMLENTS := custom.ent default.ent

# All SGML source files
SGMLSRCS := $(foreach lang, $(LANGS), $(MANUAL).$(lang).sgml) \
	    $(foreach lang, $(LANGS), $(wildcard $(lang)/*.sgml ) ) \
	    $(SGMLENTS)

# =================================================================== #
#                 Build target default part: Routine                  #
# =================================================================== #
# If some languages have problems building, filter-out in here.

# define $(locale) for the following targets
$(MANUAL).%.html.stamp $(MANUAL).%.txt $(MANUAL).%.ps $(MANUAL).%.pdf: \
  locale=$(subst pt-br,pt_BR,\
         $(subst zh-cn,zh_CN,\
	 $*))

### Full guide

# List of html stamp files to be built
HTMLS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).html.stamp)

# List of txt to be built
TXTS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).txt)

# List of ps to be built
PSS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).ps)

# List of pdf to be built
PDFS := $(foreach lang,$(LANGS),$(MANUAL).$(lang).pdf)


# =================================================================== #
#                 Build target part: Customize                        #
# =================================================================== #
# If some languages have problems building, filter-out in here.

all: html txt ps pdf
html: $(HTMLS)
text txt:  $(TXTS)
ps:   $(PSS)
pdf:  $(PDFS)

publish: publish-html publish-txt publish-ps publish-pdf

# =================================================================== #
#                 Build rule part: If not package build               #
# =================================================================== #

$(MANUAL).%.ent:
	echo "<!ENTITY language \"$*\">"                 > $@
	echo "<!ENTITY % lang-$* \"INCLUDE\">"          >> $@
	echo "<!ENTITY docdate \"`LC_ALL=C date -R`\">" >> $@
	echo "<!ENTITY docversion \"CVS\">"             >> $@


# =================================================================== #
#                 Build rule part: Routine                            #
# =================================================================== #

# SGML

# Create starting SGML for each language from the template.  Actual
# contents reside in language-segregated subdirectories.

$(MANUAL).%.sgml: $(MANUAL0).sgml
	sed -e "s/@@LANGS@@/$*/g" \
	    -e "s/@@DIRS@@/$*/g" \
	    -e "s/@@NAME@@/$(MANUAL)/g" \
	        $< > $(MANUAL).$*.sgml

# HTML
$(MANUAL).%.html.stamp: $(MANUAL).%.sgml $(MANUAL).%.ent $(SGMLSRCS)
	debiandoc2html -l $(locale) -c $<
# since $(MANUAL).%.html/index.%.html cannot be a target file
	@for file in `ls $(MANUAL).$*.html/*` ; do \
	newfile=`echo $$file|\
	    sed 's/$(shell echo $*|\
		sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ_/abcdefghijklmnopqrstuvwxyz-/'\
		)\.html/$*\.html/'`; \
	if [ $$file != $$newfile ] ; then \
		mv $$file $$newfile; \
		echo "Rename $$file --> $$newfile"; \
	fi \
	done
	touch $(MANUAL).$*.html.stamp

# TXT

$(MANUAL).%.txt: $(MANUAL).%.sgml $(MANUAL).%.ent $(SGMLSRCS)
	debiandoc2text -l $(locale) $<


# PS

$(MANUAL).%.ps: $(MANUAL).%.sgml $(MANUAL).%.ent $(SGMLSRCS)
	debiandoc2latexps -l $(locale) $<

# PDF

$(MANUAL).%.pdf: $(MANUAL).%.sgml $(MANUAL).%.ent $(SGMLSRCS)
	debiandoc2latexpdf -l $(locale) $<

# DVI

$(MANUAL).%.dvi: $(MANUAL).%.sgml $(MANUAL).%.ent $(SGMLSRCS)
	debiandoc2dvi $<


# =================================================================== #
#                 Build rule part: Web publish                        #
# =================================================================== #

publish-html: html
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	# install all html
	$(foreach lang,$(LANGS),\
	 install -p -m 644 $(MANUAL).$(lang).html/*.html \
	          $(PUBLISHDIR)/$(MANUAL)/ ;\
	)
publish-txt:  txt
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.txt
	# install all txt
	@$(foreach lang,$(LANGS),\
	 install -p -m 644 $(MANUAL).$(lang).txt \
	          $(PUBLISHDIR)/$(MANUAL)/ ;\
	)

publish-ps:  ps
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.ps
	# install all ps
	@$(foreach lang,$(LANGS),\
	 install -p -m 644 $(MANUAL).$(lang).ps \
	          $(PUBLISHDIR)/$(MANUAL)/ ;\
	)


publish-pdf:  pdf
	test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.pdf
	# install all pdf1
	@$(foreach lang,$(LANGS),\
	 install -p -m 644 $(MANUAL).$(lang).pdf \
	          $(PUBLISHDIR)/$(MANUAL)/ ;\
	)


#====[ validating SGML ]=======================================================
validate:
	set -x; for i in $(LANGS); do $(MAKE) validate1-$$i ; done

validate1-%: $(SGMLSRCS) $(MANUAL)-%.ent 
	nsgmls -gues -wall $(MANUAL)-$*.sgml


#====[ cleaning up ]===========================================================
distclean: clean
	rm -Rf $(PUBLISHDIR)/$(MANUAL)
	rm -f *.error $(MANUAL).*.sgml

clean:
	rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,sasp*,out,tov}
	rm -f *~ prior.aux pprior.aux body.tmp head.tmp tar.gz.log
	rm -f *.error $(MANUAL).*.ent $(MANUAL).*.sgml date.ent $(MANUAL).*.tpt
	rm -rf $(MANUAL)*.html *stamp

.PHONY: all html text txt ps pdf \
	publish publish-html publish-tst publish-ps publish-pdf \
	clean distclean validate

