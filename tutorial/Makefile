

all : debian-tutorial.tar.gz debian-tutorial.text.gz debian-tutorial.dvips.gz

outputs : debian-tutorial.dvips debian-tutorial.text debian-tutorial.html

debian-tutorial.dvips : debian-tutorial.sgml
	debiandoc2dvips debian-tutorial.sgml

debian-tutorial.text : debian-tutorial.sgml
	debiandoc2text debian-tutorial.sgml

debian-tutorial.html : debian-tutorial.sgml
	debiandoc2html debian-tutorial.sgml

debian-tutorial.tar : ChangeLog outputs COPYING
	chmod 644 debian-tutorial.text debian-tutorial.dvips ChangeLog
	chmod 755 debian-tutorial.html
	chmod 644 debian-tutorial.html/*
	tar --create --file=debian-tutorial.tar debian-tutorial.dvips debian-tutorial.text debian-tutorial.html debian-tutorial.sgml ChangeLog COPYING
	chmod 644 debian-tutorial.tar

debian-tutorial.tar.gz : debian-tutorial.tar
	gzip --force debian-tutorial.tar	

debian-tutorial.dvips.gz : debian-tutorial.dvips
	cp -f debian-tutorial.dvips debian-tutorial.dvips.tmp
	gzip --force debian-tutorial.dvips.tmp
	mv debian-tutorial.dvips.tmp.gz debian-tutorial.dvips.gz	
	chmod 644 debian-tutorial.dvips.gz

debian-tutorial.text.gz : debian-tutorial.text
	cp -f debian-tutorial.text debian-tutorial.text.tmp
	gzip --force debian-tutorial.text.tmp
	mv debian-tutorial.text.tmp.gz debian-tutorial.text.gz	
	chmod 644 debian-tutorial.text.gz	

clean : 
	/bin/rm -r debian-tutorial.html
	/bin/rm debian-tutorial.text
	/bin/rm debian-tutorial.dvips
	/bin/rm debian-tutorial.text.gz
	/bin/rm debian-tutorial.dvips.gz





