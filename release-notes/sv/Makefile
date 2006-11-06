#
# Makefile for the release notes, language subdirectory
#
include $(CURDIR)/../Makefile.common

# Swedish is not supported in Sarge's debiandoc-sgml. English is that's why
# used and the suffix en-us.iso-8859-1 is (bogusly?) used for HTML files.
# Lets rename it to sv.html and change internal links.
$(manual).$(currentlang).html/index.$(currentlangcn).html: $(sources)
	debiandoc2html -c -l $(currentlang) $<
	for file in $(manual).$(currentlang).html/*.en-us.iso-8859-1.html; do \
          sed 's/en-us.iso-8859-1/$(currentlangcn)/g' $$file > $${file%.en-us.iso-8859-1.html}.$(currentlangcn).html; \
	  rm $$file; \
	done

