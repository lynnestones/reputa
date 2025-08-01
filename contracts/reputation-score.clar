;; Reputa Reputation Score Contract
;; Tracks and manages decentralized reputation scores

(define-data-var admin principal tx-sender)

;; Mapping of user to reputation score (0-1000 scale)
(define-map reputation-scores principal uint)

;; Endorsements with weight per endorser (prevents spamming)
(define-map endorsements (tuple (endorser principal) (target principal)) uint)

;; Record of dispute strikes per user
(define-map disputes principal uint)

;; Max reputation score
(define-constant MAX-REP u1000)

;; Constants for error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-SELF-ENDORSE u101)
(define-constant ERR-ALREADY-ENDORSED u102)
(define-constant ERR-NOT-ENDORSED u103)
(define-constant ERR-ZERO-WEIGHT u104)
(define-constant ERR-ZERO-PENALTY u105)

;; Check if sender is admin
(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

;; Initialize a user with a base reputation score (admin only)
(define-public (initialize-user (user principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    ;; Base reputation is implicitly 500 if not set; this explicitly sets it.
    (map-set reputation-scores user u500)
    (ok true)
  ))

;; Internal function: safely adjust reputation with upper/lower bounds
(define-private (adjust-reputation (user principal) (delta int))
  (let (
        ;; Implicit default reputation is 500 for users with no entry.
        (current (to-int (default-to u500 (map-get? reputation-scores user))))
        (updated (max 0 (min MAX-REP (+ current delta))))
       )
    (map-set reputation-scores user (to-uint updated))))

;; Endorse a user (adds weight to their score)
(define-public (endorse (target principal) (weight uint))
  (begin
    ;; no self-endorse
    (asserts! (not (is-eq tx-sender target)) (err ERR-SELF-ENDORSE))
    ;; reject zero-weight endorsements
    (asserts! (not (is-eq weight u0)) (err ERR-ZERO-WEIGHT))
    ;; prevent double endorsement
    (asserts! (is-none (map-get? endorsements { endorser: tx-sender, target: target })) (err ERR-ALREADY-ENDORSED))
    (map-set endorsements { endorser: tx-sender, target: target } weight)
    (adjust-reputation target (to-int weight))
    (ok true)
  ))

;; Revoke endorsement (removes weight)
(define-public (revoke-endorsement (target principal))
  (match (map-get? endorsements { endorser: tx-sender, target: target })
    endorsement-weight
      (begin
        (map-delete endorsements { endorser: tx-sender, target: target })
        (adjust-reputation target (- (to-int endorsement-weight)))
        (ok true))
    (err ERR-NOT-ENDORSED)))

;; Admin applies strike (reputation penalty) to user
(define-public (strike (user principal) (penalty uint))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    ;; reject zero penalty
    (asserts! (not (is-eq penalty u0)) (err ERR-ZERO-PENALTY))
    (let (
          (existing (default-to u0 (map-get? disputes user)))
          (total (+ existing penalty)))
      (map-set disputes user total)
      (adjust-reputation user (- (to-int penalty)))
      (ok true))))

;; Admin resets a user's reputation
(define-public (reset-user (user principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (map-set reputation-scores user u500)
    (ok true)))

;; Read-only: get a user's reputation score
(define-read-only (get-score (user principal))
  (default-to u500 (map-get? reputation-scores user)))

;; Read-only: get endorsement weight from A to B
(define-read-only (get-endorsement (endorser principal) (target principal))
  (map-get? endorsements { endorser: endorser, target: target }))

;; Transfer admin role
(define-public (transfer-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (var-set admin new-admin)
    (ok true)))
