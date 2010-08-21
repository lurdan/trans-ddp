#
# Makefile for the Debian New Maintainers' Guide
#
# Should work both for a manual in the Debian Documentation Project
# preset values here may be overriden by a higher level makefile

# Language names are in lowercase web suffix style without encoding.
# sgml uses traditional encoding such as latin1
# $$lang.*.add files use traditional encoding such as latin1
#                       You can use any number for middle *.
# po files can be in UTF-8 encoding. (Depending on definition in it).

# Build type: Possible values are BUILD_TYPE = web|package|...
BUILD_TYPE	:= web

# Basename for SGML sources
MANUAL		:= maint-guide

# Language which is excluded from producing PS, PDF (Customizable)
LANG_CJK	:= ko
#LANG_CJK	:= 

# Language which generates SGML files from PO file (Customizable)
ifneq ("$(BUILD_TYPE)", "web")
# web build all po files
LANG_PO		:= fr it zh-cn
else
# package build good po files
LANG_PO		:= fr it
endif
SOURCES_ALL	:= $(wildcard *.??*.sgml)
PO_ALL		:= $(wildcard *.??*.po)
# Language group
LANG_ALL	:= $(patsubst $(MANUAL).%.sgml, %, $(SOURCES_ALL)) $(patsubst $(MANUAL).%.po, %, $(PO_ALL))
LANG_NOE	:= $(filter-out en,$(LANG_ALL))
LANG_NOCJK	:= $(filter-out $(LANG_CJK),$(LANG_ALL))
LANG_NOCJKE	:= $(filter-out $(LANG_CJK) en,$(LANG_ALL))

# For package building (all)
INSTALL_DIR := $(CURDIR)/debian
all:
	$(MAKE) version.ent
	$(MAKE) po
	$(MAKE) html txt ps pdf
	for lang in $(LANG_NOE); do sed -e "s/@@/$$lang/g" < $(CURDIR)/debian/all.install-in >$(CURDIR)/debian/$(MANUAL)-$$lang.install; done

version.ent:
	echo '<!entity' "docisodate \"$(shell LC_ALL=C date -u +'%F %T %Z')\">" > version.ent
	echo '<!entity' "docversion \"$(shell LC_ALL=C dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//')\">" >> version.ent

# For web page building (publish)
# this can and will be overriden by a higher level makefile
PUBLISHDIR	:= /org/www.debian.org/www/doc/manuals
publish: 
	echo '<!entity docisodate "$(shell LC_ALL=C date -u +'%F %T %Z')">' > version.ent
	echo '<!entity docversion "$(shell LC_ALL=C dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//')-svn">' >> version.ent
	$(MAKE) po
	$(MAKE) html txt ps pdf
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	# remove old files
	install -p -m 644 $(MANUAL)*.html/*.html $(PUBLISHDIR)/$(MANUAL)/
	install -p -m 644 $(MANUAL)*.txt $(MANUAL)*.ps $(MANUAL)*.pdf $(PUBLISHDIR)/$(MANUAL)

# generating SGML files from PO files
# -M : master file $(MANUAL).en.sgml is always in UTF-8
PO_UPDATE	:= po4a-updatepo --previous -M UTF-8 -f sgml
#PO_UPDATE	:= po4a-updatepo --previous --msgmerge-opt --no-wrap -M latin1 -f sgml
PO_TRANSLATE	:= po4a-translate  -M UTF-8 -f sgml --keep 0
PO_GETTEXT	:= po4a-gettextize -M UTF-8 -f sgml

# -L : Charset of the file containing the localized document. UTF-8
# xargs -n1 is to split into lines
# sed script is to add "-a" to automatically add addendum files.

po:
	if ! [ -f version.ent ]; then $(MAKE) version.ent; fi
	for lang in $(LANG_PO); do \
	$(PO_UPDATE) -m $(MANUAL).en.sgml -p $(MANUAL).$$lang.po ;\
	$(PO_TRANSLATE) -v -L $$lang.UTF-8 -m $(MANUAL).en.sgml -l $(MANUAL).$$lang.sgml -p $(MANUAL).$$lang.po \
          $$(echo $$lang.*.add|xargs -n1|sed -ne 's/^\([^*]*\.add\)$$/-a \1/p') ;\
        done
	$(PO_GETTEXT) -m $(MANUAL).en.sgml -p $(MANUAL).pot

# generating HTML
# ugly because the normal stuff works only as PHONYs. :(
#$(MANUAL).%.html/index.%.html: $(MANUAL).%.sgml
#	debiandoc2html -c -l $* $<
html:
	if ! [ -f version.ent ]; then $(MAKE) version.ent ; $(MAKE) po; fi
	for lang in $(LANG_ALL); do \
	  if /usr/bin/test \( ! -e $(MANUAL).$$lang.html/index.$$lang.html \) -o \( $(MANUAL).$$lang.sgml -nt $(MANUAL).$$lang.html/index.$$lang.html \); then \
            echo debiandoc2html -C -l $$lang.utf-8 $(MANUAL).$$lang.sgml; \
            debiandoc2html -C -l $$lang.utf-8 $(MANUAL).$$lang.sgml; \
          fi; \
        done

# generating plain text
txt text: $(patsubst %.sgml,%.txt,$(SOURCES_ALL))

$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $*.utf-8 $<

# generating PostScript
ps: $(patsubst %,$(MANUAL).%.ps,$(LANG_NOCJK))
	for lang in $(LANG_CJK); do \
	echo "Tex problem prevents PS build" >$(MANUAL).$$lang.ps ;\
	done

$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $*.utf-8 $<

# generating Portable Document Format
pdf: $(patsubst %,$(MANUAL).%.pdf,$(LANG_NOCJK))
	for lang in $(LANG_CJK); do \
	echo "Tex problem prevents PDF build" >$(MANUAL).$$lang.pdf ;\
	done

$(MANUAL).%.pdf: $(MANUAL).%.sgml
	debiandoc2latexpdf -l $*.utf-8 $<

# validating SGML
validate:
	@set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

# cleaning up
clean:
	for ext in txt ps dvi pdf log tex aux toc out tpt tex-in ; do \
	rm -f $(MANUAL)*.$$ext ;\
	done
	rm -f $(MANUAL)*.info*
	rm -f $(MANUAL)*.sasp*
	rm -f $(MANUAL)*.info*
	rm -f $(MANUAL)*.*~
	rm -rf $(MANUAL)*.html 
	rm -rf *.tmp
	rm -f version.ent
	for lang in $(LANG_PO); do \
	rm -f $(MANUAL).$$lang.sgml ;\
        done
ifneq ("$(BUILD_TYPE)", "web")
	rm -rf $(PUBLISHDIR)/$(MANUAL)
else
	for lang in $(LANG_NOE); do rm -f $(CURDIR)/debian/$(MANUAL)-$$lang.install; done
endif

distclean: clean

.PHONY: all publish clean distclean validate
.SUFFIXES:

