

all : debian-tutorial.tar.gz

outputs : debian-tutorial.ps debian-tutorial.text debian-tutorial.html

debian-tutorial.ps : debian-tutorial.sgml
	debiandoc2ps debian-tutorial.sgml

debian-tutorial.text : debian-tutorial.sgml
	debiandoc2text debian-tutorial.sgml

debian-tutorial.html : debian-tutorial.sgml
	debiandoc2html debian-tutorial.sgml

debian-tutorial.tar : ChangeLog outputs COPYING
	chmod 644 debian-tutorial.text debian-tutorial.ps ChangeLog
	chmod 755 debian-tutorial.html
	chmod 644 debian-tutorial.html/*
	tar --create --file=debian-tutorial.tar debian-tutorial.ps debian-tutorial.text debian-tutorial.html debian-tutorial.sgml ChangeLog COPYING
	chmod 644 debian-tutorial.tar

debian-tutorial.tar.gz : debian-tutorial.tar
	gzip --force debian-tutorial.tar	

clean : 
	/bin/rm -r debian-tutorial.html
	/bin/rm debian-tutorial.text
	/bin/rm debian-tutorial.ps
	/bin/rm CHANGELOG




