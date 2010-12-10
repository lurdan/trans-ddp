#
# Makefile for the Debian New Maintainers' Guide
#
# All source files use UTF-8 encoding
#
# Language names are in lowercase web suffix style without encoding.
# In adendum <lang>.*.add files, you can use any number for middle *.
#
# Debian maint-guide package target:
#  * make all
#
# Debian Documentation Project target:
#  * make publish
#
# Test build of incomplete PO file(s) to sgml and html
#  * make new
#  (Please note this will overwrite corresponding sgml file)

# Basename for SGML sources
MANUAL		:= maint-guide

# Language which is the base of all files
LANG_EN		:= en

# Language which is supported directly by SGML files (Customizable)
# These should be converted to PO files ASAP
LANG_SGML	:= de ja ko pl pt-br ru
 
# Language which generates SGML files from PO files (Customizable)
LANG_PO		:= es fr it zh-cn zh-tw

# Language which is excluded from producing PS, PDF (Customizable)
LANG_CJK	:= ko
#LANG_CJK	:= 

# Language group
LANG_ALL	:= $(LANG_EN) $(LANG_PO) $(LANG_SGML)
LANG_NOE	:= $(filter-out en,$(LANG_ALL))
LANG_NOCJK	:= $(filter-out $(LANG_CJK),$(LANG_ALL))
LANG_NOCJKE	:= $(filter-out $(LANG_CJK) en,$(LANG_ALL))

# For package building (all)
DEBIAN_DIR	:= $(CURDIR)/debian
all:
	$(MAKE) version.ent
	$(MAKE) sgml
	$(MAKE) html txt ps pdf
	for lang in $(LANG_NOCJKE); do sed -e "s/@@/$$lang/g" < $(DEBIAN_DIR)/all-nocjke.install-in > $(DEBIAN_DIR)/$(MANUAL)-$$lang.install; done
	for lang in $(LANG_CJK);    do sed -e "s/@@/$$lang/g" < $(DEBIAN_DIR)/all-cjk.install-in    > $(DEBIAN_DIR)/$(MANUAL)-$$lang.install; done

version.ent:
	echo '<!entity' "docisodate \"$(shell LC_ALL=C date -u +'%F %T %Z')\">" > version.ent
	echo '<!entity' "docversion \"$(shell LC_ALL=C dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//')\">" >> version.ent

