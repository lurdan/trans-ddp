<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY docbook.dsl PUBLIC "-//Norman Walsh//DOCUMENT DocBook Print Stylesheet//EN" CDATA dsssl>
]>
<style-sheet>

<style-specification id="print" use="docbook">
<style-specification-body> 

(define %generate-article-toc% 
  ;; Should a Table of Contents be produced for Articles?
  #t)
;;(define %generate-article-titlepage% 
  ;; Should an article title page be produced?
;;  #t)
(define %body-font-family% 
  ;; The font family used in body text
  "Palatino")
(define %title-font-family% 
  ;; The font family used in titles
  "Palatino")
(define %paper-type%
  ;; Name of paper type
  "A4")
(define %left-margin%
  ;; Width of left margin
  1.5cm)
(define %body-start-indent%
  0.5cm)
(define %bottom-margin% 
  ;; Height of bottom margin
  (if (equal? %visual-acuity% "large-type")
      3cm 
      2cm))
(define bop-footnotes
  ;; Make "bottom-of-page" footnotes?
  #t)

(define %section-autolabel% 
  ;; Are sections enumerated?
  #t)
;; Returns the depth of auto TOC that should be made at the nd-level
;(define (toc-depth nd)
;  (if (string=? (gi nd) (normalize "book"))
;      3
;      (if (string=? (gi nd) (normalize "article"))
;          3
;          1)))

(define %show-comments%
  ;; Display Comment elements?
  #f)
(define %hyphenation%
  ;; Allow automatic hyphenation?
  #t)

(define (article-titlepage-recto-elements)
  (list (normalize "title")
        (normalize "subtitle")
        (normalize "authorgroup")
        (normalize "author")
        ;;(normalize "othercredit")
        (normalize "releaseinfo")
        (normalize "copyright")
        (normalize "pubdate")
        (normalize "revhistory")
        (normalize "legalnotice")
        (normalize "abstract")))

(element debianpackage
  (let (
	(debianname (attribute-string "name"))
	(server (attribute-string "refserver"))
	)
    (make sequence
      (process-children) ;; Let the contents be formated in the standard way
      (make sequence 
	use: default-text-style
	(if debianname
	    ;; TODO: it would be better to test if (equal? debianname (contents))
	    (literal 
	     (string-append " (Debian package "
			    debianname
			    ")"
			    ))
	    ;; Else nothing
	    (empty-sosofo)
	    )
	(if server 
	    (literal 
	     (string-append " (reference server "
			    server
			    ")"
			    ))
	    (literal " (No Web server)")
	    )))))

(element debiandoc
    (let (
	(file (attribute-string "file"))
	(text (attribute-string "text"))
	)
      (if file
	  (make sequence
		  (literal (string-append
			    (if text
				text
				"Debian documentation")
			    " (/usr/doc/"
			    (data (current-node))
			    "/"
			    file
			    ")"
			    )))
	  (make sequence
		  (literal (string-append
			    "Debian documentation (/usr/doc/"
			    (data (current-node))
			    ")"
			    )))
	  )))


</style-specification-body>
</style-specification>

<external-specification id="docbook" document="docbook.dsl">

</style-sheet>



