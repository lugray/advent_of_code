(declare-sort CHOICE 0)
(declare-fun rock () CHOICE)
(declare-fun paper () CHOICE)
(declare-fun scissors () CHOICE)

(declare-sort RESULT 0)
(declare-fun loss () RESULT)
(declare-fun draw () RESULT)
(declare-fun win () RESULT)

(declare-fun A () CHOICE)
(declare-fun B () CHOICE)
(declare-fun C () CHOICE)
(assert (= A rock))
(assert (= B paper))
(assert (= C scissors))

(declare-fun X () RESULT)
(declare-fun Y () RESULT)
(declare-fun Z () RESULT)
(assert (= X loss))
(assert (= Y draw))
(assert (= Z win))

(declare-fun choice-score (CHOICE) Int)
(assert (= 1 (choice-score rock)))
(assert (= 2 (choice-score paper)))
(assert (= 3 (choice-score scissors)))

(declare-fun result-score (RESULT) Int)
(assert (= 0 (result-score loss)))
(assert (= 3 (result-score draw)))
(assert (= 6 (result-score win)))

(declare-fun beats (CHOICE) CHOICE)
(assert (= paper (beats rock)))
(assert (= scissors (beats paper)))
(assert (= rock (beats scissors)))

(declare-fun pick (CHOICE RESULT) CHOICE)
(assert (forall ((choice CHOICE))
  (and
    (= (pick choice win) (beats choice))
    (= (pick choice draw) choice)
    (= (pick (beats choice) loss) choice)
  )
))

(define-fun round-score ((opponent CHOICE) (result RESULT)) Int
  (+
    (result-score result)
    (choice-score (pick opponent result))
  )
)

(declare-const game-score Int)

(assert (= game-score (+
  %EXPRS%
)))

(check-sat)
(get-value (game-score))
