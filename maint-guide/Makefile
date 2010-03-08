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

SOURCES_ALL	:= $(wildcard *.??*.sgml)
# Language group
LANG_ALL	:= $(patsubst $(MANUAL).%.sgml, %, $(SOURCES_ALL))
LANG_NOE	:= $(filter-out en,$(LANG_ALL))
LANG_NOCJK	:= $(filter-out $(LANG_CJK),$(LANG_ALL))
LANG_NOCJKE	:= $(filter-out $(LANG_CJK) en,$(LANG_ALL))

# For package building (all)
INSTALL_DIR := $(CURDIR)/debian
all: html txt ps pdf
	#$(MAKE) dh_in
	test -d $(INSTALL_DIR)/usr/share/doc/$(MANUAL) || install -d -m 755 $(INSTALL_DIR)/usr/share/doc/$(MANUAL)
	install -p -m 644 $(MANUAL).en.html/*.html $(INSTALL_DIR)/usr/share/doc/$(MANUAL)
	install -p -m 644 $(MANUAL).en.txt $(MANUAL).en.ps $(MANUAL).en.pdf $(INSTALL_DIR)/usr/share/doc/$(MANUAL)
	for lang in $(LANG_NOE); do \
	test -d $(INSTALL_DIR)/usr/share/doc/$(MANUAL)-$$lang || install -d -m 755 $(INSTALL_DIR)/usr/share/doc/$(MANUAL)-$$lang ;\
	install -p -m 644 $(MANUAL).$$lang.html/*.html $(INSTALL_DIR)/usr/share/doc/$(MANUAL)-$$lang ;\
	install -p -m 644 $(MANUAL).$$lang.txt $(MANUAL).$$lang.ps $(MANUAL).$$lang.pdf $(INSTALL_DIR)/usr/share/doc/$(MANUAL)-$$lang ;\
	done
	ls -lR $(INSTALL_DIR)

# For web page building (publish)
# this can and will be overriden by a higher level makefile
PUBLISHDIR	:= /org/www.debian.org/www/doc/manuals
publish: html txt ps pdf
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
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

ttt:

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
ifneq ("$(BUILD_TYPE)", "web")
	-rm -rf $(PUBLISHDIR)/$(MANUAL)
endif

distclean: clean

#######################################################################
## Debhelper script auto generation
#
#dh_in:
#	# Generate files for debhelper in debian/
#	cd $(CURDIR)/debian/ ; \
#	for xx in $(LANG_NOE) ; do \
#	  sed  -e "s/@@/$$xx/" < all.install-in  >$(MANUAL)-$${xx}.install ; \
#	done
#
#dh_clean_in:
#	# Clean files for debhelper in debian/
#	cd $(CURDIR)/debian/ ; \
#	for xx in $(LANG_NOE) ; do \
#	  rm -f $(MANUAL)-$${xx}.install ; \
#	done
#
########################################################################
.PHONY: all publish clean distclean validate dh_in dh_clean_in
.SUFFIXES:

