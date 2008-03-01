# (C) 2004, 2005, 2008 W. Martin Borgert debacle@debian.org
# See COPYING for the license status of this software.

# You need to apt-get install
# docbook-xsl pdfjam pdftk po4a xmlroff xpdf-utils xsltproc

FOP=fop
# The "--keep 0" should be removed as soon as the translations are ready
TRANSLATE=po4a-translate --format docbook --keep 0
XP=xsltproc --nonet --novalid
XMLROFF_GP=xmlroff --backend gp
XMLROFF_CAIRO=xmlroff --backend cairo

# Not yet implemted in the FO version
ifneq ($(AD),)
    ad=--stringparam ad $(AD)
else
    ad=
endif

PO_FILES=$(wildcard po4a/*.po)
# international standard format
A4_LANGS=en $(patsubst po4a/%.po,%,$(PO_FILES))
# non-standard format for north america
LT_LANGS=en es fr
# xmlroff has some issues, so we can use FOP instead. FOP,
# however, fails on non Western European languages and is not
# yet in Debian/main. Call make with USE_FOP=1 (use FOP for some
# languages) or USE_FOP=2 (use always FOP)
ifdef USE_FOP
    ifeq ($(USE_FOP),2)
	XMLROFF_LANGS=
    else
 	XMLROFF_LANGS=bg cs el he hu ja nb pl ro ru sk tr uk vi zh_CN
    endif
else
    XMLROFF_LANGS=$(A4_LANGS)
endif

# Some language lead to a segfault in the gp backend of xmlroff.
# The cairo backend does not yet support graphics, however.
XMLROFF_CAIRO_LANGS=de el nl pt_PT

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

refcard-%.s.pdf: refcard-%.fo
	LANG=`echo $@ | sed 's/.*-\(.*\)-.*/\1/'`; \
	USE_XR=`echo " $(XMLROFF_LANGS) " | grep " $$LANG "`; \
	if [ -n "$$USE_XR" ]; then \
	    USE_CAIRO=`echo " $(XMLROFF_CAIRO_LANGS) " | grep " $$LANG "`; \
	    if [ -n "$$USE_CAIRO" ]; then \
		$(XMLROFF_CAIRO) -o $@ $<; \
	    else \
		$(XMLROFF_GP) -o $@ $<; \
	    fi \
	else \
	    $(FOP) $< $@; \
	fi

refcard-%-a4.t.pdf: refcard-%-a4.s.pdf
	pdfnup --nup 3x1 --outfile $@ --pages 5-6,1-4 \
	    --paper a4paper $<

refcard-%-lt.t.pdf: refcard-%-lt.s.pdf
	pdfnup --nup 3x1 --outfile $@ --pages 5-6,1-4 \
	    --paper letterpaper $<

refcard-%.pdf: refcard-%.t.pdf metadata.xsl
	LANG=`echo $@ | sed 's/.*-\(.*\)-.*/\1/'`; \
	$(XP) metadata.xsl entries-$$LANG.dbk | \
	pdftk $< update_info - output $@

entries-%.dbk: po4a/%.po entries.dbk
	$(TRANSLATE) -m entries.dbk -p $< -l $@

.PHONY: all clean count mrproper

all: index.html $(PDFS) check

entries-en.dbk: entries.dbk
	cp -f $< $@

statistics.xml: $(PO_FILES) Makefile
	( \
	    echo '<?xml version="1.0" encoding="utf-8"?>'; \
	    echo '<statistics>'; \
	    for po in $(PO_FILES); do \
		echo -n $$po | sed -e 's,po4a/,<s l=",' -e 's,\.po,">,'; \
		msgfmt --statistics $$po 2>&1 | \
		    sed -e 's|\([0-9]*\) translated messages*|\1\&#x00A0;ok|' \
			-e 's|\([0-9]*\) fuzzy translations*|\1\&#x00A0;fuzzy|' \
			-e 's|\([0-9]*\) untranslated messages*|\1\&#x00A0;todo|' \
			-e 's|$$|</s>|'; \
	    done; \
	    echo '</statistics>'; \
	) > $@

index.html: refcard.dbk $(ENTRIES) statistics.xml html.xsl
	$(XP) --xinclude html.xsl $< > index.html

install:
	if [ -n "$$DESTDIR" ]; then \
	    mkdir -p $$DESTDIR; \
	    cp -fp index.html *.png $(PDFS) $(DESTDIR)/; \
	fi

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
	    $(ENTRIES) statistics.xml

mrproper: clean
	-rm -f index.html $(PDFS)
