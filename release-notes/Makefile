#
# Makefile for the release notes, top-level
#

arches := $(shell grep '\[ <!entity arch-title' release-notes.ent | awk '{print $$2}' | sed s/%//)

export PATH:=../quick-reference/bin/:${PATH}

ifeq "$(OFFICIALWEBBUILD)" "true"
  install_file 	:= install -m 2664 -p
  makedir	:= mkdir -p -m 2775
else
  install_file	:= install -m 644 -p
  makedir	:= mkdir -p -m 0755
endif

LANGUAGES := en fr nl pt cs it da de ja fi sk es

LANGUAGES-publish := $(addsuffix -publish,$(LANGUAGES))
LANGUAGES-clean := $(addsuffix -clean,$(LANGUAGES))

.SUFFIXES: 
.PHONY: publish all clean $(LANGUAGES) $(LANGUAGES-publish)

all: $(LANGUAGES)

$(LANGUAGES):
	$(MAKE) -C $@

publish: clean
ifneq "$(PUBLISHDIR)" ""
	set -ex; \
	for arch in $(arches); do \
	  $(MAKE) architecture=$$arch; \
	  $(makedir) $(PUBLISHDIR)/$$arch/release-notes; \
	  for lang in $(LANGUAGES); do \
            $(install_file) $$lang/release-notes.$$lang.html/* $(PUBLISHDIR)/$$arch/release-notes/; \
            $(install_file) $$lang/release-notes.$$lang.txt $(PUBLISHDIR)/$$arch/; \
            $(install_file) $$lang/release-notes.$$lang.pdf $(PUBLISHDIR)/$$arch/; \
            $(install_file) $$lang/release-notes.$$lang.ps $(PUBLISHDIR)/$$arch/; \
	  done; \
          for i in $(PUBLISHDIR)/$$arch/release-notes/*.en.html; do \
            ln -sf $$i $${i%.en.html}.html; \
          done; \
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
clean:: $(LANGUAGES-clean)

$(LANGUAGES-clean):
	$(MAKE) -C $(subst -clean,,$@) clean
