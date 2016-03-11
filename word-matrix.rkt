#lang racket

(require "index-map.rkt")

; increment-relation -> any
;    word-matrix: word-matrix?
;    index-map: index-map?
;    m: string?
;    n: string?
;
;    Increments the adjacency matrix to match an additional
;    relationship between m and n in the word-matrix
(define (increment-relation word-matrix index-map m n)
  (define index-m (get-index index-map m))
  (define index-n (get-index index-map n))

  (matrix-increment m n word-matrix)
  (matrix-increment n m word-matrix))

; matrix-increment -> any
;    i: number?
;    j: number?
;    word-matrix: word-matrix?
;
;    Increments a single (i,j) index in the matrix
(define (matrix-increment i j word-matrix)
  (dict-set (cdr (vector-ref word-matrix i)) j
            (+ 1 (dict-ref (cdr (vector-ref word-matrix i)) j))))
  