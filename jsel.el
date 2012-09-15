(require 'shadchen)

(defun-match- jsel:update-alist (key value nil acc)
  (reverse (cons (cons key value) acc)))

(defun-match jsel:update-alist (key value
									(list-rest (cons (equal key) old-value) rest)
									acc)
  (append (reverse (cons (cons key value) acc)) rest))

(defun-match jsel:update-alist (key value
									(list-rest (and wrong-cell 
													(cons (not-equal key) old-value)) rest)
									acc)
  (recur key value rest (cons wrong-cell acc)))
(defun-match jsel:update-alist (key value alist)
  (recur key value alist nil))

(defun-match- jsel:alist-has-key (key nil)
  nil)
(defun-match jsel:alist-has-key (key (list-rest (cons (equal key) value) tail))
  t)
(defun-match jsel:alist-has-key (key (list-rest (cons (not-equal key) value) tail))
  (recur key tail))

(defpattern jsel:alist-has-key (key pattern)
  (let ((sym (gensym)))
	`(p (lambda (,sym)
		  (jsel:alist-has-key ,key ,sym))
		,pattern)))


(defpattern jsel:alist-without-key (key pattern)
  (let ((sym (gensym)))
	`(p (lambda (,sym)
		  (not (jsel:alist-has-key ,key ,sym)))
		,pattern)))

(defun-match- jsel:alist-pages-update-or-add-to-top (key value (list) acc)
  (reverse (cons (list (cons key value)) acc)))
(defun-match jsel:alist-pages-update-or-add-to-top
  (key value (list-rest (jsel:alist-has-key key alist) rest) acc)
  (let ((new-alist (jsel:update-alist key value alist)))
	(append (reverse acc) (cons new-alist rest))))
(defun-match jsel:alist-pages-update-or-add-to-top
  (key value (list (and top (jsel:alist-without-key key alist))) acc)
  (reverse (cons (cons (cons key value) top) acc)))
(defun-match jsel:alist-pages-update-or-add-to-top
  (key value (list-rest (and not-it (jsel:alist-without-key key alist)) rest) acc)
  (recur key value rest (cons not-it acc)))
(defun-match jsel:alist-pages-update-or-add-to-top
  (key value pages)
  (jsel:alist-pages-update-or-add-to-top key value pages nil))

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

(defun-match- jsel:transcode ('undefined (jsel:context-agnostic))
  (jsel:insert "undefined"))

(defun-match jsel:transcode ('true (jsel:context-agnostic))
  (jsel:insert "true"))

(defun-match jsel:transcode ('empty-object (jsel:context-agnostic))
  (jsel:insert "{}"))

(defun-match jsel:transcode ('false (jsel:context-agnostic))
  (jsel:insert "false"))

(defun-match jsel:transcode ('null (jsel:context-agnostic))
  (jsel:insert "null"))

(defmacro jsel:let-if (c true-branch &optional false-branch)
  (let ((n (gensym)))
	`(let ((,n ,c))
	   (if ,n ,true-branch ,false-branch))))

(defvar jsel:*top-level-symbol-macros* (list))
(defvar jsel:symbol-macro-contexts (list))
(defun-match- jsel:get-symbol-macro (name nil)
  nil)
(defun-match jsel:get-symbol-macro (name (list-rest 
										  (list) rest))
  (recur name rest))
(defun-match jsel:get-symbol-macro (name (list-rest 
										  (list-rest (cons (equal name) macro-expander) tail)
										  env))
  macro-expander)
(defun-match jsel:get-symbol-macro (name (list-rest 
										  (list-rest (cons (not-equal name) macro-expander) tail)
										  env))
  (recur name (cons tail env)))

(defun-match jsel:transcode ((p #'jsel:non-keyword-symbolp s) (or :statement :expression :either))
  (jsel:insert (let-if the-symbol-macro 
					   (jsel:get-symbol-macro s)
					   (funcall the-symbol-macro s) 
					   (jsel:mangle s))))

(defun-match- jsel:get-symbol-macro-cons-cell (name nil)
  nil)
(defun-match jsel:get-symbol-macro-cons-cell (name (list-rest 
													(list) rest))
  (recur name rest))
(defun-match jsel:get-symbol-macro-cons-cell (name (list-rest 
													(list-rest (and (cons (equal name) macro-expander)
																	the-cell) tail)
													env))
  the-cell)
(defun-match jsel:get-symbol-macro-cons-cell (name (list-rest 
													(list-rest (cons (not-equal name) macro-expander) tail)
													env))
  (recur name (cons tail env)))

(defun-match jsel:transcode ((p #'jsel:non-keyword-symbolp s) (or :statement :expression :either))
  (jsel:insert (let-if the-symbol-macro 
					   (jsel:get-symbol-macro s)
					   (funcall the-symbol-macro s) 
					   (jsel:mangle s))))


(defun jsel:remove-colon-from-keyword (s)
  (let ((n (symbol-name s)))
	(intern (substring n 1))))

(defun-match jsel:transcode ((p #'keywordp s) (or :statement :expression :either))
  (jsel:insert (concat "\"" (jsel:mangle (jsel:remove-colon-from-keyword s)) "\"")))

(defun-match jsel:transcode (_)
  (jsel:transcode _ :either))

(defun-match jsel:transcode ((p #'vectorp vector-expression) (jsel:context-agnostic))
  (let ((elements (coerce vector-expression 'list)))
	(jsel:insert "[")
	(jsel:transcode-csvs elements)
	(jsel:insert "]")))

;;; VINCENT
(defun-match jsel:transcode ((list-rest 'define-symbol-macro body)
							 (jsel:context-agnostic))
  )

(defun-match jsel:transcode ((list 'var sym expr) (or :statement :either))
  (jsel:insertf "var %s = " (jsel:transcode sym))
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

(defun jsel:transcode-block (statements)
  (jsel:with-tab+ 
   (jsel:insert "{")
   (jsel:newline)
   (jsel:transcode-newline-sequence statements)
   (jsel:insert "}")))

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

(defun-match jsel:transcode ((list-rest 'primitive-for-in 
										(list (symbol index)
											  expr)
										body)
							 (jsel:context-agnostic))
  (jsel:insert "for (")
  (jsel:transcode index)
  (jsel:insert " in ")
  (jsel:transcode expr)
  (jsel:insert ")")
  (jsel:transcode-block body))

(defun-match jsel:transcode ((list-rest 'primitive-for
										(list init condexpr updateexpr)
										body)
							 (jsel:context-agnostic))
  (jsel:insert "for (")
  (jsel:transcode init)
  (jsel:insert "; ")
  (jsel:transcode condexpr)
  (jsel:insert "; ")
  (jsel:transcode updateexpr)
  (jsel:insert ")")
  (jsel:transcode-block body))

(defun-match jsel:transcode ((list-rest 
							  'for (list (symbol index) :in expr) 
							  body)
							 (jsel:context-agnostic))
  (jsel:transcode `(let () (primitive-for-in (,index ,expr) 
											 (let ((,index ,index))
											   ,@body))
						undefined)))

(defun-match jsel:transcode ((list-rest 
							  'for (list (list (symbol index)
											   (symbol element))
										 :in
										 expr)
							  body)
							 (jsel:context-agnostic))
  (let ((iteratable (gensym "iteratable-"))) 
	(jsel:transcode `(let ((,iteratable ,expr)) 
					   (primitive-for-in 
						(,index ,iteratable)
						(let ((,index ,index)
							  (,element ([] ,iteratable ,index)))
						  ,@body)
						) undefined))))

(defun-match jsel:transcode ((list-rest 
							  'for
							  (list init condexpr updateexpr)
							  body)
							 (jsel:context-agnostic))
  (jsel:transcode `(let ()
					 (primitive-for (,init ,condexpr ,updateexpr) ,@body))))

(defun-match jsel:transcode ((list-rest 'primitive-while condexpr body)
							 (jsel:context-agnostic))
  (jsel:insert "while (")
  (jsel:transcode condexpr)
  (jsel:insert ")")
  (jsel:transcode-block body))

(defun-match jsel:transcode ((list-rest 'while condexpr body) 
							 (jsel:context-agnostic))
  (jsel:transcode `(let () (primitive-while ,condexpr ,@body) undefined) :either))


(defun jsel:empty-vectorp (o)
  (and (vectorp o)
	   (= 0 (length o))))


(defun-match jsel:transcode ((list 'primitive-setq 
								   (p #'symbolp name) 
								   expr) 
							 (jsel:context-agnostic))
  (jsel:transcode name)
  (jsel:insert " = (")
  (jsel:transcode expr)
  (jsel:insert ")"))

(defun jsel:single-element-vectorp (o)
  (and (vectorp o)
	   (= 1 (length o))))

(defun-match jsel:transcode ((list (or 'access 
									   (p #'jsel:empty-vectorp)) object expr)
							 (jsel:context-agnostic))
  (jsel:insert "(")
  (jsel:transcode object)
  (jsel:insert ")[")
  (jsel:transcode expr)
  (jsel:insert "]"))

(defun-match jsel:transcode ((list-rest (or 'access (p #'jsel:empty-vectorp)) object expr0 exprs)
							 (jsel:context-agnostic))
  (recur `([] ([] ,object ,expr0) ,@exprs) :either))

(defun-match jsel:transcode ((list 'primitive-setq 
								   (p #'symbolp name)
								   (p #'jsel:single-element-vectorp vec)
								   expr)
							 (jsel:context-agnostic))
  (jsel:transcode name)
  (jsel:insert "[")
  (jsel:transcode (elt vec 0))
  (jsel:insert "]")
  (jsel:insert " = (")
  (jsel:transcode expr)
  (jsel:insert ")"))

(defun-match jsel:transcode ((list-rest 'setq args) (jsel:context-agnostic))
  (jsel:transcode `(let () (primitive-setq ,@args) undefined)))

(defun jsel:at-sign-p (o)
  (and (symbolp o)
	   (equal o (intern "@"))))

(defun-match jsel:transcode ((list-rest '.. expr symbols) (jsel:context-agnostic))
  (jsel:insert "(")
  (jsel:transcode expr)
  (jsel:insert ")")
  (loop for symbol in symbols do
		(jsel:insert ".")
		(jsel:transcode symbol)))

(defun-match- jsel:split-list-at (sigil (list) acc)
  (list (reverse acc) nil))

(defun-match jsel:split-list-at (sigil (list))
  (list nil nil))

(defun-match jsel:split-list-at (sigil (list-rest (equal sigil _) tl) acc)
  (list (reverse acc) tl))

(defun-match jsel:split-list-at (sigil (list-rest hd tl) acc)
  (recur sigil tl (cons hd acc)))

(defun-match jsel:split-list-at (sigil lst)
  (recur sigil lst nil))

(defun-match jsel:transcode ((list-rest '..* (symbol delim) arguments)
							 (and (jsel:context-agnostic) context))
  (recur 
   (match (jsel:split-list-at delim arguments)
		  ((list before after)
		   `((.. ,@before) ,@after))) context))

(defun-match jsel:transcode ((list-rest '.: arguments)
							 (and (jsel:context-agnostic) context))
  (recur `(..* : ,@arguments) context))

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

(defun-match jsel:transcode ((list-rest 
							  'new 
							  (non-kw-symbol constructor)
							  arguments) 
							 (jsel:context-agnostic))
  (jsel:insert "(new ")
  (jsel:transcode constructor)
  (jsel:insert "(")
  (jsel:transcode-csvs arguments)
  (jsel:insert "))"))


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

(defun-match- jsel:concat-newlines ((list))
  "")

(defun-match jsel:concat-newlines ((list) acc)
  acc)

(defun-match jsel:concat-newlines ((list-rest hd tl) acc)
  (recur tl (concat acc hd (format "\n"))))

(defun-match jsel:concat-newlines ((p #'listp lst))
  (recur lst ""))

(defun-match jsel:transcode ((list-rest 'comment strings) (jsel:context-agnostic))
  (jsel:insert (jsel:concat-newlines (append  (list "/*") strings (list "*/")))))

(defun-match jsel:transcode ((list 'function expr) (jsel:context-agnostic))
  (let ((arg (gensym "sharp-quote-arg-")))
	(recur `(lambda (,arg) ([] ,arg ,expr)))))

(defun-match jsel:transcode ((list 'def (p #'symbolp name) value) (jsel:context-agnostic))
  (jsel:transcode `(var ,name ,value)))

(defun-match jsel:transcode ((list-rest 'def (list-rest (p #'symbolp name) args) body) (jsel:context-agnostic))
  (jsel:transcode `(var ,name (lambda ,args ,@body))))

(defun-match jsel:transcode ((list-rest 'program body) (jsel:context-agnostic))
  (jsel:transcode-newline-sequence body))

(defun-match jsel:transcode ((list 'literally string)
							 (jsel:context-agnostic))
  (jsel:insert string))

(defun-match jsel:transcode ((list-rest 'primitive-include files)
							 (jsel:context-agnostic))
  (loop for file in files do
		(jsel:transcode-file-here file (current-buffer))))

(defvar jsel:macros (make-hash-table :test 'equal))
(defun jsel:macro-symbolp (s)
  (gethash s jsel:macros))

(defun-match jsel:transcode ((list-rest 'defmacro name args body)
							 (jsel:context-agnostic))
  (let ((arg-name (gensym "macro-arg-names-")))
	(puthash name
			 (eval `(lambda (&rest ,arg-name) 
					  (destructuring-bind ,args ,arg-name ,@body)))
			 jsel:macros)))

(defun-match jsel:transcode ((list-rest (p #'jsel:macro-symbolp dispatch-key) arguments)
							 (jsel:context-agnostic))
  (jsel:transcode (apply (gethash dispatch-key jsel:macros) arguments)))

(defmacro* jsel:defmacro (name arglist &body body)
  (let ((arg-name (gensym "defmacro-args-")))
	`(puthash ',name (lambda (&rest ,arg-name)
					   (destructuring-bind ,arglist ,arg-name ,@body))
			  jsel:macros)))

(jsel:defmacro let* (bindings &body body)
			   (let ((expressions (mapcar #'cadr bindings))
					 (symbols (mapcar #'car bindings)))
				 `(let ,(loop for symbol in symbols collect `(,symbol undefined))
					,@(loop for (symbol expression) 
							in bindings collect `(setq ,symbol ,expression))
					,@body)))

(defun-match- jsel:bunch-by-two (nil acc)
  (reverse acc))

(defun-match jsel:bunch-by-two ((list a) acc)
  (error "jsel:bunch-by-two needs a list with an even number of elements."))

(defun-match jsel:bunch-by-two ((list a b) acc)
  (reverse (cons (list a b) acc)))

(defun-match jsel:bunch-by-two ((list-rest a b rest) acc)
  (recur rest (cons (list a b) acc)))

(defun-match jsel:bunch-by-two (the-list)
  (recur the-list nil))

(jsel:defmacro progn 
			   (&body body)
			   `(let () ,@body))

(jsel:defmacro 
 object 
 (&rest kv/pairs)
 (let ((object-name (gensym "object"))
	   (pairs (jsel:bunch-by-two kv/pairs)))
   `(let ((,object-name empty-object))
	  ,@(loop for (index-expr value-expr) in pairs
			  collect `(setq ,object-name ,(vector index-expr) ,value-expr))
	  ,object-name)))

(jsel:defmacro 
 cond
 (&body body)
 (match body
		((list)
		 '(throw "Cond fell through without any branch being true."))
		((list-rest (list-rest test-value sub-body) rest)
		 `(if ,test-value (progn ,@sub-body)
			(cond ,@rest)))))

(defun-match- jsel:get-module-variable-names (nil acc)
  (reverse acc))
(defun-match jsel:get-module-variable-names ((list-rest (string name) tl) acc)
  (recur tl (cons (intern name) acc)))
(defun-match jsel:get-module-variable-names ((list-rest (symbol name) tl) acc)
  (recur tl (cons name acc)))
(defun-match jsel:get-module-variable-names ((list-rest (list module-loc module-name) tl)
											 acc)
  (recur tl (cons module-name acc)))
(defun-match jsel:get-module-variable-names (expressions)
  (recur expressions nil))

(defun-match- jsel:get-module-locations (nil acc)
  (reverse acc))
(defun-match jsel:get-module-locations ((list-rest (string loc) tl) acc)
  (recur tl (cons loc acc)))
(defun-match jsel:get-module-locations ((list-rest (symbol loc) tl) acc)
  (recur tl (cons (symbol-name loc) acc)))
(defun-match jsel:get-module-locations ((list-rest 
										 (list loc sym)
										 tl)
										acc)
  (recur tl (cons (if (stringp loc) loc
					(symbol-name loc)) acc)))
(defun-match jsel:get-module-locations (expressions)
  (recur expressions nil))

(jsel:defmacro 
 with-modules (module-spec &body body)
 (let ((module-variable-names (jsel:get-module-variable-names module-spec))
	   (module-locations (jsel:get-module-locations module-spec)))
   `(require [,@module-locations]
			 (lambda (,@module-variable-names)
			   ,@body))))

;;; SHOULD BE LAST ;;;

(defun-match jsel:transcode ((list-rest fun args) (jsel:context-agnostic))
  (jsel:insert "(")
  (jsel:transcode fun)
  (jsel:insert ")")
  (jsel:insert "(")
  (jsel:transcode-csvs args)
  (jsel:insert ")"))

(defun jsel:read-buffer (buffer)
  (with-current-buffer buffer
	(let* ((all (buffer-substring-no-properties (point-min) (point-max)))
		   (all (concat "(" all ")")))
	  (match (read-from-string all)
			 ((cons s-expr last-index)
			  s-expr)
			 (_ (error "Some problem reading string %S." all))))))

(defun jsel:jsel-file->js-file (filename)
  (match filename
		 ((concat root ".jsel")
		  (concat root ".js"))
		 (_ (concat _ ".js"))))

(defun* jsel:transcode-file (file &optional (output-name nil))
  ""
  (let* ((already-open (find-buffer-visiting file))
		 (buffer (find-file-noselect file))
		 (s-expr (jsel:read-buffer buffer))
		 (output-name (if output-name 
						  output-name
						(jsel:jsel-file->js-file file)))
		 (output-buffer (find-file output-name)))
	(with-current-buffer output-buffer
	  (delete-region (point-min) (point-max))
	  (jsel:transcode (cons 'program s-expr))
	  (save-buffer))
	(if (not already-open)
		(kill-buffer already-open))))

(defun* jsel:transcode-file-here (file output-buffer)
  ""
  (let* ((already-open (find-buffer-visiting file))
		 (buffer (find-file-noselect file))
		 (s-expr (jsel:read-buffer buffer)))
	(with-current-buffer output-buffer
	  (jsel:transcode (append (list 'program
									`(comment ,(concat "Include: " file))) s-expr)))))

(defun* jsel:transcode-current-buffer ()
  (interactive)
  (with-current-buffer (current-buffer)
	(save-buffer)
	(jsel:transcode-file (buffer-file-name (current-buffer)))))

(provide 'jsel)

