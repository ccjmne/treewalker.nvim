(define (print-odd-numbers up-to)
  (let ((count 1))
    (lambda ()
      (if (> count up-to)
          null
          (begin
            (display count)
            (newline)
            (set! count (+ count 2))
            (cons count (print-odd-numbers up-to)))))))

(define (sum-a-list lst)
  (cond ((null? lst) 0)
        ((list? (cdr lst))
         (+ (car lst) (sum-a-list (cdr lst))))
        (else
          (display "Invalid list")
          (newline))))

(define (is-prime? num)
  (let ((divisors 2))
    (cond ((> (* divisors divisors) num) true)
          ((= (modulo num divisors) 0) false)
          (else
            (set! divisors (+ divisors 1))
            (is-prime? num)))))

(define (greet name)
  (display "Hello, ")
  (display name)
  (newline))

(module test racket
  (require rackunit)

  (define odd-numbers-upto-10 (print-odd-numbers 10))
  (check-equal? (car (odd-numbers-upto-10)) 1)

  (define sum-of-list '(1 2 3 4 5)
    (sum-a-list sum-of-list) => 15)

  (define is-prime 100
    (is-prime? num) => #t))

(module main racket
  (require rackunit)

  (let ((name "John"))
    (greet name)))
