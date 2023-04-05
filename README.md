# `square/peg`

Hey! This isn't really a thing you should use yet. This is just an experiment.

`square/peg` is a macro that provides an alternative notation for writing [PEGs](https://janet-lang.org/docs/peg.html) in [Janet](https://janet-lang.org).

It allows you to write `(sequence "a" "b")` as `["a" "b"]`, and `(choice "a" "b")` as `["a" | "b"]`.

`square/peg` can take multiple arguments, in which case they behave the same as if they were wrapped in square brackets. So the following two expressions are equivalent:

```
(square/peg [(? "a") "b"])
(square/peg (? "a") "b")
```

`square/peg` implicitly wraps its arguments in `quasiquote`, so you don't need to manually quote them. You can `unquote` normally.

```janet
(import square)

(peg/match
  (square/peg (some [(set "aeiou") (constant :vowel) | 1 (constant :consonant)]))
  "hello")
#= @[:consonant :vowel :consonant :consonant :vowel]
```
