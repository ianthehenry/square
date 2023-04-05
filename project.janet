(declare-project
  :name "square"
  :description "square peg, round hole"
  :dependencies [
     {:url "https://github.com/ianthehenry/judge.git"
      :tag "v2.3.1"}
  ])

(declare-source
  :prefix "square"
  :source [
    "src/init.janet"
    "src/util.janet"
    "src/walkies.janet"
  ])
