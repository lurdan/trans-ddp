<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook HTML Stylesheet//EN" CDATA dsssl>
]>
<style-sheet>

<style-specification id="html" use="docbook">
<style-specification-body> 

;; Default value only
(define FHS #f)

(define %html-ext% ".html")
(define %root-filename% "howto")
(define %generate-article-toc% #t)
(define %generate-article-titlepage% #t)
; (define %gentext-nav-use-tables%  #f)
(define %section-autolabel%
  ;; Are sections enumerated?
  #f)
(define biblio-number
  ;; Enumerate bibliography entries
  #t)
;;(define %generate-legalnotice-link%
  ;; Should legal notices be a link to a separate file?
;;  #t)
(define %body-attr% 
  ;; What attributes should be hung off of BODY?
  (list
   (list "BGCOLOR" "#FFFFFF")
   (list "TEXT" "#000000")))

(define dir-prefix 
  (if FHS
      ;; We'll stay with /usr:doc for the moment: all packages have at
      ;; least a compatibility link in /usr/doc but not all have /usr/share/doc
      ;;"file:/usr/share/doc/"
      "file:/usr/doc/"
      "file:/usr/doc/"))

(element debianpackage
  (let* (
	(debianname (attribute-string "name"))
	(name (if debianname
		  debianname
		  (data (current-node))))
	(server (attribute-string "refserver")))
    (make sequence
      (if server 
	  (make element gi: "A"
		attributes: `(("HREF" 
			       ,server))
		(process-children))
	  (process-children))
      (literal " ")
      (make element gi: "A"
	    attributes: `(("HREF" 
			   ,(string-append "http://packages.debian.org/"
					   name)))
	    (literal "(Debian package)"))
      )))

(element debiandoc
    (let (
	(file (attribute-string "file"))
	(text (attribute-string "text"))
	)
      (if file
	  (make sequence
	    (make element 
	      gi: "A"
	      attributes: `(("HREF" 
			     ,(string-append dir-prefix
					     (data (current-node))
					     "/"
					     file)))
	      (make element 
		(if text
		  (literal text)
		  (literal 
		   "Debian documentation")))
	      )
	    (literal (string-append 
		      " (the link will work only if you installed the package \""
		      (data (current-node))
		      "\")")))
	  (make sequence
	    (make element 
	      gi: "A"
	      attributes: `(("HREF" 
			     ,(string-append dir-prefix
					     (data (current-node))
					     "/"
						 )))
	      (make element 
		(if text
		    (literal text)
		    (literal 
		     "Debian documentation")))
	      )
	    (literal (string-append 
		      " (the link will work only if you installed the package \""
		      (data (current-node))
		      "\")")))
	  )))

(element application ($bold-seq$))

</style-specification-body>
</style-specification>

<external-specification id="docbook" document="docbook.dsl">

</style-sheet>




