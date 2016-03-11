#lang racket

(require net/url
         json)

(let loop ()
  (define str
    (hash-ref
     (car (hash-ref
           (hash-ref (string->jsexpr
                      (port->string
                       (get-pure-port
                        (string->url
                         "https://en.wikipedia.org/w/api.php?action=query&format=json&list=random&rnlimit=1"))))
                     'query)
           'random))
     'title))

  (set! str (string-split str ":"))

  (cond [(and (not (equal? (car str) "User"))
              (not (equal? (car str) "Template"))
              (not (equal? (car str) "Talk"))
              (not (equal? (car str) "Category"))
              (not (equal? (car str) "User talk"))
              (not (equal? (car str) "File")))
         (cdr str)]
        [else
         (displayln str)
         (loop)]))