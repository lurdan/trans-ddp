# Top-level makefile for the Debian Documentation Project manuals

# live documentation
SUBDIRS	:=	\
		book-suggestions 	\
		debian-bugs	 	\
		developers-reference	\
		dictionary 		\
		maint-guide		\
		meta 			\
		network-administrator 	\
		project-history 	\
		system-administrator 	\
		securing-howto		\
		user			\
		programmer		\
		intro-i18n		\
		java-faq		\
		faq
SUBDIRS-publish := $(addsuffix -publish,$(SUBDIRS))
SUBDIRS-clean := $(addsuffix -clean,$(SUBDIRS))

# dead (unmaintained) documentation, suitable for reaping
DEADDIRS :=	\
		debiandoc-startup 	\
		sgmltools-startup 	\
		menu 			\
		markup 			\
		users_manual 

# where we should publish to
PUBLISHDIR :=	/org/www.debian.org/debian.org/doc/manuals
# How to install stuff in publish directory
install_file := install -p -m 664
install_dir := install -d -m 2775
# arguments to make publish
publish_args := PUBLISHDIR=$(PUBLISHDIR) install_file="$(install_file)" install_dir="$(install_dir)"

.SUFFIXES: 
.PHONY: all publish clean $(SUBDIRS) $(SUBDIRS-publish) $(SUBDIRS-clean)

all: $(SUBDIRS)

publish::
	[ -d $(PUBLISHDIR) ] || mkdir -p $(PUBLISHDIR)
publish:: $(SUBDIRS-publish)

clean: $(SUBDIRS-clean)

$(SUBDIRS):
	$(MAKE) -C $@

$(SUBDIRS-publish):
	$(MAKE) -C $(subst -publish,,$@) publish $(publish_args)

$(SUBDIRS-clean):
	$(MAKE) -C $(subst -clean,,$@) clean
