#
# Makefile for the release notes, top-level
#

# m68k port is included in the source, but should not be built by default
# as the port is not supported for Etch but may yet be for Lenny.
# It can still be built by explicitly specifying 'architecture=m68k'
arches := $(shell grep '\[ <!entity arch-title' release-notes.ent | awk '{print $$2}' | sed s/%// | grep -v 'm68k')

ifeq "$(OFFICIALWEBBUILD)" "true"
  install_file 	:= install -m 2664 -p
  makedir	:= mkdir -p -m 2775
else
  install_file	:= install -m 644 -p
  makedir	:= mkdir -p -m 0755
endif

# The following languages are currently disabled
# sk: old Sarge translations missing essential information
# vi: Not supported by the Sarge build system (lets ask the webmaster for an upload?)
# All translations disabled; will be enabled as updates for Etch come in
LANGUAGES := en fr pt

LANGUAGES-publish := $(addsuffix -publish,$(LANGUAGES))
LANGUAGES-clean := $(addsuffix -clean,$(LANGUAGES))

.SUFFIXES: 
.PHONY: publish all clean $(LANGUAGES) $(LANGUAGES-publish)

all: $(LANGUAGES)

$(LANGUAGES):
	-$(MAKE) -C $@

publish: clean
ifneq "$(PUBLISHDIR)" ""
	set -ex; \
	for arch in $(arches); do \
	  $(MAKE) architecture=$$arch; \
	  $(makedir) $(PUBLISHDIR)/$$arch/release-notes; \
	  $(makedir) release-notes-$$arch; \
	  for lang in $(LANGUAGES); do \
	    $(makedir) release-notes-$$arch/$$lang; \
            $(install_file) $$lang/release-notes.$$lang.html/* $(PUBLISHDIR)/$$arch/release-notes/; \
            $(install_file) $$lang/release-notes.$$lang.txt $(PUBLISHDIR)/$$arch/; \
            $(install_file) $$lang/release-notes.$$lang.pdf $(PUBLISHDIR)/$$arch/; \
            $(install_file) $$lang/release-notes.$$lang.ps $(PUBLISHDIR)/$$arch/; \
            $(install_file) $$lang/release-notes.$$lang.html/* release-notes-$$arch/$$lang; \
            $(install_file) $$lang/release-notes.$$lang.txt release-notes-$$arch/$$lang; \
            $(install_file) $$lang/release-notes.$$lang.pdf release-notes-$$arch/$$lang; \
	  done; \
          for i in $(PUBLISHDIR)/$$arch/release-notes/*.en.html; do \
            ln -sf `basename $$i` $${i%.en.html}.html; \
          done; \
	  if [ -n "$(PUBLISHTARBALL)" ]; then (cd release-notes-$$arch && tar czf $(PUBLISHDIR)/release-notes-$$arch.tar.gz *); fi \
	done
else
	set -e; \
	for arch in $(arches); do \
	  $(MAKE) architecture=$$arch; \
	  $(makedir) upgrade-$$arch; \
	  for lang in $(LANGUAGES); do \
	    $(install_file) $$lang/release-notes.$$lang.html/* upgrade-$$arch; \
	    $(install_file) $$lang/release-notes.$$lang.txt upgrade-$$arch; \
	    $(install_file) $$lang/release-notes.$$lang.pdf upgrade-$$arch; \
	    $(install_file) $$lang/release-notes.$$lang.ps upgrade-$$arch; \
	  done; \
	  ln -sf index.en.html upgrade-$$arch/index.html; \
	  ln -sf release-notes.en.txt upgrade-$$arch/Release-Notes; \
	done
	# Jens: where are ps and pdf versions?
# XXX needs to be updated for each release that introduces new architectures!
#	for newarch in mips mipsel ia64 hppa s390; do \
#          mv upgrade-$$newarch disks-$$newarch; \
#        done
	tar cjf relnotes.tar.bz2 upgrade-*
	rm -rf upgrade-* disks-*
endif

clean::
	rm -f dynamic*.ent relnotes.tar.bz2
	find -maxdepth 1 -name 'release-notes-*' -type d -exec rm -fr {} \;
clean:: $(LANGUAGES-clean)

$(LANGUAGES-clean):
	$(MAKE) -C $(subst -clean,,$@) clean
