DOC=i18n_l10n_in_Debian

all: pdf

pdf: $(DOC).pdf
$(DOC).pdf: $(DOC).tex
	pdflatex $<
	pdflatex $<

pdfclean: 
	rm -f *.pdf 
clean:
	rm -f *.pdf *.aux *.log *.toc *.nav *.snm

rebuild: clean all
