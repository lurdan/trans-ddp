# Top-level makefile for the Debian Documentation Project manuals

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
		debiandoc-startup 	\
		sgmltools-startup 	\
		programmer

# dead (unmaintained) documentation, suitable for reaping
DEADDIRS :=	\
		menu 			\
		markup 			\
		users_manual 

all:
	for dir in $(SUBDIRS); do	\
	  make -C $$dir			;\
	done

clean:
	for dir in $(SUBDIRS); do	\
	  make -C $$dir clean		;\
	done
