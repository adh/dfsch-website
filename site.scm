#!/usr/bin/env dfsch-run

(require :shtml)
(require :markdown)

(define (base-template title menu active)
  `(:html
    (:head
     (:meta :charset "utf-8")
     (:title ,title)
     (:literal-output "<!--[if lt IE 9]><script src=\"http://html5shim.googlecode.com/svn/trunk/html5.js\"></script><![endif]-->")
     (:link :href "css/bootstrap.min.css" 
            :rel "Stylesheet")
     (:link :href "css/jumbotron.css" 
            :rel "Stylesheet")
     (:literal-output "<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-26428838-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>"))
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