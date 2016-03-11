#lang racket

(require "type.rkt")

(provide
 (contract-out
  (generate-index-map
   (-> word-matrix? index-map?))
  (get-index
   (-> index-map? string? boolean?))))

; generate-index-map -> index-map?
;    word-matrix: word-matrix?
;
;    Creates an index-map from the given word-matrix
(define (generate-index-map word-matrix)
  (define result (make-hash))

  (for ([word word-matrix]
        [i in-naturals])
    (hash-set! result word i)))

; get-index -> boolean?
;    index-map: index-map?
;    word: string?
;
;    Returns the index of the given word
(define (get-index index-map word)
  (hash-ref index-map word))