# Makefile, used for the DDP manuals.sgml area

MANUAL		:= $(notdir $(shell pwd))
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

SOURCES		:= $(wildcard *.sgml)

TARGETS		:= $(foreach fmt,html txt pdf,developers-reference.$(fmt)) \
		     $(filter-out developers-reference.ja.pdf, \
		       $(foreach langext,.ja .fr, \
		         $(foreach fmt,html txt pdf,developers-reference$(langext).$(fmt))))

# programs for creating output
DEBIANDOC2HTML	:= debiandoc2html -c
DEBIANDOC2TEXT	:= debiandoc2text
DEBIANDOC2LATEX	:= debiandoc2latex

make_directory	:= install -d -m 755
install_file	:= install -m 644 -p

MAX_TEX_RECURSION := 5

.PHONY:	all
all:    $(TARGETS)

.PHONY: validate
validate:	$(addsuffix .validate,$(SOURCES))

# hmmm, this rule may need to be revised/tested
publish:	all
	[ -d $(PUBLISHDIR) ] || exit 1
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	$(make_directory) $(PUBLISHDIR)/$(MANUAL)
	$(install_file) developers-reference*.html/*.html	\
	   $(PUBLISHDIR)/$(MANUAL)

developers-reference.html:	developers-reference.sgml
	$(DEBIANDOC2HTML) -l C $<

developers-reference.html/*:	developers-reference.html

developers-reference.%.html:	developers-reference.%.sgml
	$(DEBIANDOC2HTML) -l $* $<

developers-reference.txt:	developers-reference.sgml
	$(DEBIANDOC2TEXT) -l C -O $< > $@

developers-reference.%.txt:	developers-reference.%.sgml
	$(DEBIANDOC2TEXT) -l $* -O $< > $@

developers-reference.tex:	developers-reference.sgml
	$(DEBIANDOC2LATEX) -l C -O $< > $@

developers-reference.%.tex:	developers-reference.%.sgml
	$(DEBIANDOC2LATEX) -l $* -O $< > $@

%.pdf:	%.tex
#	 note that I have seen bi-stable .aux files, thus we check two levels deep
	-cp -pf prior.aux pprior.aux 2>/dev/null
	-cp -pf $*.aux prior.aux 2>/dev/null
#	 fail if we don't have pdflatex correctly installed
	kpsewhich pdflatex.fmt >/dev/null
#	 due to a bug in debiandoc2latex2e output, this might fail
	-pdflatex '\nonstopmode\input{$<}' >/dev/null # see $(@:.pdf=.log) for details
	@set -e								;\
	if ! cmp $*.aux prior.aux 2>/dev/null &&		\
	   ! cmp $*.aux pprior.aux 2>/dev/null; then	\
		if expr $(MAKELEVEL) '<' $(MAX_TEX_RECURSION) >/dev/null;\
		then							\
		   echo "remaking $@ (take $(MAKELEVEL))"		;\
		   rm -f $@						;\
		   $(MAKE) $@						;\
		else							\
		   echo "E: $@ needs remaking, but we have reached max. level, $(MAX_TEX_RECURSION)" ;\
		fi							\
	fi
	rm -f prior.aux pprior.aux

version.ent:	debian/changelog
	./debian/rules $@

%.validate : % version.ent
	nsgmls -wall -gues $<
	touch $@

USERMAP	:= ../../ddp/CVSROOT/users
.PHONY: prepare
prepare:
	@[ -f CVS/Root -a -f $(USERMAP) ] || \
		( echo "silly rabbit, prepare is for Adam" 1>&2; exit 1 )
	cvs2cl -r --usermap $(USERMAP)
	cvs ci -m "update for next release" ChangeLog

.PHONY: clean
clean:
	rm -rf developers-reference*.html
	rm -f developers-reference*.txt developers-reference*.pdf \
	      developers-reference*.ps developers-reference*.lout* lout.li \
	      developers-reference*.sasp* developers-reference*.tex \
	      developers-reference*.aux developers-reference*.toc \
	      developers-reference*.idx developers-reference*.log \
	      developers-reference*.out developers-reference*.dvi
	rm -f version.ent
	rm -f `find . -name "*~" -o -name "*.bak"`
	rm -f *.validate
	rm -f *~ *.bak .#* core

.PHONY: distclean
distclean: clean
	rm -f *.rej *.orig

developers-reference$(SRCEXT).sgml: version.ent common.ent

html: $(MANUAL).html
