# Top-level makefile for the Debian Documentation Project manuals

all:
	-make -C book-suggestions
	-make -C debian-bugs
	-make -C debiandoc-startup
	-make -C dictionary
	-make -C markup
	-make -C menu
	-make -C meta
	-make -C network-administrator
	-make -C programmer
	-make -C project-history
	-make -C sgmltools-startup
	-make -C system-administrator
	-make -C user
	-make -C users_manual

clean:
	-make -C book-suggestions clean
	-make -C debian-bugs clean
	-make -C debiandoc-startup clean
	-make -C dictionary clean
	-make -C markup clean
	-make -C menu clean
	-make -C meta clean
	-make -C network-administrator clean
	-make -C programmer clean
	-make -C project-history clean
	-make -C sgmltools-startup clean
	-make -C system-administrator clean
	-make -C user clean
	-make -C users_manual clean

