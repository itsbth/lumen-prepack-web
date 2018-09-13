(when-compiling
  (define-global extract-helper (from keys)
                 (if (empty? keys)
                   from
                   `(get ,(extract-helper from (tl keys)) ,(hd keys)))))

(define-macro extract (from rest: keys)
              (extract-helper from (reverse keys)))

(define-macro setx (from rest: keys)
              (let (rev (reverse keys)
                        keys (tl rev)
                        val (hd rev))
                `(set ,(extract-helper from keys) ,val)))

(define-macro bind (what rest: keys)
              (let (rev (reverse keys)
                        obj (tl rev)
                        fn (hd rev))
                `(let (to-bind ,(extract-helper what obj))
                   ((extract to-bind ,fn 'bind) to-bind))))

|function _try(fn, fb) { try { return fn() } catch (e) { return fb } }|

(define run ()
  (define append (bind document 'body 'appendChild))
  (define create-element (bind document 'createElement))
  (let (box (create-element "input")
            res (create-element "p"))
       (setx box 'oninput (fn () (setx res 'textContent (try (fn () (compile (read-string (get box 'value)))) "error"))))
       (append box)
       (append res)))      
(setx window 'run run)

