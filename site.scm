#!/usr/bin/env dfsch-run

(require :shtml)
(require :markdown)

(define *ga-code* "<script type=\"text/javascript\">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-26428838-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>")


(define (base-template title menu active body)
  `(:html
    (:head
     (:meta :charset "utf-8")
     (:title ,title)
     (:literal-output "<!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]-->")
     (:link :href "css/bootstrap.min.css" 
            :rel "Stylesheet")
     (:link :href "css/jumbotron.css" 
            :rel "Stylesheet")
     (:literal-output ,*ga-code*))
    (:body 
     (:div :class "topbar"
           (:div :class "fill"
                 (:div :class "container"
                       (:a :class "brand" 
                           :href "/" 
                           "dfsch")
                       (:ul :class "nav"
                            ,@(map (lambda (entry)
                                     (let ((uri (car entry))
                                           (text (cadr entry)))
                                       (if (equal? uri active)
                                           `(:li :class "active"
                                                 (:a :href ,uri
                                                     ,text))
                                           `(:li (:a :href ,uri
                                                     ,text)))))
                                   menu)))))
     ,@body)))

(define (content-template title menu active body)
  (base-template 
   title menu active
   `((:div :class "container"
           (:div :class "content main-content" :style "margin-top: 60px"
                 ,@body)
           (:footer (:p "Follow dfsch on "
                        (:a :href 
                            "https://plus.google.com/107786214061696621411"
                            "Google+")
                        " or "
                        (:a :href "http://facebook.com/dfsch"
                            "Facebook")
                        (:br)
                        "© "
                        (:a :href "http://hakl.net/"
                            "Aleš Hakl")
                        " 2005 - 2012, Website based on "
                        (:a :href "http://twitter.github.com/bootstrap/"
                            "Bootstrap from Twitter")))))))

(define *menu* '(("./features.html" "Features")
                 ("./download.html" "Downloads")
                 ("./documentation.html" "Documentation")
                 ("http://github.com/adh/dfsch" "Github")))

(define (read-fragment filename)
  (with-open-file f (filename "r")
                  `((:literal-output ,(port-read-whole f)))))

(define (read-markdown filename)
  (with-open-file f (filename "r")
                  `((:literal-output 
                     ,(markdown:markdown (port-read-whole filename))))))

(shtml:emit-file (base-template "dfsch - a pragmatic Scheme" *menu* "./"
                                (read-fragment "input/hero.html"))
                 "./index.html")

(shtml:emit-file (content-template "Home" *menu* "./" 
                                   '((:h1 "Foo"))) "./foo.html")
