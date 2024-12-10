;; Oracle Registry Test Suite
(define-public (test-register-oracle)
  (let 
    (
      (oracle-name (u"TestOracle"))
      (oracle-url (u"https://test-oracle.com/api"))
    )
    (asserts! 
      (is-ok 
        (contract-call? .oracle-registry register-oracle 
          oracle-name 
          oracle-url
        )
      ) 
      (err u1)
    )
    (ok true)
  )
)

(define-public (test-validate-oracle-registration)
  (let 
    (
      (oracle-name (u"ValidOracle"))
      (oracle-url (u"https://valid-oracle.com/api"))
      (registration (contract-call? .oracle-registry register-oracle 
        oracle-name 
        oracle-url
      ))
      (oracle-details (contract-call? .oracle-registry get-oracle-details oracle-name))
    )
    (asserts! (is-ok registration) (err u1))
    (asserts! 
      (is-some oracle-details)
      (err u2)
    )
    (ok true)
  )
)

(define-public (test-oracle-reputation)
  (let 
    (
      (oracle-name (u"ReputationOracle"))
      (registration (contract-call? .oracle-registry register-oracle 
        oracle-name 
        (u"https://reputation-oracle.com/api")
      ))
      (reputation-update (contract-call? .oracle-registry update-oracle-reputation 
        oracle-name 
        u10
      ))
    )
    (asserts! (is-ok registration) (err u1))
    (asserts! (is-ok reputation-update) (err u2))
    (ok true)
  )
)
