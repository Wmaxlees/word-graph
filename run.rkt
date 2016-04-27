#lang racket

(require "word-count.rkt"
         "index-map.rkt"
         "word-matrix.rkt"
         "operations.rkt")

(define wc (load-count-from-file "wc.save"))
(define wm (load-word-matrix-from-file "wm.save"))
(define im (load-index-map-from-file "im.save"))

(cull-below-threshold wm im wc 0.7)

(save-matrix-as-gexf wm im "cull-weight-70.gexf")

;(define wc (make-word-count))

;(define file-list
;  (directory-list (string->path "./sanitized") #:build? #t))

;(count-file-list wc file-list)

;(define wm (word-count->empty-word-matrix wc))
;(define im (generate-index-map wm))

;(for ([filename file-list])
;  (define file (open-input-file filename))
;  (printf "Counting word occurence in: ~s~n" (path->string filename))
;  (define paragraph '())
;  (for ([t (generate-tokens file)])
    ; Generate sentence list
;    (cond [(eq? (first t) 'NAME)
;           (set! paragraph (append paragraph (list (second t))))]
;          [(eq? (first t) 'NEWLINE)
;           (for ([i paragraph])
;             (for ([j paragraph])
;               (cond [(not (equal? j i))
;                      (increment-relation wm im (string-downcase i) (string-downcase j))])))
;           (set! paragraph '())]))

;  (close-input-port file))
