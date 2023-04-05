(defn- walk-ind [f form]
  (def ret @[])
  (each x form (array/concat ret (f true x)))
  ret)

(defn- walk-dict [f form]
  (def ret @{})
  (loop [k :keys form]
    (put ret (f false k) (f false (in form k))))
  ret)

# like walk, but f will take two values: the first
# is whether it is in a spliceable position. the
# second is the form
(defn catwalk [f form]
  (case (type form)
    :table (walk-dict f form)
    :struct (table/to-struct (walk-dict f form))
    :array (walk-ind f form)
    :tuple (let [x (walk-ind f form)]
             (if (= :parens (tuple/type form))
               (tuple/slice x)
               (tuple/brackets ;x)))
    form))
