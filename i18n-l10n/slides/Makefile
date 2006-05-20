DOC=i18n_l10n_in_Debian

all: pdf

# You need both the latex-beamer and  latex-ucs packages for this
# to work properly
pdf: $(DOC).pdf
$(DOC).pdf: $(DOC).tex
	pdflatex $<
	pdflatex $<

pdfclean: 
	rm -f *.pdf 
clean:
	rm -f *.pdf *.aux *.log *.toc *.nav *.snm *.out

rebuild: clean all
