#lang racket

; make-word-count -> word-count?
;
;    Creates a new word-count object
(define (make-word-count)
  (make-hash))

; increment-word -> any
;    word-count: word-count?
;    word: string?
;
;    Increments the count on the given word in the word
;    count dictionary
(define (increment-word word-count word)
  (hash-set! word-count word (+ 1 (hash-ref word-count word 0))))


; word-count->empty-word-matrix -> word-matrix?
;    word-count: word-count?
;
;    Converts a word-count? to a word-matrix?
(define (word-count->empty-word-matrix word-count)
  (define vec (list->vector
               (sort (hash->list word-count)
                     (λ (a b) (string<? (car a) (car b))))))

  (for ([i (in-range 0 (vector-length vec))])
    (vector-set! vec i (cons (car (vector-ref vec i)) '())))

  vec)