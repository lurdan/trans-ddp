# The hands on itself if GPL.
# T checked stylesheet is GPL too.

all: english

# the "-s newbiedoc-onehtml.dsl" can be omitted.
# (in that case, just check that the final html urls for
# the images and callouts match).
# On my system, 'ln -sf /usr usr' was needed as a workaround
# for a missing "/" (somewhere in sgmltools I think)

usr:
	-if [ -h usr ] ; then rm -f usr ; fi
	ln -sf /usr usr

# Currently, SGML.
english: usr
#	DDP usually aim at multi-file HTML for fast loading
#	sgmltools -b onehtml -s newbiedoc-onehtml.dsl  hands-on.sgml 
	sgmltools -b html -s multihtml.dsl  hands-on.sgml 
	sgmltools -b txt  -s newbiedoc-onehtml.dsl hands-on.sgml

#	this result in without TOC
#	sgmltools -b ps   hands-on.sgml
#	sgmltools -b dvi  hands-on.sgml

#	this does not work
#	sgmltools -b ps   -s newbiedoc-onehtml.dsl hands-on.sgml
#	sgmltools -b pdf  -s newbiedoc-onehtml.dsl hands-on.sgml

clean:
	-rm hands-on.ps hands-on.dvi hands-on.txt hands-on.html hands-on.pdf
	-rm hands-on/* usr
	-rmdir hands-on

publish:
	# need this to puvblish on DDP web page
