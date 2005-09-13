TEX =	latex

SRCS = debian-faq-es.sgml faqstatic.ent faqdynamic.ent $(wildcard *.sgml)
SGMLFLAGS = -l es

all:	html txt ps pdf # info

clean::	
	rm -f *.txt *.ps *.pdf *.dvi *.info* *.aux *.log *.man *.tex *.toc
	rm -f faqdynamic.ent *~ .*~
	rm -rf debian-faq-es.html

faqdynamic.ent:
	LC_ALL=es_ES && echo "<!entity docdate \"$(shell date +'%-d de %B de %Y')\">" > faqdynamic.ent

text::	debian-faq-es.txt
txt::	debian-faq-es.txt

html::	debian-faq-es.html

ps::	debian-faq-es.ps

dvi::  debian-faq-es.dvi

pdf::  debian-faq-es.pdf

info::	debian-faq-es.info

debian-faq-es.tex: $(SRCS)
	debiandoc2latex $(SGMLFLAGS) debian-faq-es.sgml

debian-faq-es.dvi:		debian-faq-es.tex
	- $(TEX) $^
	- $(TEX) $^
	$(TEX) $^

debian-faq-es.man: 	$(SRCS)
	sgml2txt $(SGMLFLAGS) -man debian-faq-es.sgml

debian-faq-es.ps: debian-faq-es.dvi
	dvips -o $@ $^

debian-faq-es.pdf: debian-faq-es.ps
	ps2pdf $< $@

debian-faq-es.info: $(SRCS)
	sgml2info $(SGMLFLAGS) debian-faq-es.sgml

debian-faq-es.txt: $(SRCS)
	debiandoc2text $(SGMLFLAGS) debian-faq-es.sgml

debian-faq-es.html: $(SRCS)
	debiandoc2html $(SGMLFLAGS) debian-faq-es.sgml


#debian-faq-es.ps:	$(SRCS)
#	sdc -Rlinuxdoc -O ps -o debian-faq-es.ps debian-faq-es.sgml

#debian-faq-es.info:	$(SRCS)
#	sdc -Rlinuxdoc -O info -o debian-faq-es.info debian-faq-es.sgml

#debian-faq-es.txt:	$(SRCS)
#	sdc -Rlinuxdoc -Rno-margin -O ascii -o debian-faq-es.txt debian-faq-es.sgml

#debian-faq-es.html:	$(SRCS)
#	sdc -Rlinuxdoc -O html -o debian-faq-es.html debian-faq-es.sgml
