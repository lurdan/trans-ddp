# Makefile, used for the DDP manuals.sgml area

MANUAL		:= $(notdir $(shell pwd))
PUBLISHDIR	:= ../../../public_html/manuals.html

TARGETS		:= $(foreach fmt,html txt pdf,developers-reference.$(fmt)) \
		   $(filter-out developers-reference.ja.pdf, \
		      $(foreach langext,.ja .fr, \
		         $(foreach fmt,html txt pdf,developers-reference$(langext).$(fmt))))

# programs for creating output
DEBIANDOC2HTML	:= debiandoc2html -d debiandoc.decl -c
DEBIANDOC2TEXT	:= debiandoc2text -d debiandoc.decl
DEBIANDOC2LATEX	:= debiandoc2latex -d debiandoc.decl

make_directory	:= install -d -m 755
install_file	:= install -m 644 -p

MAX_TEX_RECURSION := 5

.PHONY:	all
all:    $(TARGETS)

# hmmm, this rule may need to be revised/tested
publish:	all
	[ -d $(PUBLISHDIR) ] || exit 1
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	$(make_directory) $(PUBLISHDIR)/$(MANUAL)
	$(install_file) developers-reference*.html/*.html	\
	   $(PUBLISHDIR)/$(MANUAL)

developers-reference.html:	developers-reference.sgml
	$(DEBIANDOC2HTML) -l C $<

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
	-cp -pf $(basename $<).aux prior.aux 2>/dev/null
#	 fail if we don't have pdflatex correctly installed
	kpsewhich pdflatex.fmt >/dev/null
#	 due to a bug in debiandoc2latex2e output, this might fail
	-pdflatex '\nonstopmode\input{$<}' >/dev/null # see $(@:.pdf=.log) for details
	@set -e								;\
	if ! cmp $(basename $<).aux prior.aux 2>/dev/null &&		\
	   ! cmp $(basename $<).aux pprior.aux 2>/dev/null; then	\
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

.PHONY: clean
clean:
	rm -rf developers-reference*.html
	rm -f developers-reference*.txt developers-reference*.pdf \
	      developers-reference*.ps developers-reference*.lout* lout.li \
	      developers-reference*.sasp* developers-reference*.tex \
	      developers-reference*.aux developers-reference*.toc \
	      developers-reference*.idx developers-reference*.log \
	      developers-reference*.out
	rm -f version.ent
	rm -f `find . -name "*~"`

developers-reference$(SRCEXT).sgml: version.ent common.ent

html: $(MANUAL).html
