#lang racket

(require "word-matrix.rkt"
         "index-map.rkt"
         "word-count.rkt"
         "type.rkt")

(provide
 (contract-out
  (cull-below-threshold
   (word-matrix? index-map? word-count? number? . -> . any))))

;
(define (cull-below-threshold word-matrix index-map word-count ε)
  (define culled 0)
  (for ([(word index) index-map])
    (define count (hash-ref word-count word))
    (dict-for-each (cdr (vector-ref word-matrix index))
                   (λ (k v)
                     (define test (> ε (exact->inexact (/ v (max count (hash-ref word-count (car (vector-ref word-matrix k))))))))
                     (when test
                       (set! culled (+ 1 culled)))
                     (word-matrix-set index k word-matrix (if test
                                                              0
                                                              (/ 1 (dict-count (cdr (vector-ref word-matrix index)))))))))

  (printf "Culled ~a edges.~n" culled))
