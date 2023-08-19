(declare-project
  :name "square"
  :description "square peg, round hole"
  :dependencies
    ["https://github.com/ianthehenry/judge.git"])

(declare-source
  :prefix "square"
  :source [
    "src/init.janet"
    "src/util.janet"
    "src/walkies.janet"
  ])
