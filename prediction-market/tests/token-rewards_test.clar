;; Token Rewards Test Suite
(use-trait sip010-token 'ST1HTBVD3FMWHSXMGTWFD8GK0D4GQ1SQ4MBNQTCR.sip010-token-trait.sip010-token-trait)

(define-public (test-calculate-rewards)
  (let 
    (
      (market-id u1)
      (user-address 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
      (reward-calculation (contract-call? .token-rewards calculate-market-rewards 
        market-id 
        user-address
      ))
    )
    (asserts! (is-ok reward-calculation) (err u1))
    (ok true)
  )
)

(define-public (test-reward-distribution)
  (let 
    (
      (market-id u2)
      (user-address 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
      (reward-amount u100)
      (distribution (contract-call? .token-rewards distribute-rewards 
        market-id 
        user-address 
        reward-amount
      ))
    )
    (asserts! (is-ok distribution) (err u1))
    (ok true)
  )
)

(define-public (test-reward-tracking)
  (let 
    (
      (user-address 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
      (total-rewards (contract-call? .token-rewards get-user-total-rewards user-address))
    )
    (asserts! (is-some total-rewards) (err u1))
    (ok true)
  )
)
