#
# Makefile for the Debian FAQ
#
# Should work both for a manual in the Debian Documentation Project
# manuals.sgml tree, and for doc-debian package build.

SRCS = debian-faq.sgml faqstatic.ent faqdynamic.ent $(wildcard *.sgml)

# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html

all:

publish: debian-faq.html/index.html
	test -d $(PUBLISHDIR)
	rm -f $(PUBLISHDIR)/debian-faq/*.html
	install -p -m 644 debian-faq.html/*.html $(PUBLISHDIR)/debian-faq/

faqdynamic.ent:
	echo "<!entity docdate \"$(shell date +'%-d %B %Y')\">" > faqdynamic.ent
	if [ -f ../debian/changelog ]; then \
          echo "<!entity docversion \"$(shell LC_ALL=C cd .. && dpkg-parsechangelog | grep '^Version: ' | sed 's/^Version: *//')\">" >> faqdynamic.ent; \
        else \
          echo "<!entity docversion \"CVS\">" >> faqdynamic.ent; \
        fi

validate:
	nsgmls -gues debian-faq.sgml

clean distclean:
	rm -f debian-faq.{txt,ps,dvi,info*,aux,log,man,tex,toc}
	rm -f *~ .*~ core tsa*
	rm -rf debian-faq.html
	test -f ../debian/changelog || rm -f faqdynamic.ent

html debian-faq.html/index.html: $(SRCS)
	debiandoc2html debian-faq.sgml

txt debian-faq.txt: $(SRCS)
#	sdc -Rlinuxdoc -Rno-margin -O ascii -o debian-faq.tmp debian-faq.sgml
#	cat debian-faq.tmp | sed 's/--  / -  /g' >debian-faq.txt
#	rm -f debian-faq.tmp
	debiandoc2text debian-faq.sgml

ps debian-faq.ps: $(SRCS)
	debiandoc2latexps debian-faq.sgml

dvi debian-faq.dvi: $(SRCS)
	debiandoc2latex -o dvi debian-faq.sgml

#man debian-faq.man: $(SRCS)
#	debiandoc2txt -man debian-faq.sgml

info debian-faq.info: $(SRCS)
#	sdc -Rlinuxdoc -O info -o debian-faq.info debian-faq.sgml
	debiandoc2info debian-faq.sgml

# these may or may not be working, beware!

install: install-ftp install-www

install-www:
	ssh master.debian.org \
		'cd /home/Archives/DebianWebMaster/debian.org/FAQ  && \
		 co -l debian-faq*.html'
	scp debian-faq*.html \
		master.debian.org:/home/Archives/DebianWebMaster/debian.org/FAQ
	ssh master.debian.org \
		'cd /home/Archives/DebianWebMaster/debian.org/FAQ  &&  \
		 ci -u -m. debian-faq*.html'

install-ftp:
	scp tweaked/debian-faq.txt debian-faq.info debian-faq*.html \
		debian-faq.ps \
		master.debian.org:../ftp/debian/doc/FAQ/

.PHONY: all publish clean distclean validate install install-ftp install-www
