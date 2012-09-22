(eval-when (compile load eval) 
  (require 'shadchen))

(defmacro jsel:defvar-force-init (name value &optional doc)
  `(progn (defvar ,name nil ,doc)
		  (setq ,name ,value)))

(eval-when (compile load eval) 
  (defun jsel:symbol->reduced-form (s)
	(let ((name (symbol-name s)))
	  (match name 
			 ("." (intern "."))
			 (".." (intern ".."))
			 (".:" (intern ".:"))
			 ("..*" (intern "..*"))
			 (name 
			  (let ((pieces (split-string name (regexp-quote "."))))
				(match pieces
					   ((list one-piece) s)
					   ((list-rest (funcall #'intern head) other-pieces)
						`(.. ,(jsel:transform-via-symbol-macro head)
							 ,@(mapcar (lambda (s) `(literally ,(jsel:mangle s))) other-pieces)))))))))

  (defun jsel:simple-symbol-p (s)
	(and (symbolp s)
		 (eq (jsel:symbol->reduced-form s) s)))

  (defun jsel:symbol->reduced-form-or-pass (s)
	(if (symbolp s)
		(jsel:symbol->reduced-form s)
	  s))

  (defun-match- jsel:join (nil delim acc)
	acc)
  (defun-match jsel:join (elements delim)
	(recur elements delim ""))
  (defun-match jsel:join ((list hd) delim acc)
	(concat acc hd))
  (defun-match jsel:join ((list-rest hd tl) delim acc)
	(recur tl delim (concat acc hd delim)))

  (defun jsel:expression->reduced-form (e)
	(match e
		   ((symbol s)
			(jsel:symbol->reduced-form s))
		   ((list-rest (and leader '..) hd other-expressions)
			`(,leader (jsel:symbol->reduced-form-or-pass hd) ,@other-expressions))
		   (_ _)))

  (defun-match- jsel:..->symbol-for-macro-lookup ((list-rest '.. hd symbols))
	(if (not (symbolp hd))
		(gensym)
	  (intern (jsel:join (mapcar #'symbol-name (cons hd symbols)) "."))
	  ))
  (defun-match jsel:..->symbol-for-macro-lookup (_)
	(gensym)))

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

(eval-when (compile load eval) 
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
		  ,pattern))))

(defun-match- jsel:alist-lookup (key nil or-value)
  or-value)
(defun-match jsel:alist-lookup (key (list-rest (cons (equal key) value) alist) or-value)
  value)
(defun-match jsel:alist-lookup (key (list-rest (cons (not-equal key) value) alist) or-value)
  (recur key alist or-value))
(defun-match jsel:alist-lookup (key alist)
  (recur key alist nil))



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
	  ("$" "$")
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

(jsel:defvar-force-init jsel:indent-depth 0)
(defun jsel:newline ()
  (jsel:insertf "\n")
  (loop for i from 1 to jsel:indent-depth do
		(jsel:insert " ")))

(defmacro* jsel:with-tab+ (&body body)
  `(let ((jsel:indent-depth (+ jsel:indent-depth 2)))
	 (loop for i from 1 to jsel:indent-depth do
		   (jsel:insert " "))
	 ,@body))

(eval-when (compile load eval) 
  (defpattern jsel:context-agnostic ()
	'(or :statement :expression :either)))

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

(jsel:defvar-force-init jsel:*top-level-symbol-macros* (list))
(jsel:defvar-force-init jsel:symbol-macro-contexts (list))

(defun-match- jsel:get-symbol-macro (s nil)
  (jsel:alist-lookup s jsel:*top-level-symbol-macros*))
(defun-match jsel:get-symbol-macro (s (list-rest env rest))
  (let ((expander (jsel:alist-lookup s env)))
	(if expander expander
	  (recur s rest))))
(defun-match jsel:get-symbol-macro (s)
  (recur s jsel:symbol-macro-contexts))

(defun jsel:transform-via-symbol-macro (s)
  (let ((expander (jsel:get-symbol-macro s)))
	(if expander (funcall expander s)
	  s)))


(defun-match- jsel:extend-current-symbol-macro-context (s transformer (list))
  (setf jsel:*top-level-symbol-macros* (cons (cons s transformer) jsel:*top-level-symbol-macros*)))
(defun-match jsel:extend-current-symbol-macro-context (s tranformer (list-rest context other-contexts))
  (setf jsel:symbol-macro-contexts 
		(cons (cons (cons s tranformer) context) other-contexts)))
(defun-match jsel:extend-current-symbol-macro-context (s tranformer)
  (recur s tranformer jsel:symbol-macro-contexts))

(eval-when (compile load eval) 
  (defun jsel:symbol-macro-bind->alist-entry (bind)
	(match bind 
		   ((list (symbol s) expr)
			`(,s . (lambda (,(gensym)) ,expr)))
		   ((list (symbol s) (list (symbol id)) expr)
			`(s . (lambda (,id) ,expr)))))
  (defun-match- jsel:symbol-macro-binders->alist (nil acc)
	acc)
  (defun-match jsel:symbol-macro-binders->alist ((list-rest binder tl) acc)
	(recur tl (cons (jsel:symbol-macro-bind->alist-entry binder) acc)))
  (defun-match jsel:symbol-macro-binders->alist (binders)
	(recur binders nil)))

(defmacro jsel:with-symbol-macros (bindings &body body)
  `(let ((jsel:symbol-macro-contexts (cons ',(jsel:symbol-macro-binders->alist bindings))))
	 ,@body))

(defun-match jsel:transcode ((p #'jsel:non-keyword-symbolp s) 
							 (and context (or :statement :expression :either)))
  (let ((s (jsel:symbol->reduced-form s))) 
	(if (symbolp s) 
		(let-if the-symbol-macro 
				(jsel:get-symbol-macro s)
				(jsel:transcode (funcall the-symbol-macro s) context) 
				(jsel:insert (jsel:mangle s)))
	  (jsel:transcode s context))))

(defun jsel:remove-colon-from-keyword (s)
  (let ((n (symbol-name s)))
	(intern (substring n 1))))

(defun-match jsel:transcode ((p #'keywordp s) (or :statement :expression :either))
  (jsel:insert (concat "\"" (jsel:mangle (jsel:remove-colon-from-keyword s)) "\"")))

(defun-match jsel:transcode (_)
  (jsel:transcode _ :either))

(defun-match jsel:transcode ((list-rest 'symbol-macro-let bindings body)
							 (jsel:context-agnostic))
  (let ((jsel:symbol-macro-contexts 
		 (cons (jsel:symbol-macro-binders->alist bindings) jsel:symbol-macro-contexts)))
	(jsel:transcode `(let () ,@body))))

(defun-match jsel:transcode ((list-rest 'symbol-macro-letq bindings body)
							 (jsel:context-agnostic))
  (let ((jsel:symbol-macro-contexts 
		 (cons (jsel:symbol-macro-binders->alist 
				(mapcar (match-lambda 
						 ((list s e)
						  (list s `(quote ,e))))
						bindings)) jsel:symbol-macro-contexts)))
	(jsel:transcode `(let () ,@body))))


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
  ;;(jsel:insertf "var %s = " (jsel:transcode sym))
  (jsel:insert "var ")
  (jsel:transcode sym)
  (jsel:insert " = ")
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

(defun-match jsel:transcode ((list-rest 'def-fun-dont-symbol-macro-expand-id 
										(list-rest (p #'symbolp name) args) body) (jsel:context-agnostic))
  (jsel:insert "var ")
  (jsel:insert (jsel:mangle name))
  (jsel:insert " = ")
  (jsel:transcode `(lambda (,@args) ,@body)))

(defun-match jsel:transcode ((list-rest 'program body) (jsel:context-agnostic))
  (jsel:transcode-newline-sequence body))

(defun-match jsel:transcode ((list 'primitive-try 
								   (list-rest body-block)
								   (list-rest 'catch (symbol s) catch-body)
								   (list-rest 'finally finally-body))
							 (jsel:context-agnostic))
  (jsel:insert "try")
  (jsel:transcode-block body-block)
  (jsel:insert "catch (")
  (jsel:transcode s)
  (jsel:insert ")")
  (jsel:transcode-block catch-body)
  (jsel:insert "finally")
  (jsel:transcode-block finally-body))

(defun-match jsel:transcode ((list 'throw expression)
							 (jsel:context-agnostic))
  (jsel:insert "(throw ")
  (jsel:transcode expression)
  (jsel:insert ")"))

(defun jsel:make-last-element-a-setq (target elements)
  (let* ((r (reverse elements))
		 (last (car r))
		 (all-but-last (cdr r))
		 (new-last `(setq ,target ,last)))
	(reverse (cons new-last all-but-last))))

(defun-match jsel:transcode ((list 'try (list-rest body-block)
								   (list-rest 'catch (symbol binding) catch-block))
							 (jsel:context-agnostic))
  (let ((retval (gensym "try-retval")))
	(recur `(let ((,retval undefined)) 
			  (primitive-try ,(jsel:make-last-element-a-setq ,retval body-block)
							 (catch ,binding ,@catch-block)
							 (finally undefined)) 
			  ,retval))))


(defun-match jsel:transcode ((list 'try (list-rest body-block)
								   (list-rest 'finally  finally-block))
							 (jsel:context-agnostic))
  (let ((retval (gensym "try-retval"))
		(exception (gensym "exception-")))
	(recur `(let ((,retval undefined)) 
			  (primitive-try ,(jsel:make-last-element-a-setq retval body-block)
							 (catch ,exception (throw ,exception))
							 (finally ,@finally-block)) 
			  ,retval))))

(defun-match jsel:transcode ((list 'try (list-rest body-block)
								   (list-rest 'catch (symbol binding) catch-block)
								   (list-rest 'finally finally-block))
							 (jsel:context-agnostic))
  (let ((retval (gensym "try-retval")))
	(recur `(let ((,retval undefined)) 
			  (primitive-try ,(jsel:make-last-element-a-setq retval body-block)
							 (catch ,binding ,@catch-block)
							 (finally ,@finally-block)) 
			  ,retval))))

(defun-match jsel:transcode ((list 'try (list-rest body-block)
								   (list-rest 'finally finally-block)
								   (list-rest 'catch (symbol binding) catch-block))
							 (jsel:context-agnostic))
  (let ((retval (gensym "try-retval")))
	(recur `(let ((,retval undefined)) 
			  (primitive-try ,(jsel:make-last-element-a-setq retval body-block)
							 (catch ,binding ,@catch-block)
							 (finally ,@finally-block)) 
			  ,retval))))


(defun-match jsel:transcode ((list 'literally string)
							 (jsel:context-agnostic))
  (jsel:insert string))

(defun-match jsel:transcode ((list-rest 'primitive-include files)
							 (jsel:context-agnostic))
  (loop for file in files do
		(jsel:transcode-file-here file (current-buffer))))

(jsel:defvar-force-init jsel:macros (make-hash-table :test 'equal))
(setq jsel:macros (make-hash-table :test 'equal))
(defun jsel:macro-symbolp (s)
  (if (symbolp s) 
	  (gethash (jsel:transform-via-symbol-macro s) jsel:macros)
	(gethash (jsel:transform-via-symbol-macro 
			  (jsel:..->symbol-for-macro-lookup s)) jsel:macros)))

(defun jsel:get-macro-expander (s)
  (jsel:macro-symbolp s))


(defun-match jsel:transcode ((list-rest 'defmacro name args body)
							 (jsel:context-agnostic))
  (assert (jsel:simple-symbol-p name)
		  ()
		  "Macros cannot be bound to non-simple symbols (ie,
		  symbols with . in them.)  Tried to bind to %S." name)
  (cond 
   (jsel:*module* 
	(let ((actual-name (jsel:symbol-concat jsel:*module* (intern "-") name)))
	  (jsel:transcode `(defmacro ,actual-name ,arguments ,@body))
	  (jsel:insertf "//%S" `(defmacro ,actual-name ,arguments ,@body))
	  (jsel:extend-current-symbol-macro-context name (eval `(lambda (s) ',actual-name)))))
   (:otherwise 
	(let ((arg-name (gensym "macro-arg-names-")))
	  (puthash name
			   (eval `(lambda (&rest ,arg-name) 
						(destructuring-bind ,args ,arg-name ,@body)))
			   jsel:macros)))))

(defun jsel:transforms-via-symbol-macrop (s)
  (not (eq (jsel:transform-via-symbol-macro s) s)))

(defun-match jsel:transcode ((list-rest (p #'jsel:transforms-via-symbol-macrop s) arguments)
							 (and context (jsel:context-agnostic)))
  (recur `(,(jsel:transform-via-symbol-macro s) ,@arguments)
		 context))

(defun-match jsel:transcode ((list-rest (p #'jsel:macro-symbolp dispatch-key) arguments)
							 (and context (jsel:context-agnostic)))
  (recur (apply (jsel:get-macro-expander dispatch-key) arguments) context))

(defmacro* jsel:defmacro (name arglist &body body)
  (let ((arg-name (gensym "defmacro-args-")))
	`(puthash ',(jsel:symbol->reduced-form name) (lambda (&rest ,arg-name)
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

(jsel:defvar-force-init jsel:*module* nil)
(jsel:defvar-force-init jsel:*module-manifest* :out-of-module)
(jsel:defvar-force-init jsel:*module-hash* nil)
(jsel:defvar-force-init jsel:last-manifest nil)

(defun jsel:extend-module-manifest (module-level-name type meta)
  (cond 
   ((eq :out-of-module jsel:*module-manifest*) (error "Cannot extend a module manifest when there is not an active module."))
   (:otherwise
	(setf jsel:*module-manifest* (cons (cons module-level-name (list type meta)) jsel:*module-manifest*)))))

(defun jsel:get-manifest-item (name manifest)
  (jsel:alist-lookup name manifest))

(defun-match jsel:transcode ((list-rest 'primitive-module body)
							 (jsel:context-agnostic))
  (let ((jsel:*module* (intern (concat "primitive-module-" (md5 (format "%S" body)))))
		(jsel:symbol-macro-contexts (cons (list) jsel:symbol-macro-contexts))
		(jsel:*module-manifest* nil))
	(jsel:transcode `(let ((,jsel:*module* (literally "{}")))
					   ,@body
					   ,jsel:*module*)
					:either)
	(setq jsel:last-manifest jsel:*module-manifest*)
	jsel:*module-manifest*))

(defun jsel:symbol-concat (&rest args)
  (intern (apply #'concat (mapcar #'symbol-name args))))

(defun-match jsel:transcode ((list 'def-external (symbol name) expression)
							 (jsel:context-agnostic))
  (cond 
   (jsel:*module*
	(let ((actual-name (jsel:symbol-concat jsel:*module* (intern ".") name)))
	  (jsel:extend-module-manifest name :js-value `((:module . ,jsel:*module*) (:object-type . :any)))
	  (jsel:transcode `(setq ,actual-name ,expression) :either)
	  (jsel:extend-current-symbol-macro-context name (eval `(lambda (s) ',actual-name)))))
   (:otherwise (error "jsel:transcode def-external can only be used in a module context."))))

(defun-match jsel:transcode ((list-rest 'def-external (list-rest (symbol name) arguments) body)
							 (jsel:context-agnostic))
  (cond 
   (jsel:*module*
	(let ((actual-name (jsel:symbol-concat jsel:*module* (intern ".") name)))
	  (jsel:extend-module-manifest name :js-value `((:module . ,jsel:*module*) (:object-type . :function)))
	  (jsel:extend-current-symbol-macro-context name (eval `(lambda (s) ',actual-name)))
	  (jsel:transcode `(setq ,actual-name (lambda (,@arguments) ,@body)))))
   (:otherwise (error "jsel:transcode def-external can only be used in a module context."))))

(defun-match jsel:transcode ((list-rest 'defmacro-external (symbol name) arguments body)
							 (jsel:context-agnostic))
  (assert (jsel:simple-symbol-p name)
		  ()
		  "Macros cannot be bound to non-simple symbols (ie,
		  symbols with . in them.)  Tried to bind to %S." name)
  (cond 
   (jsel:*module*
	(let ((actual-name (jsel:symbol-concat jsel:*module* (intern "-") name))
		  (args (gensym)))
	  (jsel:extend-module-manifest name :macro `((:module . ,jsel:*module*) 
												 (:object-type . :not-an-object)
												 (:actual-name . ,actual-name)))
	  (setf (gethash actual-name jsel:macros)
			(eval `(lambda (&rest ,args) (destructuring-bind ,arguments ,args ,@body))))
	  (jsel:extend-current-symbol-macro-context name (eval `(lambda (s) ',actual-name)))))
   (:otherwise (error "jsel:transcode def-external can only be used in a module context."))))

(defun-match jsel:transcode ((list-rest 'def-primitive-module name body)
							 (jsel:context-agnostic))
  (let ((manifest (jsel:transcode 
				   `(def ,name (primitive-module ,@body)))))
	(loop for item in manifest do
		  (match item 
				 ((list name :js-value meta) :pass)
				 ((list macro-name :macro meta)
				  (let ((actual-name (jsel:alist-lookup :actual-name meta)))
					(jsel:extend-current-symbol-macro-context 
					 (jsel:symbol-concat name (intern ".") macro-name)
					 (eval `(lambda (s) ',actual-name)))
					(message "actual-name %S" actual-name)))))))

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
(defun-match- jsel:macro-expand-1 ((list-rest (p #'jsel:macro-symbolp dispatch-key) arguments))
  (apply (jsel:get-macro-expander dispatch-key) arguments))
(defun-match jsel:macro-expand-1 (_)
  _)

(provide 'jsel)

