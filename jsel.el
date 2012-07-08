(require 'shadchen)

(defun jsel:non-keyword-symbolp (x)
  "T when X is a symbol but not a keyword."
  (and (symbolp x)
	   (not (keywordp x))))


(defun jsel:mangle (s)
  (let* ((s (if (symbolp s) (symbol-name s) s))
		 (s1 (replace-regexp-in-string "-\\([a-z]\\)" 
									   (lambda (x)
										 (upcase (substring x 1))) 
									   s))
		 (s1 (replace-regexp-in-string (regexp-quote "%")
									   "modsign"
									   s1)))
	(replace-regexp-in-string 
	 (rx 
	  (| "|" "~" "+" "-" "*" "%" "$" "&" "^" "!" ":" "/" "\\" "#" "@" "?" "="
		 "<" ">"))
	 (match-lambda
	  ("|" "pipe")
	  ("+" "plus")
	  ("-" "minus")
	  ("*" "times")
	  ("<" "lessThan")
	  (">" "greaterThan")
	  ("$" "cash")
	  ("=" "equal")
	  ("%" "modsign")
	  ("!" "bang")
	  ("?" "who")
	  (":" "colon")
	  ("&" "ampersand")
	  ("^" "caret")
	  ("/" "divide")
	  ("\\" "mdivide")
	  ("#" "hash")
	  ("~" "tilda")
	  ("@" "at"))
	 s1)))

(defun jsel:insertf (fs &rest args)
  (insert (apply #'format fs args)))

(defun jsel:insert (fs)
  (insert fs))

(defvar jsel:indent-depth 0)
(defun jsel:newline ()
  (jsel:insertf "\n")
  (loop for i from 1 to jsel:indent-depth do
		(jsel:insert " ")))

(defmacro* jsel:with-tab+ (&body body)
  `(let ((jsel:indent-depth (+ jsel:indent-depth 2)))
	 (loop for i from 1 to jsel:indent-depth do
		   (jsel:insert " "))
	 ,@body))

(defpattern jsel:context-agnostic ()
  '(or :statement :expression :either))

(defun-match- jsel:transcode ((p #'jsel:non-keyword-symbolp s) (or :statement :expression :either))
  (jsel:insert (jsel:mangle s)))

(defun-match jsel:transcode (_)
  (jsel:transcode _ :either))

(defun-match jsel:transcode ((list 'var sym expr) (or :statement :either))
  (jsel:insertf "var %s = " (jsel:mangle sym))
  (jsel:transcode expr))

(defun-match jsel:transcode ((list 'var sym expr) :expression)
  (jsel:transcode `(eval (quote (var ,sym ,expr)))))

(defun-match- jsel:transcode-csvs ((list))
  nil)
(defun-match jsel:transcode-csvs ((list item))
  (jsel:transcode item))
(defun-match jsel:transcode-csvs ((list-rest item rest))
  (jsel:transcode item)
  (jsel:insert ", ")
  (recur rest))

(defun-match- jsel:transcode-newline-sequence ((list))
  nil)
(defun-match jsel:transcode-newline-sequence ((list item))
  (jsel:transcode item)
  (jsel:insert ";")
  (jsel:newline))
(defun-match jsel:transcode-newline-sequence ((list-rest item rest))
  (jsel:transcode item)
  (jsel:insert ";")
  (jsel:newline)
  (recur rest))

(defun-match jsel:transcode ((list 'if expr true-branch false-branch) (jsel:context-agnostic))
  (jsel:insert "((")
  (jsel:transcode expr)
  (jsel:insert ") ? (")
  (jsel:transcode true-branch)
  (jsel:insert ") : (")
  (jsel:transcode false-branch)
  (jsel:insert "))"))

(defun-match jsel:transcode ((list 'if expr true-branch) (jsel:context-agnostic))
  (jsel:insert "((")
  (jsel:transcode expr)
  (jsel:insert ") ? (")
  (jsel:transcode true-branch)
  (jsel:insert ") : (")
  (jsel:transcode 'undefined)
  (jsel:insert "))"))

(defun-match jsel:transcode ('undefined (jsel:context-agnostic))
  (jsel:insert "undefined"))

(defun-match jsel:transcode ('true (jsel:context-agnostic))
  (jsel:insert "true"))

(defun-match jsel:transcode ('empty-object (jsel:context-agnostic))
  (jsel:insert "{}"))

(defun-match jsel:transcode ('false (jsel:context-agnostic))
  (jsel:insert "false"))

(defun-match jsel:transcode ('null (jsel:context-agnostic))
  (jsel:insert "null"))

(defun-match jsel:transcode ((p #'numberp n) (jsel:context-agnostic))
  (jsel:insertf "%s" n))

(defun-match jsel:transcode ((p #'stringp str) (jsel:context-agnostic))
  (jsel:insert "")
  (jsel:insertf "%S" str)
  (jsel:insert ""))

(defun-match jsel:transcode ((list 'return expr) (jsel:context-agnostic))
  (jsel:insert "return (")
  (jsel:transcode expr)
  (jsel:insert ")"))

(defun-match jsel:transcode ((list 'setq 
								   (p #'symbolp name) 
								   expr) 
							 (jsel:context-agnostic))
  (jsel:transcode name)
  (jsel:insert " = (")
  (jsel:transcode expr)
  (jsel:insert ")"))

(defun-match- jsel:valid-bindings (nil)
  t)
(defun-match jsel:valid-bindings ((list-rest (list pat expr) rest))
  (if (symbolp pat) (recur rest)
	nil))
(defun-match jsel:valid-bindings (_) nil)

(defun-match jsel:transcode ((list-rest 'funcall f-expression args)
							 (jsel:context-agnostic))
  (jsel:insert "((")
  (jsel:transcode f-expression)
  (jsel:insert ")(")
  (jsel:transcode-csvs args)
  (jsel:insert "))"))

(defun-match jsel:transcode ((list-rest 'let (list-rest bindings) body) 
							 (jsel:context-agnostic))
  (assert (jsel:valid-bindings bindings)
		  ()
		  "Bindings must be pattern/expression pairs.  Legal patterns are symbols.")
  (let ((args (mapcar #'car bindings))
		(vals (mapcar #'cadr bindings)))
	(jsel:transcode `(funcall 
					  (lambda ,args ,@body)
					  ,@vals))))



(defun-match jsel:transcode ((list-rest 'object k/v-pairs)
							 (jsel:context-agnostic))
  (let ((temp-name (gensym "temp-object-")))
	`(let ((,temp-object empty-object))
	   ())))

(defun jsel:make-last-statement-a-return (list)
  "Make the last statement of something a return."
  (if (null list) (list '(return undefined))
	(let* ((rev (reverse (copy-list list)))
		   (last `(return ,(car rev)))
		   (rest (cdr rev)))
	  (reverse (cons last rest)))))

(defun-match- jsel:all-symbols (nil)
  t)
(defun-match jsel:all-symbols ((list-rest a rest))
  (if (symbolp a) (recur rest)
	nil))

(defun-match jsel:transcode ((list-rest 'lambda (list-rest arg-list) body) (jsel:context-agnostic))
  (assert (jsel:all-symbols arg-list)
		  ()
		  "error transcoding a lambda: all args must be symbols.")
  (jsel:insert "function(")
  (jsel:transcode-csvs arg-list)
  (jsel:insert ") {")
  (jsel:newline)
  (jsel:with-tab+ 
   (jsel:transcode-newline-sequence 
	(jsel:make-last-statement-a-return body)))
  (jsel:insert "}"))

(defun-match jsel:transcode ((list 'define (p #'symbolp name) value) (jsel:context-agnostic))
  (jsel:transcode `(var ,name ,value)))

(defun-match jsel:transcode ((list-rest 'define (list-rest (p #'symbolp name) args) body) (jsel:context-agnostic))
  (jsel:transcode `(var ,name (lambda ,args ,@body))))

(defun-match jsel:transcode ((list-rest 'program body) (jsel:context-agnostic))
  (jsel:transcode-newline-sequence body))

(defun-match jsel:transcode ((p #'vectorp vector-expression) (jsel:context-agnostic))
  (let ((elements (coerce vector-expression 'list)))
	(jsel:insert "[")
	(jsel:transcode-csvs elements)
	(jsel:insert "]")))


;;; SHOULD BE LAST ;;;

(defun-match jsel:transcode ((list-rest fun args) (jsel:context-agnostic))
  (jsel:insert (jsel:mangle fun))
  (jsel:insert "(")
  (jsel:transcode-csvs args)
  (jsel:insert ")"))








