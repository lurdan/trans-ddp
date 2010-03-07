#
# Makefile for the Debian New Maintainers' Guide
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for $(MANUAL) package build.

# Build type: Possible values are BUILD_TYPE = web|package|...
BUILD_TYPE  := web

# Basename for SGML
MANUAL := $(shell echo $(notdir $(CURDIR)) | perl -pe 's/-\d[\d.]+.*$$//')

# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

ifeq ("$(BUILD_TYPE)", "web")
INSTALL_DIR := $(PUBLISHDIR)/$(MANUAL)
else
INSTALL_DIR := $(CURDIR)/debian/tmp
endif

all: html txt ps pdf

sources := $(wildcard *.??*.sgml)
#sources_noncjk := $(sources)
sources_noncjk := $(filter-out maint-guide.ko.sgml maint-guide.zh-cn.sgml maint-guide.zh-tw.sgml,$(sources))

# generating HTML
# ugly because the normal stuff works only as PHONYs. :(
#$(MANUAL).%.html/index.%.html: $(MANUAL).%.sgml
#	debiandoc2html -c -l $* $<
html:
	rm -rf *html
	@for i in *.??*.sgml; do \
          j=$${i#$(MANUAL).}; lang=$${j%.sgml}; \
	  if /usr/bin/test \( ! -e $(MANUAL).$$lang.html/index.$$lang.html \) -o \( $$i -nt $(MANUAL).$$lang.html/index.$$lang.html \); then \
            echo debiandoc2html -c -l $$lang $$i; \
            debiandoc2html -c -l $$lang $$i; \
          fi; \
        done

# generating plain text
txt text: $(patsubst %.sgml,%.txt,$(sources))

$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $* $<

# generating PostScript
ps: $(patsubst %.sgml,%.ps,$(sources_noncjk))
	echo "Tex problem prevents PS build" >$(MANUAL).ko.ps
	echo "Tex problem prevents PS build" >$(MANUAL).zh-cn.ps
	echo "Tex problem prevents PS build" >$(MANUAL).zh-tw.ps

$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $* $<

# generating Portable Document Format
pdf: $(patsubst %.sgml,%.pdf,$(sources_noncjk))
	echo "Tex problem prevents PDF build" >$(MANUAL).ko.pdf
	echo "Tex problem prevents PDF build" >$(MANUAL).zh-cn.pdf
	echo "Tex problem prevents PDF build" >$(MANUAL).zh-tw.pdf

$(MANUAL).%.pdf: $(MANUAL).%.sgml
	debiandoc2latexpdf -l $* $<

# publishing to the DDP web pages or debian/tmp
publish: all
	test -d $(INSTALL_DIR) || install -d -m 755 $(INSTALL_DIR)
	rm -f $(INSTALL_DIR)/*.html
	install -p -m 644 $(MANUAL)*.html/*.html $(INSTALL_DIR)/
	install -p -m 644 $(MANUAL)*.txt $(MANUAL)*.ps $(MANUAL)*.pdf $(INSTALL_DIR)

# validating SGML
validate:
	@set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

# cleaning up
clean distclean:
	-rm -f $(MANUAL)*.{txt,ps,dvi,pdf,info*,log,tex,aux,toc,out,sasp*,tpt,tex-in} *~
	-rm -rf $(MANUAL)*.html 
	-rm -rf *.tmp
ifneq ("$(BUILD_TYPE)", "web")
	-rm -rf $(INSTALL_DIR)
endif

.PHONY: all publish clean distclean validate
.SUFFIXES:
