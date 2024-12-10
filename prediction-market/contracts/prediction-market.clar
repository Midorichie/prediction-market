;; Prediction Market Core Contract
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-MARKET-NOT-FOUND (err u101))

;; Market status constants
(define-constant STATUS-OPEN u0)
(define-constant STATUS-CLOSED u1)
(define-constant STATUS-RESOLVED u2)

;; Store the next market ID
(define-data-var next-market-id uint u1)

;; Market structure to track prediction markets
(define-map markets 
  { market-id: uint }
  {
    creator: principal,
    description: (string-utf8 256),
    status: uint,
    total-pool: uint
  }
)

;; Create a new prediction market
(define-public (create-market 
  (description (string-utf8 256))
)
  (let 
    (
      (market-id (var-get next-market-id))
    )
    (map-set markets 
      { market-id: market-id }
      {
        creator: tx-sender,
        description: description,
        status: STATUS-OPEN,
        total-pool: u0
      }
    )
    (var-set next-market-id (+ market-id u1))
    (ok market-id)
  )
)

;; Get market details
(define-read-only (get-market-details (market-id uint))
  (map-get? markets { market-id: market-id })
)
