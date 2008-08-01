# (C) 2004, 2005, 2008 W. Martin Borgert debacle@debian.org
# See COPYING for the license status of this software.

# You need to apt-get install
# docbook-xsl pdfjam pdftk po4a xmlroff xpdf-utils xsltproc

# The "--keep 0" should be removed as soon as the translations are ready
TRANSLATE=po4a-translate --format docbook --keep 0
UPDATEPO=po4a-updatepo --format docbook
XP=xsltproc --nonet --novalid
XMLROFF=xmlroff --backend cairo
# cairo backend of xmlroff 0.6.0 crashes on some languages (#492597)
GPLIST=eu ja sv
XMLROFF_GP=xmlroff --backend gp
DIA=dia

# Not yet implemted in the new version (neither FO nor dblatex)
#ifneq ($(AD),)
#    ad=--stringparam ad $(AD)
#else
#    ad=
#endif

PO_FILES=$(wildcard po4a/*.po)
# international standard format
A4_LANGS=en $(patsubst po4a/%.po,%,$(PO_FILES))
# non-standard format for north america
LT_LANGS=en es fr

# xmlroff has some issues, so we can use FOP instead. FOP,
# however, fails on non Western European languages and is not
# yet in Debian/main. Call make with USE_FOP=1 (use FOP for some
# languages) or USE_FOP=2 (use always FOP)
FOP=fop
ifdef USE_FOP
    ifeq ($(USE_FOP),2)
	XMLROFF_LANGS=
    else
	XMLROFF_LANGS=bg cs el he hu ja nb pl ro ru sk tr uk vi zh_CN
    endif
else
    XMLROFF_LANGS=$(A4_LANGS)
endif

# Because of current limitations of xmlroff in respect to layout, we
# can also use dblatex. Like fop, we are limited to some languages.
# See #492366 (el), #492304 (es, it), #492365 (he), #492350 (ja),
# #482857 (zh_CN)
DBLATEX=dblatex --backend=xetex --texstyle=refcard.sty --xsl-user=dblatex.xsl
ifdef USE_DBLATEX
    ifeq ($(USE_DBLATEX),2)
	XMLROFF_LANGS=
    else
	XMLROFF_LANGS=el es he it ja zh_CN
    endif
else
    XMLROFF_LANGS=$(A4_LANGS)
endif

ENTRIES=$(patsubst %,entries-%.dbk,$(A4_LANGS))

PDFS=$(patsubst %,refcard-%-a4.pdf,$(A4_LANGS)) \
    $(patsubst %,refcard-%-lt.pdf,$(LT_LANGS))

refcard-%.dbk: entries-%.dbk preproc.xsl refcard.dbk
	$(XP) preproc.xsl $< > $@

refcard-%-a4.fo: refcard-%.dbk fo.xsl
	$(XP) fo.xsl $< > $@

refcard-%-lt.fo: refcard-%.dbk fo.xsl
	$(XP) --stringparam page.height 216mm \
	    --stringparam page.width 93mm fo.xsl $< > $@

# the .fo is not used for dblatex, but I don't care
refcard-%.s.pdf: refcard-%.fo dblatex.xsl refcard.sty
	L=`echo $@ | sed 's/.*-\(.*\)-.*/\1/'`; \
	USE_XR=`echo " $(XMLROFF_LANGS) " | grep " $$L "`; \
	if [ -n "$$USE_XR" ]; then \
	    USE_GP=`echo " $(GPLIST) " | grep " $$L "`; \
	    if [ -n "$$USE_GP" ]; then \
		$(XMLROFF_GP) -o $@ $<; \
	    else \
		$(XMLROFF) -o $@ $<; \
	    fi; \
	else \
	    if [ -n "$$USE_DBLATEX" ]; then \
		SRC=`echo $<|sed 's/-\(a4\|lt\).fo/.dbk/'`; \
		FMT=`echo $<|sed 's/.*-\(a4\|lt\).fo/\1/'`; \
		$(DBLATEX) --output=$@ --param=format=$$FMT $$SRC; \
	    else \
		$(FOP) $< $@; \
	    fi; \
	fi

refcard-%-a4.t.pdf: refcard-%-a4.s.pdf empty.pdf
	pdfjoin --fitpaper true --outfile $<.x.pdf $< empty.pdf empty.pdf
	pdfnup --nup 3x1 --outfile $@ --pages 5-6,1-4 \
	    --paper a4paper $<.x.pdf
	rm $<.x.pdf

refcard-%-lt.t.pdf: refcard-%-lt.s.pdf empty.pdf
	pdfjoin --fitpaper true --outfile $<.x.pdf $< empty.pdf empty.pdf
	pdfnup --nup 3x1 --outfile $@ --pages 5-6,1-4 \
	    --paper letterpaper $<.x.pdf
	rm $<.x.pdf

refcard-%.pdf: refcard-%.t.pdf metadata.xsl
	L=`echo $@ | sed 's/.*-\(.*\)-.*/\1/'`; \
	$(XP) metadata.xsl entries-$$L.dbk | \
	pdftk $< update_info - output $@

entries-%.dbk: po4a/%.po entries.dbk
	$(TRANSLATE) -m entries.dbk -p $< -l $@

all: index.html $(PDFS) check

updatepo: $(PO_FILES) po4a/entries.pot
$(PO_FILES) po4a/entries.pot: entries.dbk
	$(UPDATEPO) --master $< --po $@

tidypo:
	for po in $(PO_FILES) po4a/entries.pot; do \
	    msgcat $$po > $$po.tmp && mv $$po.tmp $$po; \
	done

# make sure, we have always at least six pages for pdfnup
empty.fo: empty.dbk fo.xsl
	$(XP) fo.xsl $< > $@

empty.pdf: empty.fo
	$(XMLROFF) -o $@ $<

.PHONY: all clean count mrproper

entries-en.dbk: entries.dbk
	cp -f $< $@

statistics.xml: $(PO_FILES) Makefile
	( \
	    LANG=C; export LANG; \
	    echo '<?xml version="1.0" encoding="utf-8"?>'; \
	    echo '<statistics>'; \
	    for po in $(PO_FILES); do \
		L=`basename $$po .po`; \
		echo -n '<s l="'$$L'">'; \
		msgfmt --statistics $$po 2>&1 | \
		    sed -e 's|\([0-9]*\) translated messages*|\1\&#x00A0;ok|' \
			-e 's|\([0-9]*\) fuzzy translations*|\1\&#x00A0;fuzzy|' \
			-e 's|\([0-9]*\) untranslated messages*|\1\&#x00A0;todo|' \
			-e 's|$$|</s>|'; \
		grep '^"Last-Translator:' $$po | \
		    sed -e 's/</\&lt;/g' -e 's/>/\&gt;/g' | \
		    sed 's,"Last-Translator: *\(.*\)\\n.*,<t l="'$$L'">\1</t>,'; \
	    done; \
	    echo '</statistics>'; \
	) > $@

statistics.txt: statistics.xml
	cat $< | grep '^<s ' | sed -e 's/<s l="//' -e 's/">/	/' \
	    -e 's/&#x00A0;/ /g' -e 's/<\/s>//' > $@

index.html: refcard.dbk $(ENTRIES) statistics.xml html.xsl
	$(XP) --xinclude html.xsl $< > $@

refcard.png: refcard.dia
	$(DIA) --export=$@ $<

install: index.html refcard.png
	if [ -n "$$DESTDIR" ]; then \
	    mkdir -p $$DESTDIR; \
	    cp -fp openlogo-nd-25.png $(PDFS) $(DESTDIR)/; \
	    if [ -n "$$GZIPPED" ]; then \
		cat index.html | \
		sed 's/\(href="refcard-.*-\(a4\|lt\).pdf\)"/\1.gz"/g' \
		> $(DESTDIR)/index.html; \
	    else \
		cp index.html  $(DESTDIR)/; \
	    fi; \
	fi

checkpo:
	@for po in $(PO_FILES); do \
	    echo $$po; \
	    msgfmt --check --verbose $$po; \
	done

check:
	@for p in $(PDFS); do \
	    if [ \! -e $$p ]; then \
	        echo "ERROR: $$p does not exist!" 1>&2 ||:; \
		continue; \
            fi; \
	    PAGES=`pdfinfo -meta $$p | grep ^Pages | sed 's/.*  *//'`; \
	    [ "$$PAGES" -ne 2 ] && \
	    echo "ERROR: $$p has $$PAGES pages instead of 2!" 1>&2 ||:; \
	done

count:
	@for d in $(ENTRIES); do \
	    IDS=`grep '<glossentry id=' $$d | wc -l`; \
	    echo $$IDS	$$d; \
	done | sort -nr

clean:
	-rm -f *~ refcard-*.dbk refcard-*.fo refcard-*.[st].pdf \
	    $(ENTRIES) statistics.xml statistics.txt messages.mo \
	    empty.fo empty.pdf

mrproper: clean
	-rm -f index.html refcard.png $(PDFS) entries-*.dbk
