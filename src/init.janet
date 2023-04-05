#!/usr/bin/env janet

(use judge)
(use ./walkies)
(use ./util)

(defn short-fn-body [form]
  (and (ptuple? form)
       (= (length form) 2)
       (= (form 0) 'short-fn)
       (form 1)))

(def pipe (symbol "|"))

(defn unpipe [form]
  (catwalk (fn [spliceable form]
    (if spliceable
      (if-let [body (short-fn-body form)]
        [pipe (unpipe body)]
        [(unpipe form)])))
  form))

# because the symbol | cannot be parsed...
# maybe judge should special-case this
(defn vunpipe [form]
  (postwalk |(if (= $ pipe) "|" $)
    (unpipe form)))

(test (vunpipe '[1 | foo 3]) [1 "|" foo 3])
(test (vunpipe '[1 [2 | foo] 3]) [1 [2 "|" foo] 3])
(test (vunpipe '[1 [2 | [3 | 4 | 5]] 6]) [1 [2 "|" [3 "|" 4 "|" 5]] 6])

(defn ensequence [children]
  (case (length children)
    1 (in children 0)
    ['sequence ;children]))

(defn pipe-choice [form]
  (def choices (split form pipe))
  (case (length choices)
    0 ['sequence]
    1 (ensequence (in choices 0))
    ['choice ;(map ensequence choices)]))

(test (pipe-choice [1 2]) [sequence 1 2])
(test (pipe-choice [[[1]]]) [[1]])
(test (pipe-choice [1 pipe 2]) [choice 1 2])
(test (pipe-choice [1 pipe 2 pipe 3]) [choice 1 2 3])

(defn split-squares [form]
  (if (btuple? form)
    (pipe-choice form)
    form))

(defmacro peg [& form]
  (postwalk split-squares
    ['quasiquote (tuple/brackets ;(unpipe form))]))

(test-macro (peg 1)
  (quasiquote 1))

(test-macro (peg 1 2)
  (quasiquote (sequence 1 2)))

(test-macro (peg 1 | 2)
  (quasiquote (choice 1 2)))

(test-macro (peg 1 2 | 3)
  (quasiquote (choice (sequence 1 2) 3)))

(test-macro (peg 1 2 | 3 | 4 5)
  (quasiquote (choice (sequence 1 2) 3 (sequence 4 5))))

(test-macro (peg 1 | [2 3])
  (quasiquote (choice 1 (sequence 2 3))))

(test-macro (peg 1 | [2 | 3])
  (quasiquote (choice 1 (choice 2 3))))

(test-macro (peg [1 [2 3] 4])
  (quasiquote (sequence 1 (sequence 2 3) 4)))

(test-macro (peg [1 | [2 3] 4])
  (quasiquote (choice 1 (sequence (sequence 2 3) 4))))

(test-macro (peg [1 | (some 2) 3])
  (quasiquote (choice 1 (sequence (some 2) 3))))

(test-macro (peg 1 | (some 2) 3)
  (quasiquote (choice 1 (sequence (some 2) 3))))

(test-macro (peg 1 | [(some 2) | (some 3)] 4)
  (quasiquote (choice 1 (sequence (choice (some 2) (some 3)) 4))))
