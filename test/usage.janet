(import ../src :as square)
(use judge)

(defmacro match-on [str & pat]
  ~(peg/match (square/peg ,;pat) ,str))

(test
  (match-on "hello"
    (some [(set "aeiou") (constant :vowel) | 1 (constant :consonant)]))
  @[:consonant :vowel :consonant :consonant :vowel])
