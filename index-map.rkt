#lang racket

(require "type.rkt")

(provide
 (contract-out
  (generate-index-map
   (word-matrix? . -> . index-map?))
  (get-index
   (index-map? string? . -> . number?))
  (save-index-map-to-file
   (index-map? string? . -> . any))
  (load-index-map-from-file
   (string? . -> . index-map?))))

; generate-index-map -> index-map?
;    word-matrix: word-matrix?
;
;    Creates an index-map from the given word-matrix
(define (generate-index-map word-matrix)
  (define result (make-hash))

  (for ([word word-matrix]
        [i (in-naturals)])
    (hash-set! result (car word) i))

  result)

; get-index -> number?
;    index-map: index-map?
;    word: string?
;
;    Returns the index of the given word
(define (get-index index-map word)
  (hash-ref index-map word))

; save-index-map-to-file -> any
;    index-map: index-map?
;    filename: string?
;
;    Save the index-map to the specified file
(define (save-index-map-to-file index-map filename)
  (define file (open-output-file filename))
  (write index-map file)
  (close-output-port file))

; load-index-map-from-file -> index-map?
;    filename: string?
;
;    Loads an index-map from the specified file
(define (load-index-map-from-file filename)
  (define file (open-input-file filename))
  (define im (read file))
  (close-input-port file)

  im)