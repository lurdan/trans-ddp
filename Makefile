# Top-level makefile for the Debian Documentation Project manuals

# where we should publish to
PUBLISHDIR :=	$(shell pwd)/../../public_html/manuals.html

# live documentation
SUBDIRS	:=	\
		book-suggestions 	\
		debian-bugs	 	\
		developers-reference	\
		dictionary 		\
		meta 			\
		network-administrator 	\
		project-history 	\
		system-administrator 	\
		user			\
		programmer

# dead (unmaintained) documentation, suitable for reaping
DEADDIRS :=	\
		debiandoc-startup 	\
		sgmltools-startup 	\
		menu 			\
		markup 			\
		users_manual 

.PHONY: all
all:
	[ -d $(PUBLISHDIR) ] || exit 1
	for dir in $(SUBDIRS); do				\
	  $(MAKE) -C $$dir PUBLISHDIR=$(PUBLISHDIR) publish	;\
	done

.PHONY: clean
clean:
	for dir in $(SUBDIRS); do				\
	  $(MAKE) -C $$dir clean				;\
	done

# easy way to make a single subdirectory
.PHONY: $(SUBDIRS) $(DEADDIRS)
$(SUBDIRS) $(DEADDIRS):
	[ -d $(PUBLISHDIR) ] || exit 1
	$(MAKE) -C $@ PUBLISHDIR=$(PUBLISHDIR) publish

