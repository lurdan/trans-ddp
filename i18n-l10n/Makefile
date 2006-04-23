BASENAME=debian-i18n-l10n
SOURCE=$(BASENAME).xml

all: html pdf tex

tex: $(BASENAME).tex
$(BASENAME).tex: $(SOURCE)
	docbook2tex $<

html: $(BASENAME).html
$(BASENAME).html: $(SOURCE)
	docbook2html $<

pdf: $(BASENAME).pdf
$(BASENAME).pdf: $(SOURCE)
	docbook2pdf $<

validate:
	xmllint --valid --noout $(SOURCE)

clean:
	rm -f *html *pdf *ps *dvi *tex
