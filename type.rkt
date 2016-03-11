#lang racket

(provide
 (contract-out
  (index-map?
   (-> any/c boolean?))
  (word-matrix?
   (-> any/c boolean?))
  (word-count?
   (-> any/c boolean?))))

; word-count? -> boolean?
;    obj: any/c?
;
;    Checks whether an object is a word-count object
(define (word-count? obj)
  (hash? obj))

; index-map? -> boolean?
;    obj: any/c?
;
;    Test whether an object is an index-map
(define (index-map? obj)
  (hash? obj))

; word-matrix? -> boolean?
;    obj: any/c?
;
;    Test whether an object is a word-matrix
(define (word-matrix? obj)
  (vectorof (cons string? dict?)))