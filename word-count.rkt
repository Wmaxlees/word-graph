#lang racket

(require "type.rkt"
         (planet dyoo/python-tokenizer))

(provide
 (contract-out
  (make-word-count
   (-> word-count?))
  (count-file-list
   (word-count? (listof path?) . -> . any))
  (count-occurrences
   (word-count? string? . -> . any))
  (word-count->empty-word-matrix
   (word-count? . -> . word-matrix?))
  (save-count-to-file
   (word-count? string? . -> . any))
  (load-count-from-file
   (string? . -> . word-count?))))

; make-word-count -> word-count?
;
;    Creates a new word-count object
(define (make-word-count)
  (make-hash))

; count-occurrences -> any
;    word-count: word-count?
;    str: string?
;
;    Increments word-count based on the occurances of
;    words in the string
(define (count-occurrences word-count str)
  (for ([i (string-split str)])
    (increment-word word-count (strip-special-characters (string-downcase i)))))


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

; strip-special-characters -> string?
;    str: string?
;
;    Strips any special characters from the input
;    string and returns the new string
;    (currently strips .)
(define (strip-special-characters str)
  (string-replace str #rx"\\." ""))

; count-file-list -> any
;    word-count: word-count?
;    file-list: (listof path?)
;
;    Counts the occurrences of words in a given
;    list of files
(define (count-file-list word-count file-list)
  (for ([filename file-list])
    (printf "Counting word occurence in: ~s~n" (path->string filename))
    (count-occurrences-file word-count filename)))

; count-occurences-file -> any
;    word-count: word-count?
;    filename: path?
;
;    Counts the occurrence of words in a given file
(define (count-occurrences-file word-count filename)
  (define file (open-input-file filename))
  (for ([t (generate-tokens file)])
    (cond [(eq? (first t) 'NAME)
           (increment-word word-count (string-downcase (second t)))]))

  (close-input-port file))

; load-count-from-file -> word-count?
;    filename: string?
;
;    Loads the contents of a file as the
;    word-count
(define (load-count-from-file filename)
  (define file (open-input-file filename))
  (define temp (read file))
  (close-input-port file)

  temp)

; save-count-to-file -> any
;    word-count: word-count?
;    filename: string?
;
;    Saves the contents of a word-count in the
;    given filename
(define (save-count-to-file word-count filename)
  (define file (open-output-file filename))
  (write word-count file)
  (close-output-port file))