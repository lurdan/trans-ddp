# potato or above
XML_DECL=/usr/lib/sgml/declaration/xml.dcl
# slink or above
#XML_DECL=/usr/lib/sgml/declaration/xml.decl

DEBIAN_VERSIONS := potato
# don't need slink

# DDP standard
MANUAL := $(shell basename $(shell pwd))
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

.DELETE_ON_ERROR:

all: 
	@for subdir in ${DEBIAN_VERSIONS}; do \
		(cd $$subdir && ${MAKE} $@) \
	done

html: 
	@for subdir in ${DEBIAN_VERSIONS}; do \
		(cd $$subdir && ${MAKE} $@) \
	done

validate:
	nsgmls -s -wxml $(XML_DECL) howto.db

index.html: index.wml
	wml -o $@ $<

install:  index.html 
	scp $< howto.db *.dsl Makefile bortz@www.debian.org:public_html/SGML-HOWTO/
	@for subdir in ${DEBIAN_VERSIONS}; do \
		(cd $$subdir && ${MAKE} $@) \
	done
	$(MAKE) Debian-SGML.tar.gz
	scp Debian-SGML.tar.gz bortz@www.debian.org:public_html/SGML-HOWTO/

# DDP standard
# This target installs the generated HTML in the published directory.
publish: html
	test -d $(PUBLISHDIR)/$(MANUAL) || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	install -m 644 --preserve-timestamps potato/*.html $(PUBLISHDIR)/$(MANUAL)/
	ln -sf howto.html $(PUBLISHDIR)/$(MANUAL)/index.html

Debian-SGML.tar: distclean
	(cd ..; tar  --exclude=CVS --exclude=.wmlrc  --exclude=latex-ss -cvf Debian-HOWTO/$@ Debian-HOWTO)

Debian-SGML.tar.gz: Debian-SGML.tar
	gzip -9 -v -f $<

clean: 
	rm -f *.tar* index.html
	@for subdir in ${DEBIAN_VERSIONS}; do \
		(cd $$subdir && ${MAKE} $@) \
	done

distclean: clean
	rm -f *~