# For web page building (publish)
# this can and will be overriden by a higher level makefile
PUBLISHDIR	:= /org/www.debian.org/www/doc/manuals
publish: 
	echo '<!entity docisodate "$(shell LC_ALL=C date -u +'%F %T %Z')">' > version.ent
	echo '<!entity docversion "$(shell LC_ALL=C dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//')-svn">' >> version.ent
	$(MAKE) sgml
	$(MAKE) html txt ps pdf
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	# remove old files
	install -p -m 644 $(MANUAL)*.html/*.html $(PUBLISHDIR)/$(MANUAL)/
	install -p -m 644 $(MANUAL)*.txt $(MANUAL)*.ps $(MANUAL)*.pdf $(PUBLISHDIR)/$(MANUAL)
	echo "AddCharset UTF-8 .txt" > $(PUBLISHDIR)/$(MANUAL)/.htaccess

# generating SGML files from PO files
# -M : master file $(MANUAL).en.sgml is always in UTF-8
PO_UPDATE	:= po4a-updatepo --previous -M UTF-8 -f sgml
#PO_UPDATE	:= po4a-updatepo --previous --msgmerge-opt --no-wrap -M UTF-8 -f sgml
PO_TRANSLATE	:= po4a-translate  -M UTF-8 -f sgml --keep 0
PO_GETTEXT	:= po4a-gettextize -M UTF-8 -f sgml

# This target is run manually under sid before squeeze release
tw:
	msgcat --no-wrap $(MANUAL).zh-cn.po | opencc | sed -f cn2tw.sed | msgcat - > $(MANUAL).zh-tw.po

sgml:
	if ! [ -f version.ent ]; then $(MAKE) version.ent; fi
	for lang in $(LANG_PO); do \
		echo "Translate to: $$lang" ;\
		$(MAKE) $(MANUAL).$$lang.sgml ;\
        done

$(MANUAL).pot: $(MANUAL).en.sgml
	$(PO_GETTEXT) -o ignore-inclusion=version -m $< -p $@

# Note for $(MANUAL).%.sgml target:
# This is essentially executing
#    |  $(PO_UPDATE) ...
#    |  $(PO_TRANSLATE) ...
# if only ?? is listed in $(LANG_PO).  This allows us to keep old 
# $(MANUAL).??.sgml to build other files while new immature $(MANUAL).??.po
# can be commited in VCS as long as $(LANG_PO) does not include ??.
#
# If "de" is not in $(LANG_PO) yet but you wish to build from PO file while 
# overwriting SGML for testing, you make test build by 
# "make html LANG_ALL=de LANG_PO=de".
# 
# Note for PO_TRANSLATE command line:
#  -L : Charset of the file containing the localized document. UTF-8
#  xargs -n1 is to split into lines
#  sed script is to add "-a" to automatically add addendum files.
$(MANUAL).%.sgml: $(MANUAL).%.po $(MANUAL).en.sgml
	if echo "$(LANG_PO)" | grep -q "$*" ; then \
		$(PO_UPDATE) -o ignore-inclusion=version -m $(MANUAL).en.sgml -p $(MANUAL).$*.po ;\
		$(PO_TRANSLATE) -v -L UTF-8 -m $(MANUAL).en.sgml -l $@ -p $< \
		    $$(echo $*.*.add|xargs -n1|sed -ne 's/^\([^*]*\.add\)$$/-a \1/p') \
		    -o ignore-inclusion=version ;\
	fi

# generating HTML
# ugly because the normal stuff works only as PHONYs. :(
#$(MANUAL).%.html/index.%.html: $(MANUAL).%.sgml
#	debiandoc2html -c -l $* $<
html:
	if ! [ -f version.ent ]; then $(MAKE) version.ent ; $(MAKE) po; fi
	for lang in $(LANG_ALL); do \
	  if /usr/bin/test \( ! -e $(MANUAL).$$lang.html/index.$$lang.html \) \
			-o \( $(MANUAL).$$lang.sgml -nt $(MANUAL).$$lang.html/index.$$lang.html \); then \
            debiandoc2html -C -l $$lang.utf-8 $(MANUAL).$$lang.sgml; \
          fi; \
        done

# generating plain text
txt text: $(patsubst %,$(MANUAL).%.txt,$(LANG_ALL))

$(MANUAL).%.txt: $(MANUAL).%.sgml
	debiandoc2text -l $*.utf-8 $<

# generating PostScript
ps: $(patsubst %,$(MANUAL).%.ps,$(LANG_NOCJK))

$(MANUAL).%.ps: $(MANUAL).%.sgml
	debiandoc2latexps -l $*.utf-8 $<

# generating Portable Document Format
pdf: $(patsubst %,$(MANUAL).%.pdf,$(LANG_NOCJK))

$(MANUAL).%.pdf: $(MANUAL).%.sgml
	debiandoc2latexpdf -l $*.utf-8 $<

# validating SGML ::: not used!
validate:
	@set -x; for i in $(wildcard *.sgml); do nsgmls -ges -wall $$i; done

# cleaning up
clean:
	for ext in txt ps dvi pdf log tex aux toc out tpt tex-in ; do \
		rm -f $(MANUAL)*.$$ext ;\
	done
	rm -f .htaccess
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
	#rm -f $(MANUAL).zh-tw.po
	if [ -e $(PUBLISHDIR) ]; then rm -rf $(PUBLISHDIR)/$(MANUAL); fi
	for lang in $(LANG_NOE); do rm -f $(DEBIAN_DIR)/$(MANUAL)-$$lang.install; done

distclean: clean

.PHONY: all publish clean distclean validate
.PHONY: sgml tw html text txt ps pdf
.SUFFIXES:

