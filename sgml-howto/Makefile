XML_DECL=/usr/lib/sgml/declaration/xml.decl
DEBIAN_VERSIONS=potato slink

all: 
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

Debian-SGML.tar: distclean
	(cd ..; tar  --exclude=CVS --exclude=.wmlrc  -cvf Debian-HOWTO/$@ Debian-HOWTO)

Debian-SGML.tar.gz: Debian-SGML.tar
	gzip -9 -v -f $<

clean: 
	rm -f *.tar* index.html
	@for subdir in ${DEBIAN_VERSIONS}; do \
		(cd $$subdir && ${MAKE} $@) \
	done

distclean: clean
	rm -f *~












