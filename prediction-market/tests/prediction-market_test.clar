;; Test suite for prediction-market contract
(define-public (test-create-market)
  (let 
    (
      (market-description (u"Test Market: Will it rain tomorrow?"))
      (market-creation (contract-call? .prediction-market create-market market-description))
    )
    (asserts! (is-ok market-creation) (err u1))
    (asserts! (> (unwrap-panic market-creation) u0) (err u2))
    (ok true)
  )
)

(define-public (test-get-market-details)
  (let 
    (
      (market-description (u"Test Market: Election Prediction"))
      (market-creation (contract-call? .prediction-market create-market market-description))
      (market-id (unwrap-panic market-creation))
      (market-details (contract-call? .prediction-market get-market-details market-id))
    )
    (asserts! (is-some market-details) (err u1))
    (asserts! 
      (is-eq 
        (get description (unwrap-panic market-details)) 
        market-description
      ) 
      (err u2)
    )
    (ok true)
  )
)

(define-public (test-multiple-market-creation)
  (begin
    ;; Test multiple market creations
    (asserts! 
      (>= 
        (len 
          (list 
            (contract-call? .prediction-market create-market (u"Market 1"))
            (contract-call? .prediction-market create-market (u"Market 2"))
            (contract-call? .prediction-market create-market (u"Market 3"))
          )
        ) 
        u3
      )
      (err u1)
    )
    (ok true)
  )
)
