# Top-level makefile for the Debian Documentation Project manuals

# where we should publish to
PUBLISHDIR :=	/org/www.debian.org/debian.org/doc/manuals

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

# How to install stuff in publish directory
install_file := install -p -m 664
install_dir := install -d -m 2775

.SUFFIXES: 
.PHONY: all publish clean $(SUBDIRS) $(SUBDIRS-publish) $(SUBDIRS-clean)

publish::
	[ -d $(PUBLISHDIR) ] || mkdir -p $(PUBLISHDIR)
publish:: $(SUBDIRS-publish)

all: $(SUBDIRS)

clean: $(SUBDIRS-clean)

$(SUBDIRS-publish):
	$(MAKE) -C $(subst -publish,,$@) publish

$(SUBDIRS):
	$(MAKE) -C $@

$(SUBDIRS-clean):
	$(MAKE) -C $(subst -clean,,$@) clean
