(use judge)

(defn type+ [x]
  (def t (type x))
  (case t
    :tuple (case (tuple/type x)
      :parens :ptuple
      :brackets :btuple
      (assert false))
    t))

(defn ptuple? [form]
  (= (type+ form) :ptuple))

(defn btuple? [form]
  (= (type+ form) :btuple))

(defn concat [x]
  (array/concat @[] ;x))

(test (concat [[1 2] [3 4]]) @[1 2 3 4])

(defn split [xs value]
  (var current @[])
  (def result @[current])
  (each x xs
    (if (= x value)
      (array/push result (set current @[]))
      (array/push current x)))
  result)

(test (split [] 0) @[@[]])
(test (split [0] 0) @[@[] @[]])
(test (split [1 0 2] 0) @[@[1] @[2]])
(test (split [1 0 0 2] 0) @[@[1] @[] @[2]])
(test (split [1 0] 0) @[@[1] @[]])
(test (split [0 1 0] 0) @[@[] @[1] @[]])
