# Makefile, used for the DDP manuals.sgml area

MANUAL		:= $(notdir $(shell pwd))
PUBLISHDIR	:= ../../../public_html/manuals.html

all: build

publish:	build
	[ -d $(PUBLISHDIR) ] || exit 1
	rm -f $(PUBLISHDIR)/$(MANUAL)/*.html
	install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	install -m 644 --preserve-timestamps $(MANUAL).html/*.html	\
	   $(PUBLISHDIR)/$(MANUAL)

.PHONY:	build
build:
	debian/rules build

.PHONY: clean
clean:
	debian/rules clean
