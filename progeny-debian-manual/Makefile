#
# Makefile for the Progeny Debian Manual
#
#====[ customization ]=========================================================
##### CONF PART 

# What is the current manual's name
MANUAL := $(notdir $(shell pwd))

# publish directory (default for all DDP)
# this can and will be overriden by a higher level makefile
PUBLISHDIR := ../../../public_html/manuals.html

##### END OF CONF PART
#====[ publishing to the DDP web pages ]=======================================
publish: publish-html

#----[ publish html ]----------------------------------------------------------
publish-html: $(HTMLDIRS)
	# install for all language (html)
	@test -d $(PUBLISHDIR)/$(MANUAL) \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)
	rm -rf $(PUBLISHDIR)/$(MANUAL)/*
	install -p -m 644 *.html $(PUBLISHDIR)/$(MANUAL)/
	cd $(PUBLISHDIR)/$(MANUAL) ;mkdir img
	install -p -m 644 img/*.png $(PUBLISHDIR)/$(MANUAL)/img/ 
# 	install examples.  Excuse me for ugly script (skip CVS directory)
	@test -d $(PUBLISHDIR)/$(MANUAL)/img \
	   || install -d -m 755 $(PUBLISHDIR)/$(MANUAL)/img
	@install -p -m 644  --preserve-timestamps \
	 img/[_A-BD-Za-z0-9].* $(PUBLISHDIR)/$(MANUAL)/img/

#====[ cleaning up ]===========================================================
clean distclean: 
	rm -rf $(PUBLISHDIR)/$(MANUAL)/

.PHONY: all publish publish-html clean distclean 
