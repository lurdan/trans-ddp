# Top-level makefile for the Debian Documentation Project manuals

# live documentation
SUBDIRS	:=	\
		apt-howto		\
		book-suggestions 	\
		debian-bugs	 	\
		developers-reference	\
		dictionary 		\
		euro-support		\
		faq			\
		fr			\
		intro-i18n		\
		java-faq		\
		meta 			\
		network-administrator 	\
		programmer		\
		project-history 	\
		quick-reference		\
		securing-howto		\
		system-administrator 	\
		user			\
		users-guide		\
		maint-guide		\
		ddp-policy

# documents with broken or newest Makefiles will be moved to the bottom


SUBDIRS-publish := $(addsuffix -publish,$(SUBDIRS))
SUBDIRS-clean := $(addsuffix -clean,$(SUBDIRS))

# dead (unmaintained) documentation, suitable for reaping
DEADDIRS :=	\
		debiandoc-startup 	\
		sgmltools-startup 	\
		menu 			\
		markup 			\
		users_manual		\
		progeny-debian-manual	\
# or just as archive without building them

# where we should publish to
PUBLISHDIR := /org/www.debian.org/www/doc/manuals
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
	time -p $(MAKE) -C $@
	uptime

$(SUBDIRS-publish):
	time -p $(MAKE) -C $(subst -publish,,$@) publish $(publish_args)
	uptime

$(SUBDIRS-clean):
	time -p $(MAKE) -C $(subst -clean,,$@) clean
	uptime
