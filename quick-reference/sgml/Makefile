#
# New Makefile Template (Osamu Aoki)
#
#  Build html(multi/single file) and single file txt formats.
#
# ------------------------------------------------------------------- #
#                          WARNING                                    #
#         Use with caution, aimed at Lenny system                     #
# ------------------------------------------------------------------- #

.SUFFIXES:
# =================================================================== #
#                 Default configuration part: Customize               #
# =================================================================== #

# The directory in which this makefile resides must also contain a file
# called <directoryname>.[<language>.]sgml, which is the top-level file
# for the manual in this directory.

# Basename for language-independent XML/SGML tar-ball name.
#MANUAL := $(notdir $(CURDIR))
MANUAL		:= debian-reference
MANUAL0		:= dr1
LANG_ALL	:= fr it es de pt-br pl zh-tw zh-cn
HTML_ROOT	:= ../html
HTML_PAGES 	:= ap-appendix ch-edit ch-gateway ch-gnupg ch-install \
		ch-kernel ch-package ch-preface ch-program ch-support \
		ch-system ch-tips ch-tune ch-tutorial ch-vcs ch-woody \
		footnotes


# =================================================================== #
#                 Build rule part: SGML source                        #
# =================================================================== #
# SGML source files inherited from debian-reference (v1)
# (Already converted to UTF-8)
ENTS	:= $(MANUAL0).ent
SRCS	:= $(foreach lang, $(LANG_ALL), $(MANUAL).$(lang).sgml) \
	     $(foreach lang, $(LANG_ALL), $(wildcard $(lang)/*.sgml)) \
	     $(ENTS)

SRCX	:= $(foreach lang, $(LANG_ALL), $(MANUAL).$(lang).sgml)
# List of html stamp files to be built
HTML	:= $(foreach lang,$(LANG_ALL),$(HTML_ROOT)/index.$(lang).html) \
	$(foreach page,$(HTML_PAGES),$(foreach lang,$(LANG_ALL),$(HTML_ROOT)/$(page).$(lang).html)) \
	$(foreach lang,$(LANG_ALL),$(HTML_ROOT)/$(MANUAL).$(lang).html)
# List of txt to be built
TXT	:= $(foreach lang,$(LANG_ALL),$(HTML_ROOT)/$(MANUAL).$(lang).txt)
# All target
TARGETS	:= $(HTML) $(TXT)
# Blacklist for failing build
BLACKLIST	:=
#BLACKLIST	:= $(MANUAL).ja.pdf

.PHONY:	all
all:    $(filter-out $(BLACKLIST), $(TARGETS))

# Build rule for debian-reference.??.sgml
$(MANUAL).%.sgml: $(MANUAL0).sgml
	sed -e "s/@@LANGS@@/$*/g" \
	    -e "s/@@DIRS@@/$*/g" \
	    -e "s/@@NAME@@/$(MANUAL)/g" \
	        $< > $(MANUAL).$*.sgml

#  Build rule for HTML (non-English)
$(HTML_ROOT)/index.%.html: $(MANUAL).%.sgml $(SRCS)
	debiandoc2html $(BUILD_OPT) -l $*.utf-8 -C $<
	mkdir -p $(HTML_ROOT)
	cp $(MANUAL).$*.html/* $(HTML_ROOT)/
	rm -rf $(MANUAL).$*.html
$(HTML_ROOT)/$(MANUAL).%.html: $(MANUAL).%.sgml $(SRCS)
	debiandoc2html $(BUILD_OPT) -1 -b $(MANUAL)-1.$* -l $*.utf-8 -C $<
	mkdir -p $(HTML_ROOT)
	mv -f $(MANUAL)-1.$*.html/index.$*.html $(HTML_ROOT)/$(MANUAL).$*.html
	rm -rf $(MANUAL)-1.$*.html

#  Build rule for TXT (non-English)
#  (UTF-8 compatibility of debiandoc2text is limitted) 
$(HTML_ROOT)/$(MANUAL).%.txt: $(HTML_ROOT)/$(MANUAL).%.html
	LC_ALL=en_US.UTF-8 w3m -dump -cols 65 -T text/html $(HTML_ROOT)/$(MANUAL).$*.html >$@

#====[ validating SGML ]=======================================================
validate:
	set -x; for i in $(LANG_SGML); do $(MAKE) validate-$$i ; done

validate1-%: $(SRCS_SGML) $(MANUAL).%.ent 
	nsgmls -gues -wall $(MANUAL).$*.sgml

#====[ check all URLs ]========================================================
check-urls:
	for i in $(LANG_SGML); do $(MAKE) check-urls-$$i ; done

define CHECK_URLS # one argument $1: reference or quick-reference
# Bug: Woody's wget hangs during http://localhost:631 check 
	for file in $(1).$*.html/*.html; do \
	  sed 's|http://localhost:631/|Ignore this wrong URL/|g' $$file | \
	  wget --spider --non-verbose --force-html \
	       --base=$(1).$*.html/ -i - 2>&1 | \
          grep -v '^200 OK$$' | grep -v '^ *$$'; \
	done || true
endef

check-urls-%: $(MANUAL).%.html.stamp
	$(call CHECK_URLS,$(MANUAL))

#############################################################################
### Clean source tree                                                     ###
#############################################################################
#### Clean SGML build environment 
.PHONY: clean
clean:
	-rm  -f $(SRCX)
	-rm -f `find . -name "*~" -o -name "*.bak" -o -name "*.rej" -o -name "*.orig" -o -name ".#*"`
	-rm -f core
.PHONY: distclean purgeclean
distclean: clean
	-rm  -f $(TARGETS)
	-rm  -rf $(HTML_ROOT)

