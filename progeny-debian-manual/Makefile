#
# Makefile for the Progeny Debian Manual
#
#  Do nothing but stay in CVS for record :)
#
#====[ customization ]=========================================================
##### CONF PART 

# What is the current manual's name
MANUAL := $(notdir $(shell pwd))

# publish directory (default for all DDP)
# this can and will be overriden by a higher level makefile
PUBLISHDIR := /org/www.debian.org/www/doc/manuals

##### END OF CONF PART
#====[ publishing to the DDP web pages ]=======================================
#publish: publish-html
publish:
	echo "Hey, policy say no to publish this in DDP :)"
#	rm -Rf $(PUBLISHDIR)/$(MANUAL)

# After running once, I will stop this.
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
	 img/[_A-BD-Za-z0-9]* $(PUBLISHDIR)/$(MANUAL)/img/

#====[ cleaning up ]===========================================================
clean distclean: 
	rm -rf $(PUBLISHDIR)/$(MANUAL)/

.PHONY: all publish publish-html clean distclean 
