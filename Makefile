# Top-level makefile for the Debian Documentation Project manuals

# parallel compiling is not possible, a lot of Makefiles do not support it
MAKEFLAGS=j1

# live documentation
SUBDIRS	:=	\
		apt-howto		\
		book-suggestions 	\
		ddp-policy		\
		debian-bugs	 	\
		dictionary 		\
		distribute-deb		\
		dselect-beginner 	\
		euro-support		\
		fr			\
		intro-i18n		\
		java-faq		\
		maint-guide		\
		meta 			\
		network-administrator 	\
		programmer		\
		quick-reference		\
		repository-howto	\
		securing-howto		\
		system-administrator 	\
		tutorial		\
		user			\
		users-guide		\

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
PUBLISHDIR := /srv/www.debian.org/www/doc/manuals
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
	-COLUMNS=1000 /usr/bin/time -f "%C took %E real, %U user, %S sys time" \
	  $(MAKE) -C $@

$(SUBDIRS-publish):
	-COLUMNS=1000 /usr/bin/time -f "%C took %E real, %U user, %S sys time" \
	  $(MAKE) -C $(subst -publish,,$@) publish $(publish_args)

$(SUBDIRS-clean):
	-/usr/bin/time -f "%C took %E real, %U user, %S sys time" \
	  $(MAKE) -C $(subst -clean,,$@) clean
