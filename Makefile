# Top-level makefile for the Debian Documentation Project manuals

SUBDIRS	:= book-suggestions 		\
	   debian-bugs	 		\
	   debiandoc-startup 		\
	   developers-reference		\
	   dictionary 			\
	   markup 			\
	   menu 			\
	   meta 			\
	   network-administrator 	\
	   programmer 			\
	   project-history 		\
	   sgmltools-startup 		\
	   system-administrator 	\
	   user 			\
	   users_manual 

all:
	for dir in $(SUBDIRS); do	\
	  make -C $$dir			;\
	done

clean:
	for dir in $(SUBDIRS); do	\
	  make -C $$dir clean		;\
	done
