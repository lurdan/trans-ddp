# Makefile, only used for the DDP manuals.sgml area

MANUAL		:= $(shell basename $(shell pwd))
PUBLISHDIR	:= ../../../public_html/manuals.html/$(MANUAL)

publish:	html
	[ -d ../../../public_html ] || exit 1
	rm -f $(PUBLISHDIR)/*.html
	install -d $(PUBLISHDIR)
	install -m 644 --preserve-timestamps $(MANUAL).html/*.html $(PUBLISHDIR)

html:
	debian/rules build

clean:
	debian/rules clean

