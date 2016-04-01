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
                                                              1)))))

  (printf "Culled ~a edges.~n" culled))
  
    ;(for ([(j val) (cdr (vector-ref word-matrix index))]) (+ 0 val))))
      ;(word-matrix-set index j word-matrix (if (> ε (/ val count))
       ;                                        1
        ;                                       0)))))
