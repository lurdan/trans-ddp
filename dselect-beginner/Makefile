#
# Makefile for the dselect beginners guide, top-level
#

export PATH:=../quick-reference/bin/:${PATH}

LANGUAGES := ca cs da de en es fr hr it ja pl pt ru sk

LANGUAGES-publish := $(addsuffix -publish,$(LANGUAGES))
LANGUAGES-clean := $(addsuffix -clean,$(LANGUAGES))

.SUFFIXES: 
.PHONY: publish all clean $(LANGUAGES) $(LANGUAGES-publish)

all: $(LANGUAGES)

publish: $(LANGUAGES-publish)
clean: $(LANGUAGES-clean)

$(LANGUAGES-publish):
	$(MAKE) -C $(subst -publish,,$@) publish

$(LANGUAGES-clean):
	$(MAKE) -C $(subst -clean,,$@) clean

$(LANGUAGES):
	$(MAKE) -C $@
