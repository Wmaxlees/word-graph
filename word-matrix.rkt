#lang racket

(require "index-map.rkt"
         "type.rkt")

(provide
 (contract-out
  (increment-relation
   (word-matrix? index-map? string? string? . -> . any))
  (load-word-matrix-from-file
   (string? . -> . word-matrix?))
  (save-word-matrix-to-file
   (word-count? string? . -> . any))
  (save-matrix-as-gexf
   (word-matrix? index-map? string? . -> . any))))

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

  (matrix-increment index-m index-n word-matrix)
  (matrix-increment index-n index-m word-matrix))

; matrix-increment -> any
;    i: number?
;    j: number?
;    word-matrix: word-matrix?
;
;    Increments a single (i,j) index in the matrix
(define (matrix-increment i j word-matrix)
  (vector-set! word-matrix i (cons (car (vector-ref word-matrix i)) (dict-set (cdr (vector-ref word-matrix i)) j
                                                                              (+ 1 (dict-ref (cdr (vector-ref word-matrix i)) j 0))))))
; load-word-matrix-from-file -> word-matrix?
;    filename: string?
;
;    Loads a word-matrix from a file
(define (load-word-matrix-from-file filename)
  (define file (open-input-file filename))
  (define wm (read file))
  (close-input-port file)

  wm)

; save-word-matrix-to-file -> any
;    word-matrix: word-matrix?
;    filename: string?
;
;    Saves the word-matrix to the given file
(define (save-word-matrix-to-file word-matrix filename)
  (define file (open-output-file filename))
  (write word-matrix file)
  (close-output-port file))

; save-matrix-as-gexf -> any
;    word-matrix: word-matrix?
;    index-map: index-map?
;    filename: string?
;
;    Saves the matrix to a gexf format file
;    with the given filename
(define (save-matrix-as-gexf word-matrix index-map filename)
  (define file (open-output-file filename))

  (fprintf file "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
          <gexf xmlns=\"http://www.gexf.net/1.2draft\" version=\"1.2\">
          <meta lastmodifieddate=\"2009-03-\">
              <creator>word-graph</creator>
              <description>A word graph</description>
          </meta>
          <graph mode=\"static\" defaultedgetype=\"undirected\">
              <nodes>~n")

  (for ([i (hash->list index-map)])
    (fprintf file "<node id=\"~a\" label=\"~a\" />~n" (cdr i) (car i)))

  
  (fprintf file "</nodes>~n<edges>~n")

  (define accum 0)
  (for ([i word-matrix])
    (define first (hash-ref index-map (car i)))
    (for ([j (dict->list (cdr i))])
      (fprintf file "<edge id=\"~a\" source=\"~a\" target=\"~a\" />~n"
               accum first (car j))
      (set! accum (+ accum 1))))

  (fprintf file "</edges>~n</graph>~n</gexf>")

  (close-output-port file))