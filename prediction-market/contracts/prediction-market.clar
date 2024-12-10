;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-MARKET (err u101))
(define-constant ERR-INVALID-BET (err u102))

;; Market status types
(define-constant MARKET-OPEN u0)
(define-constant MARKET-CLOSED u1)
(define-constant MARKET-RESOLVED u2)

;; Store the next market ID
(define-data-var next-market-id uint u1)

;; Market structure to track prediction markets
(define-map markets 
  { market-id: uint }
  {
    creator: principal,
    description: (string-utf8 256),
    status: uint,
    total-pool: uint,
    outcomes: (list 5 (string-utf8 50))
  }
)

;; Create a new prediction market
(define-public (create-market 
  (description (string-utf8 256))
  (outcomes (list 5 (string-utf8 50)))
)
  (begin
    ;; Ensure outcomes length is valid
    (asserts! (>= (len outcomes) u2) ERR-INVALID-MARKET)
    
    (let 
      (
        (market-id (var-get next-market-id))
      )
      (map-set markets 
        { market-id: market-id }
        {
          creator: tx-sender,
          description: description,
          status: MARKET-OPEN,
          total-pool: u0,
          outcomes: outcomes
        }
      )
      (var-set next-market-id (+ market-id u1))
      (ok market-id)
    )
  )
)
