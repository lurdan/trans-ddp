#
# Makefile for the Debian New Maintainers' Guide
#
# Should work both for a manual in the Debian Documentation Project
# preset values here may be overriden by a higher level makefile

# Build type: Possible values are BUILD_TYPE = web|package|...
BUILD_TYPE	:= web

# Basename for SGML sources
MANUAL		:= maint-guide

# Language which is excluded from producing PS, PDF (Customizable)
LANG_CJK	:= ko zh-cn zh-tw
#LANG_CJK	:= 

SOURCES_ALL	:= $(filter-out $(MANUAL).pt_BR.sgml $(MANUAL).zh_CN.sgml $(MANUAL)zh_TW.sgml, $(wildcard *.??*.sgml))
# Language group
LANG_ALL	:= $(patsubst $(MANUAL).%.sgml, %, $(SOURCES_ALL))
LANG_NOE	:= $(filter-out en,$(LANG_ALL))
LANG_NOCJK	:= $(filter-out $(LANG_CJK),$(LANG_ALL))
LANG_NOCJKE	:= $(filter-out $(LANG_CJK) en,$(LANG_ALL))

# For package building (all)
INSTALL_DIR := $(CURDIR)/debian
all:
	echo "<!entity docisodate \"$(shell LC_ALL=C date +'%Y%m%d')\">" > version.ent
	echo "<!entity docversion \"$(shell LC_ALL=C dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//')\">" >> version.ent
	$(MAKE) html txt ps pdf
	for lang in $(LANG_NOE); do sed -e "s/@@/$$lang/g" < $(CURDIR)/debian/all.install-in >$(CURDIR)/debian/$(MANUAL)-$$lang.install; done

# For web page building (publish)
# this can and will be overriden by a higher level makefile
PUBLISHDIR	:= /org/www.debian.org/www/doc/manuals
publish: 
	-rm -rf $(MANUAL).pt_BR.*
	-rm -rf $(MANUAL).zh_CN.*
	-rm -rf $(MANUAL).zh_TW.*
	echo "<!entity docisodate \"$(shell LC_ALL=C date +'%Y%m%d')\">" > version.ent
	echo "<!entity docversion \"$(shell LC_ALL=C dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//')-svn\">" >> version.ent
	$(MAKE) html txt ps pdf
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	# remove old files
	install -p -m 644 $(MANUAL)*.html/*.html $(PUBLISHDIR)/$(MANUAL)/
	install -p -m 644 $(MANUAL)*.txt $(MANUAL)*.ps $(MANUAL)*.pdf $(PUBLISHDIR)/$(MANUAL)

# generating HTML
# ugly because the normal stuff works only as PHONYs. :(
#$(MANUAL).%.html/index.%.html: $(MANUAL).%.sgml
#	debiandoc2html -c -l $* $<
html:
	for lang in $(LANG_ALL); do \
	  if /usr/bin/test \( ! -e $(MANUAL).$$lang.html/index.$$lang.html \) -o \( $(MANUAL).$$lang.sgml -nt $(MANUAL).$$lang.html/index.$$lang.html \); then \
            echo debiandoc2html -c -l $$lang $(MANUAL).$$lang.sgml; \
            debiandoc2html -c -l $$lang $(MANUAL).$$lang.sgml; \
          fi; \
        done

# generating plain text
txt text: $(patsubst %.sgml,%.txt,$(SOURCES_ALL))

$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $* $<

# generating PostScript
ps: $(patsubst %,$(MANUAL).%.ps,$(LANG_NOCJK))
	for lang in $(LANG_CJK); do \
	echo "Tex problem prevents PS build" >$(MANUAL).$$lang.ps ;\
	done

$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $* $<

# generating Portable Document Format
pdf: $(patsubst %,$(MANUAL).%.pdf,$(LANG_NOCJK))
	for lang in $(LANG_CJK); do \
	echo "Tex problem prevents PDF build" >$(MANUAL).$$lang.pdf ;\
	done

$(MANUAL).%.pdf: $(MANUAL).%.sgml
	debiandoc2latexpdf -l $* $<

# validating SGML
validate:
	@set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

# cleaning up
clean:
	-rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,out,sasp*,tpt,tex-in} *~
	-rm -rf $(MANUAL)*.html 
	-rm -rf *.tmp
	-rm version.ent
ifneq ("$(BUILD_TYPE)", "web")
	-rm -rf $(PUBLISHDIR)/$(MANUAL)
else
	for lang in $(LANG_NOE); do rm -f $(CURDIR)/debian/$(MANUAL)-$$lang.install; done
endif

distclean: clean

.PHONY: all publish clean distclean validate
.SUFFIXES:

