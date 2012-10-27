(eval-when (compile load eval) 
  (require 'shadchen))

(defmacro jsel:defvar-force-init (name value &optional doc)
  "Exactly like DEFVAR but always sets the value to VALUE."
  `(progn (defvar ,name nil ,doc)
		  (setq ,name ,value)))

(eval-when (compile load eval) 
  (defun jsel:symbol->reduced-form (s)
	"Convert a symbol to its reduced form.  This is the ID
operation for all symbols not containing `.` and some that do.
However, symbols of the form a.b.c are transformed into `(.. (sme
a) b c))` where `sme` indicates the static symbol macro
transformation of its argument."
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
	"T when S is an eigensymbol of `jsel:symbol->reduced-form`.
That is, when a symbol is its own reduced form."
	(and (symbolp s)
		 (eq (jsel:symbol->reduced-form s) s)))

  (defun jsel:symbol->reduced-form-or-pass (s)
	"Convert symbols to their reduced form and leave other forms unchanged."
	(if (symbolp s)
		(jsel:symbol->reduced-form s)
	  s))

  (defun-match- jsel:join (nil delim acc)
	"Join strings by delim (empty list base case)."
	acc)
  (defun-match jsel:join (elements delim)
	"Join strings by delim (entry point).  Join all the elements
in ELEMENTS into a single string, separated by DELIM."
	(recur elements delim ""))
  (defun-match jsel:join ((list hd) delim acc)
	"Join strings by delim (base case.)"
	(concat acc hd))
  (defun-match jsel:join ((list-rest hd tl) delim acc)
	"Join strings by delim (worker and recursion case.)"
	(recur tl delim (concat acc hd delim)))

  (defun jsel:expression->reduced-form (e)
	"Converts expressions to a reduced form.  For symbols this is
symbol->reduced form, for most other expressions it is the ID
operator, but this ensures expressions of the form `(.. hd s1 ...)`
properly reflect symbol macro expansion."
	(match e
		   ((symbol s)
			(jsel:symbol->reduced-form s))
		   ((list-rest (and leader '..) hd other-expressions)
			`(,leader (jsel:symbol->reduced-form-or-pass hd) ,@other-expressions))
		   (_ _)))

  (defun-match- jsel:..->symbol-for-macro-lookup ((list-rest '.. hd symbols))
	"Deprecated function for lookup of macros for dotted symbols."
	(if (not (symbolp hd))
		(gensym)
	  (intern (jsel:join (mapcar #'symbol-name (cons hd symbols)) "."))
	  ))
  (defun-match jsel:..->symbol-for-macro-lookup (_)
	"When there is no macro, return a gensym."
	(gensym)))

(defun-match- jsel:update-alist (key value nil acc)
  "Functiona alist update (base case.)"
  (reverse (cons (cons key value) acc)))

(defun-match jsel:update-alist (key value
									(list-rest (cons (equal key) old-value) rest)
									acc)
  "Functional alist update (key found base case.)"
  (append (reverse (cons (cons key value) acc)) rest))

(defun-match jsel:update-alist (key value
									(list-rest (and wrong-cell 
													(cons (not-equal key) old-value)) rest)
									acc)
  "Functional alist update non-base case."
  (recur key value rest (cons wrong-cell acc)))
(defun-match jsel:update-alist (key value alist)
  "Functional alist update (entry point.)"
  (recur key value alist nil))

(eval-when (compile load eval) 
  (defun-match- jsel:alist-has-key (key nil)
	"T when alist has a key."
	nil)
  (defun-match jsel:alist-has-key (key (list-rest (cons (equal key) value) tail))
	"T when alist has a key."
	t)
  (defun-match jsel:alist-has-key (key (list-rest (cons (not-equal key) value) tail))
	"T when alist has a key."
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
  "Alist lookup function (base case) ."
  or-value)
(defun-match jsel:alist-lookup (key (list-rest (cons (equal key) value) alist) or-value)
  "Alist lookup success case."
  value)
(defun-match jsel:alist-lookup (key (list-rest (cons (not-equal key) value) alist) or-value)
  "Alist lookup explicit failure case."
  (recur key alist or-value))
(defun-match jsel:alist-lookup (key alist)
  "Alist lookup entry point."
  (recur key alist nil))

(defun-match- jsel:alist-pages-update-or-add-to-top (key value (list) acc)
  "Update a list of alists such that the first alist containing
key is set to value, or the last alist is extended."
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
  "Take a symbol S and return the mangled version of the symbol
for transcoding.  See `match-lambda` below for a list of
manglings.  Additionally, dashed ids are replaced by camel case."
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
  "Insert a formatted string with ARGS into the current transcoding buffer."
  (insert (apply #'format fs args)))

(defun jsel:insert (fs)
  "Insert a non-formatted string."
  (insert fs))

(jsel:defvar-force-init jsel:indent-depth 0 "Variable which tracks indentation depth.")

(defun jsel:newline ()
  "Insert a newline into the transcoding buffer."
  (jsel:insertf "\n")
  (loop for i from 1 to jsel:indent-depth do
		(jsel:insert " ")))

(defmacro* jsel:with-tab+ (&body body)
  "Execute the body BODY with additional indentation."
  `(let ((jsel:indent-depth (+ jsel:indent-depth 2)))
	 (loop for i from 1 to jsel:indent-depth do
		   (jsel:insert " "))
	 ,@body))

(eval-when (compile load eval) 
  (defpattern jsel:context-agnostic (&optional sub)
	(if sub 
		`(and (or :statement :expression :either) ,sub)
	  '(or :statement :expression :either))))

(defun-match- jsel:transcode ('undefined (jsel:context-agnostic))
  "Transcode undefined."
  (jsel:insert "undefined"))

(defun-match jsel:transcode ('true (jsel:context-agnostic))
  "Transcode true."
  (jsel:insert "true"))

(defun-match jsel:transcode ('empty-object (jsel:context-agnostic))
  "Transcode the empty object."
  (jsel:insert "{}"))

(defun-match jsel:transcode ('false (jsel:context-agnostic))
  "Transcode false."
  (jsel:insert "false"))

(defun-match jsel:transcode ('null (jsel:context-agnostic))
  "Transcode null."
  (jsel:insert "null"))

(defun-match jsel:transcode ((list 'typeof expr)
							 (jsel:context-agnostic))
  (jsel:insert "(typeof ")
  (jsel:transcode expr)
  (jsel:insert ")"))

(defun-match jsel:transcode ((list 'undefined expression)
							 (and c (jsel:context-agnostic)))
  (jsel:in-parens 
   (jsel:transcode "undefined")
   (jsel:insert "===")
   (jsel:in-parens 
	(jsel:transcode `(typeof ,expression)))))

(defmacro jsel:let-if (c true-branch &optional false-branch)
  "Simple let-if macro.  Bind c to the result of the test."
  (let ((n (gensym)))
	`(let ((,n ,c))
	   (if ,n ,true-branch ,false-branch))))

(jsel:defvar-force-init jsel:*top-level-symbol-macros* (list) "Top level symbol macros.")
(jsel:defvar-force-init jsel:symbol-macro-contexts (list) "Dynamic symbol macro environment.")

(defun-match- jsel:get-symbol-macro (s nil)
  "Symbol macro lookup base case."
  (jsel:alist-lookup s jsel:*top-level-symbol-macros*))
(defun-match jsel:get-symbol-macro (s (list-rest env rest))
  "Symbol macro lookup recursion."
  (let ((expander (jsel:alist-lookup s env)))
	(if expander expander
	  (recur s rest))))
(defun-match jsel:get-symbol-macro (s)
  "Symbol macro lookup entry point."
  (recur s jsel:symbol-macro-contexts))

(defun jsel:transform-via-symbol-macro (s)
  "Take s and return its symbol macro expansion, if any."
  (let ((expander (jsel:get-symbol-macro s)))
	(if expander (funcall expander s)
	  s)))


(defun-match- jsel:extend-current-symbol-macro-context (s transformer (list))
  "Extend the current symbol macro context."
  (setf jsel:*top-level-symbol-macros* (cons (cons s transformer) jsel:*top-level-symbol-macros*)))
(defun-match jsel:extend-current-symbol-macro-context (s tranformer (list-rest context other-contexts))
  (setf jsel:symbol-macro-contexts 
		(cons (cons (cons s tranformer) context) other-contexts)))
(defun-match jsel:extend-current-symbol-macro-context (s tranformer)
  "Entry point."
  (recur s tranformer jsel:symbol-macro-contexts))

(eval-when (compile load eval) 
  (defun jsel:symbol-macro-bind->alist-entry (bind)
	"Convert a binding expression (s lambda-expression) to an alist."
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
  "Execute the body with a dynamically extended symbol macro context."
  `(let ((jsel:symbol-macro-contexts (cons ',(jsel:symbol-macro-binders->alist bindings))))
	 ,@body))

(defun-match jsel:transcode ((p #'jsel:non-keyword-symbolp s) 
							 (and context (or :statement :expression :either)))
  "Transcode a non-keyword symbol."
  (let ((s (jsel:symbol->reduced-form s))) 
	(if (symbolp s) 
		(let-if the-symbol-macro 
				(jsel:get-symbol-macro s)
				(jsel:transcode (funcall the-symbol-macro s) context) 
				(jsel:insert (jsel:mangle s)))
	  (jsel:transcode s context))))

(defun jsel:remove-colon-from-keyword (s)
  "Remove the leading : from a keyword."
  (let ((n (symbol-name s)))
	(intern (substring n 1))))

(defun-match jsel:transcode ((p #'keywordp s) (or :statement :expression :either))
  "Transcode a keyword into a string."
  (jsel:insert (concat "\"" (jsel:mangle (jsel:remove-colon-from-keyword s)) "\"")))

(defun-match jsel:transcode (_)
  "Dispatch a context agnostic transcoding into an explicitly agnostic one."
  (jsel:transcode _ :either))

(defun-match jsel:transcode ((list-rest 'symbol-macro-let bindings body)
							 (jsel:context-agnostic))
  "Transcode a symbol macro let."
  (let ((jsel:symbol-macro-contexts 
		 (cons (jsel:symbol-macro-binders->alist bindings) jsel:symbol-macro-contexts)))
	(jsel:transcode `(progn ,@body))))

(defun jsel:transcode-string (string)
  (jsel:insert "\"")
  (loop for character in (coerce string 'list) do
		(match character
			   (?\n (insert "\\n"))
			   (?\t (insert "\\t"))
			   (?\" (insert "\\\""))
			   (?\\ (insert "\\"))
			   (else (insert else))))
  (jsel:insert "\""))

(defun-match jsel:transcode ((list-rest 'symbol-macro-letq bindings body)
							 (jsel:context-agnostic))
  "Transcode a quoted symbol macro let expression.  Regular
symbol macrolet expects each value to be a compile-time function
transforming the symbol to its new value.  This expression takes
an expression to insert directly."
  (let ((jsel:symbol-macro-contexts 
		 (cons (jsel:symbol-macro-binders->alist 
				(mapcar (match-lambda 
						 ((list s e)
						  (list s `(quote ,e))))
						bindings)) jsel:symbol-macro-contexts)))
	(jsel:transcode `(progn ,@body))))


(defun-match jsel:transcode ((p #'vectorp vector-expression) (jsel:context-agnostic))
  "Transcode a vector to an array."
  (let ((elements (coerce vector-expression 'list)))
	(jsel:insert "[")
	(jsel:transcode-csvs elements)
	(jsel:insert "]")))

(defun-match jsel:transcode ((list 'var sym expr) (or :statement :either))
  "Transcode a VAR expression."
  ;;(jsel:insertf "var %s = " (jsel:transcode sym))
  (jsel:insert "var ")
  (jsel:transcode sym)
  (jsel:insert " = ")
  (jsel:transcode expr))

(defun-match jsel:transcode ((list 'var sym expr) :expression)
  "Transcode a var expression in a value context."
  (jsel:transcode `(eval (quote (var ,sym ,expr)))))

(defun-match- jsel:transcode-csvs ((list))
  "Transcode a list of expressions into a comman separated list of transcodings. (base case)"
  nil)
(defun-match jsel:transcode-csvs ((list item))
  "Transcode a list of expressions into a comman separated list of transcodings. (base case)"
  (jsel:transcode item))
(defun-match jsel:transcode-csvs ((list-rest item rest))
  "Transcode a list of expressions into a comman separated list of transcodings. (recursion case)"
  (jsel:transcode item)
  (jsel:insert ", ")
  (recur rest))

(defun-match- jsel:transcode-newline-sequence ((list))
  "Transcode a list of expressions into a transcoded, newline
  semicolon delimited list of transcodings. (base case)"  
  nil)
(defun-match jsel:transcode-newline-sequence ((list item))
  "Transcode a list of expressions into a transcoded, newline
  semicolon delimited list of transcodings. (base case)"  
  (jsel:transcode item)
  (jsel:insert ";")
  (jsel:newline))
(defun-match jsel:transcode-newline-sequence ((list-rest item rest))
  "Transcode a list of expressions into a transcoded, newline
  semicolon delimited list of transcodings. (recursion case)"  
  (jsel:transcode item)
  (jsel:insert ";")
  (jsel:newline)
  (recur rest))

(defun-match jsel:transcode ((list-rest 'splice statements)
							 (jsel:context-agnostic))
  "Transcode the STATEMENTS into the buffer as a newline
sequence, without pre or postamble."
  (jsel:transcode-newline-sequence statements))

(defun jsel:transcode-block (statements)
  "Transcode a {} block."
  (jsel:with-tab+ 
   (jsel:insert "{")
   (jsel:newline)
   (jsel:transcode-newline-sequence statements)
   (jsel:insert "}")))

(defun-match jsel:transcode ((list 'if expr true-branch false-branch) (jsel:context-agnostic))
  "Transcode an if expression."
  (jsel:insert "(")
  (jsel:transcode expr)
  (jsel:insert " ? ")
  (jsel:transcode true-branch)
  (jsel:insert " : ")
  (jsel:transcode false-branch)
  (jsel:insert ")"))

(defun-match jsel:transcode ((list 'if expr true-branch) (jsel:context-agnostic))
  "Transcode an if expression with one leg."
  (jsel:insert "(")
  (jsel:transcode expr)
  (jsel:insert " ? ")
  (jsel:transcode true-branch)
  (jsel:insert " : ")
  (jsel:transcode 'undefined)
  (jsel:insert ")"))


(defun-match jsel:transcode ((p #'numberp n) (jsel:context-agnostic))
  "Transcode a number."
  (jsel:insertf "%s" n))

(defun-match jsel:transcode ((p #'stringp str) (jsel:context-agnostic))
  "Transcode a string."
  (jsel:transcode-string str))

(defun-match jsel:transcode ((list 'return expr) (jsel:context-agnostic))
  "Transcode a return expression."
  (jsel:insert "return (")
  (jsel:transcode expr)
  (jsel:insert ")"))

(defun-match jsel:transcode ((list-rest 'primitive-for-in 
										(list (symbol index)
											  expr)
										body)
							 (jsel:context-agnostic))
  "Transcode a for-in expression (primitive)"
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
  "Transcode a for expression (primitive)"
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
  "Transcode a for-in style for loop."
  (jsel:transcode `(progn (primitive-for-in (,index ,expr) 
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
  "Transcode a for-in style loop with element binding."
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
  "Transcode a for loop style loop."
  (jsel:transcode `(progn
					 (primitive-for (,init ,condexpr ,updateexpr) ,@body))))

(defun-match jsel:transcode ((list-rest 'primitive-while condexpr body)
							 (jsel:context-agnostic))
  "Transcode a while loop. (primitive)"
  (jsel:insert "while (")
  (jsel:transcode condexpr)
  (jsel:insert ")")
  (jsel:transcode-block body))

(defun-match jsel:transcode ((list-rest 'while condexpr body) 
							 (jsel:context-agnostic))
  "Transcode a while loop."
  (jsel:transcode `(let () (primitive-while ,condexpr ,@body) undefined) :either))


(defun jsel:empty-vectorp (o)
  "T when O is an empty vector."
  (and (vectorp o)
	   (= 0 (length o))))


(defun-match jsel:transcode ((list 'primitive-setq 
								   (p #'symbolp name) 
								   expr) 
							 (jsel:context-agnostic))
  "Transcode a primitive setq."
  (jsel:transcode name)
  (jsel:insert " = (")
  (jsel:transcode expr)
  (jsel:insert ")"))

(defun jsel:single-element-vectorp (o)
  "T when o is a vector with one element."
  (and (vectorp o)
	   (= 1 (length o))))

(defun-match jsel:transcode ((list (or 'access 
									   (p #'jsel:empty-vectorp)) object expr)
							 (jsel:context-agnostic))
  "Transcode a vector access expression."
  (jsel:insert "(")
  (jsel:transcode object)
  (jsel:insert ")[")
  (jsel:transcode expr)
  (jsel:insert "]"))

(defun-match jsel:transcode ((list-rest (or 'access (p #'jsel:empty-vectorp)) object expr0 exprs)
							 (jsel:context-agnostic))
  "Transcode a vector access with multiple accesses."
  (recur `([] ([] ,object ,expr0) ,@exprs) :either))

(defun-match jsel:transcode ((list 'primitive-setq 
								   (p #'symbolp name)
								   (p #'jsel:single-element-vectorp vec)
								   expr)
							 (jsel:context-agnostic))
  "Transcode a setq with vector notation."
  (jsel:transcode name)
  (jsel:insert "[")
  (jsel:transcode (elt vec 0))
  (jsel:insert "]")
  (jsel:insert " = (")
  (jsel:transcode expr)
  (jsel:insert ")"))

(defun-match jsel:transcode ((list 'progn expr)
							 (jsel:context-agnostic c))
  (recur expr c))

(defun-match jsel:transcode ((list-rest 'progn body)
							 (jsel:context-agnostic c))
  (jsel:in-parens 
   (jsel:transcode-csvs body)))

(defun-match jsel:transcode ((list-rest 'setq args) (jsel:context-agnostic))
  "Transcode a setq expression."
  (jsel:transcode `(progn (primitive-setq ,@args) undefined)))

(defun jsel:at-sign-p (o)
  "T when o is an at sign symbol."
  (and (symbolp o)
	   (equal o (intern "@"))))

(defun-match jsel:transcode ((list-rest '.. expr symbols) (jsel:context-agnostic))
  "Transcode a .. expression to a a.b.c style expression."
  (jsel:insert "(")
  (jsel:transcode expr)
  (jsel:insert ")")
  (loop for symbol in symbols do
		(jsel:insert ".")
		(jsel:transcode symbol)))

(defun-match- jsel:split-list-at (sigil (list) acc)
  "Split a list at SIGIL. (base case)"
  (list (reverse acc) nil))

(defun-match jsel:split-list-at (sigil (list))
  (list nil nil))

(defun-match jsel:split-list-at (sigil (list-rest (equal sigil _) tl) acc)
  (list (reverse acc) tl))

(defun-match jsel:split-list-at (sigil (list-rest hd tl) acc)
  (recur sigil tl (cons hd acc)))

(defun-match jsel:split-list-at (sigil lst)
  "Split a list at SIGIL, entry point."
  (recur sigil lst nil))

(defun-match jsel:transcode ((list-rest '..* (symbol delim) arguments)
							 (and (jsel:context-agnostic) context))
  "Transcode a sugared dotted function application.  
 (..* ^ a b c ^ d e f) -> a.b.c(d,e,f) in js.  SIGIL indicates
 when you switch from object references to arguments."
  (recur 
   (match (jsel:split-list-at delim arguments)
		  ((list before after)
		   `((.. ,@before) ,@after))) context))

(defun-match jsel:transcode ((list-rest '.: arguments)
							 (and (jsel:context-agnostic) context))
  "Simplified sugared dotted function application. : is always
the sigil."
  (recur `(..* : ,@arguments) context))

(defun-match- jsel:valid-bindings (nil)
  "Detect a valid binding set.  Base case."
  t)

(defun-match jsel:valid-bindings ((list-rest (list pat expr) rest))
  "Detect if list is a valid binding expression ((s e) (s e)).
Entry point."
  (if (symbolp pat) (recur rest)
	nil))

(defun-match jsel:valid-bindings (_) 
  "Empty bindings are invalid, apparently. "
  nil)

(defun-match jsel:transcode ((list-rest 'primitive-funcall f-expression args)
							 (jsel:context-agnostic))
  "Transcode a function call. "
  (jsel:insert "((")
  (jsel:transcode f-expression)
  (jsel:insert ")(")
  (jsel:transcode-csvs args)
  (jsel:insert "))"))

(defun-match jsel:transcode ((list-rest 'let (list-rest bindings) body) 
							 (jsel:context-agnostic))
  "Transcode a let expression."
  (assert (jsel:valid-bindings bindings)
		  ()
		  "Bindings must be pattern/expression pairs.  Legal patterns are symbols.")
  (let ((args (cons 'arguments (mapcar #'car bindings)))
		(vals (cons '(if (undefined arguments) undefined arguments) 
					(mapcar #'cadr bindings))))
	(jsel:transcode `(primitive-funcall 
					  (lambda ,args ,@body)
					  ,@vals))))

(defun-match jsel:transcode ((list-rest 
							  'new 
							  (non-kw-symbol constructor)
							  arguments) 
							 (jsel:context-agnostic))
  "Transcode a new expression the second argument is the name of
the constructor."
  (jsel:insert "(new ")
  (jsel:transcode constructor)
  (jsel:insert "(")
  (jsel:transcode-csvs arguments)
  (jsel:insert "))"))

(eval-when (compile load eval) 
  (defpattern jsel:binop (&optional subsequent-pattern)
	(if subsequent-pattern
		`(and (or '&& 
				  ',(intern "||"))
			  ,subsequent-pattern)
	  `(or (or '&& 
			   ',(intern "||"))))))

(defun-match jsel:transcode ((list (jsel:binop (funcall #'symbol-name op))
								   a b)
							 (jsel:context-agnostic))
  (jsel:in-parens 
   (jsel:in-parens 
	(jsel:transcode a))
   (jsel:insert op)
   (jsel:in-parens 
	(jsel:transcode b))))

(defun-match jsel:transcode ((list-rest (jsel:binop op)
										a other-operands)
							 (and context (jsel:context-agnostic)))
  (recur `(,op a (,op ,@other-operands))
		 context))

(defun jsel:make-last-statement-a-return (list)
  "Make the last statement of something a return."
  (if (null list) (list '(return undefined))
	(let* ((rev (reverse (copy-list list)))
		   (last `(return ,(car rev)))
		   (rest (cdr rev)))
	  (reverse (cons last rest)))))

(defun-match- jsel:all-symbols (nil)
  "T when the input list is a list of symbols (or empty.) (base case)"
  t)
(defun-match jsel:all-symbols ((list-rest a rest))
  "T when the input is a list of symbols."
  (if (symbolp a) (recur rest)
	nil))

(eval-when (compile load eval) 
  (defmacro* jsel:in-parens (&body body)
	"Do the encoding represented by BODY inside parentheses."
	`(progn 
	   (jsel:insert "(")
	   ,@body
	   (jsel:insert ")"))))

(defun-match jsel:transcode ((list-rest 'lambda (list-rest arg-list) body) (jsel:context-agnostic))
  "Transcode a lambda expression.  No fancy lambda-list."
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
  "Concatenate strings with newlines."
  "")

(defun-match jsel:concat-newlines ((list) acc)
  "Concatenate strings with newlines."
  acc)

(defun-match jsel:concat-newlines ((list-rest hd tl) acc)
  "Concatenate strings with newlines."
  (recur tl (concat acc hd (format "\n"))))

(defun-match jsel:concat-newlines ((p #'listp lst))
  "Concatenate strings with newlines.  Entry point."
  (recur lst ""))

(defun-match jsel:transcode ((list-rest 'comment strings) (jsel:context-agnostic))
  "Transcode a comment, which is a form which takes a list of
strings."
  (jsel:insert (jsel:concat-newlines (append  (list "/*") strings (list "*/")))))

(defun-match jsel:transcode ((list 'function expr) (jsel:context-agnostic))
  "Transcode a #' expression into a function which accesses an
element on an object equal to the sharp quoted expression."
  (let ((arg (gensym "sharp-quote-arg-")))
	(recur `(lambda (,arg) ([] ,arg ,expr)))))

(defun-match jsel:transcode ((list 'def (p #'symbolp name) value) (jsel:context-agnostic))
  "Transcode a definition.  Normal value version."
  (jsel:transcode `(var ,name ,value)))

(defun-match- jsel:group-by-two ((and pair (list a b)) acc)
  (reverse (cons pair acc)))
(defun-match jsel:group-by-two ((and pair (list a)) acc)
  (error "Can't group a list with an odd number of elements by two."))
(defun-match jsel:group-by-two ((list-rest a b rest) acc)
  (recur rest (cons (list a b) acc)))
(defun-match jsel:group-by-two ((list))
  (list))
(defun-match jsel:group-by-two (something)
  "Transcode a list of even length into a list of lists of two
elements each, preserving order."
  (recur something nil))

(defun-match jsel:transcode ((list-rest 'defs pairs)
							 (and context (jsel:context-agnostic)))
  "Transcode multiple definitions.  Function definition not
allowed."
  (let* ((pairs (jsel:group-by-two pairs))
		 (rpairs (reverse pairs))
		 (last (car rpairs))
		 (initial-pairs (reverse (cdr rpairs)))
		 (first-pair (car initial-pairs))
		 (inner-pairs (cdr initial-pairs)))
	(jsel:transcode `(def ,@first-pair))
	(jsel:insertf ",\n")
	(jsel:with-tab+
	 (loop for (b e) in inner-pairs do
		   (jsel:transcode b)
		   (jsel:insert " = ")
		   (jsel:transcode e)
		   (jsel:insertf ",\n"))
	 (jsel:transcode (first last))
	 (jsel:insert " = ")
	 (jsel:transcode (second last))
	 (jsel:insert ";"))))

(defun-match jsel:transcode ((list-rest 'def (list-rest (p #'symbolp name) args) body) (jsel:context-agnostic))
  "Transcode a scheme-style function definition."
  (jsel:transcode `(var ,name (lambda ,args ,@body))))

(defun-match jsel:transcode ((and form (list-rest 'def (symbol s) expr something rest))
							 (jsel:context-agnostic))
  (error "Error transcoding a def form [ %S ], regular (non-function) def's can only have two forms.  
 Got %s." form (+ 3 (length rest))))

(defun-match jsel:transcode ((list-rest 'def-fun-dont-symbol-macro-expand-id 
										(list-rest (p #'symbolp name) args) body) (jsel:context-agnostic))
  "Transcode a definition without symbol-macro-expanding the name."
  (jsel:insert "var ")
  (jsel:insert (jsel:mangle name))
  (jsel:insert " = ")
  (jsel:transcode `(lambda (,@args) ,@body)))

(defun-match jsel:transcode ((list-rest 'program body) (jsel:context-agnostic))
  "Transcode a list of expressions sep by newlines."
  (jsel:transcode-newline-sequence body))

(defun-match jsel:transcode ((list 'primitive-try 
								   (list-rest body-block)
								   (list-rest 'catch (symbol s) catch-body)
								   (list-rest 'finally finally-body))
							 (jsel:context-agnostic))
  "Transcode a primitive try-catch-finally block. "
  (jsel:insert "try")
  (jsel:transcode-block body-block)
  (jsel:insert "catch (")
  (jsel:transcode s)
  (jsel:insert ")")
  (jsel:transcode-block catch-body)
  (jsel:insert "finally")
  (jsel:transcode-block finally-body))

(defun-match jsel:transcode ((list 'primitive-throw expression)
							 (jsel:context-agnostic))
  "Transcode a throw expression."
  (jsel:insert "throw ")
  (jsel:transcode expression)
  (jsel:insert ""))

(defun-match jsel:transcode ((list 'throw expression)
							 (jsel:context-agnostic c))
  (recur `(let () 
			(primitive-throw ,expression)
			undefined)
		 c))


(defun jsel:make-last-element-a-setq (target elements)
  "Take a list of elements and transform the last element so that
it `setq`s the target symbol to that element."
  (let* ((r (reverse elements))
		 (last (car r))
		 (all-but-last (cdr r))
		 (new-last `(setq ,target ,last)))
	(reverse (cons new-last all-but-last))))

(defun-match jsel:transcode ((list 'try (list-rest body-block)
								   (list-rest 'catch (symbol binding) catch-block))
							 (jsel:context-agnostic))
  "Transcode a try-catch expression."
  (let ((retval (gensym "try-retval")))
	(recur `(let ((,retval undefined)) 
			  (primitive-try ,(jsel:make-last-element-a-setq retval body-block)
							 (catch ,binding ,@catch-block)
							 (finally undefined)) 
			  ,retval))))


(defun-match jsel:transcode ((list 'try (list-rest body-block)
								   (list-rest 'finally  finally-block))
							 (jsel:context-agnostic))
  "Transcode a try-finally expression."
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
  "Transcode a try-catch-finally expression."
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
  "Transcode a try-finally-catch expression."
  (let ((retval (gensym "try-retval")))
	(recur `(let ((,retval undefined)) 
			  (primitive-try ,(jsel:make-last-element-a-setq retval body-block)
							 (catch ,binding ,@catch-block)
							 (finally ,@finally-block)) 
			  ,retval))))


(defun-match jsel:transcode ((list 'literally string)
							 (jsel:context-agnostic))
  "Insert the string into the transcoding, without
transformation."
  (jsel:insert string))

(defun-match jsel:transcode ((list (or 'instance-of
									   'instanceof) 
								   object-expr
								   class-name)
							 (jsel:context-agnostic))
  (jsel:insert "(")
  (jsel:transcode object-expr)
  (jsel:insert " instanceof ")
  (jsel:transcode class-name)
  (jsel:insert ")"))

(defun-match jsel:transcode ((list-rest 'primitive-include files)
							 (jsel:context-agnostic))
  "Insert the result of transcoding FILES into the current buffer."
  (loop for file in files do
		(jsel:transcode-file-here file (current-buffer))))

(jsel:defvar-force-init jsel:macros (make-hash-table :test 'equal)
						"JSEL macro table.")

(defun jsel:macro-symbolp (s)
  "T when S is associated with a macro binding."
  (if (symbolp s) 
	  (gethash (jsel:transform-via-symbol-macro s) jsel:macros)
	(gethash (jsel:transform-via-symbol-macro 
			  (jsel:..->symbol-for-macro-lookup s)) jsel:macros)))

(defun jsel:get-macro-expander (s)
  "Fetch the transformation function which expands the macro S."
  (jsel:macro-symbolp s))


(defun-match jsel:transcode ((list-rest 'defmacro name args body)
							 (jsel:context-agnostic))
  "Transcode a defmacro expression.  Defmacro creates a global
macro in global scope, and a local-only macro in private scope.
To create an exported macro, see defmacro-external."
  (assert (jsel:simple-symbol-p name)
		  ()
		  "Macros cannot be bound to non-simple symbols (ie,
		  symbols with . in them.)  Tried to bind to %S." name)
  (cond 
   (jsel:*module* 
	(let ((actual-name (jsel:symbol-concat jsel:*module* (intern "-") name)))
	  (let ((jsel:*module* nil)) 
		(jsel:transcode `(defmacro ,actual-name ,args ,@body)))
	  (jsel:insertf "//%S" `(defmacro ,actual-name ,args ,@body))
	  (jsel:extend-current-symbol-macro-context name (eval `(lambda (s) ',actual-name)))))
   (:otherwise 
	(let ((arg-name (gensym "macro-arg-names-")))
	  (puthash name
			   (eval `(lambda (&rest ,arg-name) 
						(destructuring-bind ,args ,arg-name ,@body)))
			   jsel:macros)))))

(defun jsel:transforms-via-symbol-macrop (s)
  "T when S would transform via symbol macro."
  (not (eq (jsel:transform-via-symbol-macro s) s)))

(defun-match jsel:transcode ((list-rest (p #'jsel:transforms-via-symbol-macrop s) arguments)
							 (and context (jsel:context-agnostic)))
  "Transform a list expression via symbol macros on its head, then transcode."
  (recur `(,(jsel:transform-via-symbol-macro s) ,@arguments)
		 context))

(defun-match jsel:transcode ((list-rest (p #'jsel:macro-symbolp dispatch-key) arguments)
							 (and context (jsel:context-agnostic)))
  "Transcode a macro expansion."
  (recur (apply (jsel:get-macro-expander dispatch-key) arguments) context))

(defmacro* jsel:defmacro (name arglist &body body)
  "Form for definiting jsel macros in elisp."
  (let ((arg-name (gensym "defmacro-args-")))
	`(puthash ',(jsel:symbol->reduced-form name) (lambda (&rest ,arg-name)
												   (destructuring-bind ,arglist ,arg-name ,@body))
			  jsel:macros)))

(jsel:defmacro let* (bindings &body body)
			   "let* for jsel."
			   (let ((expressions (mapcar #'cadr bindings))
					 (symbols (mapcar #'car bindings)))
				 `(let ,(loop for symbol in symbols collect `(,symbol undefined))
					,@(loop for (symbol expression) 
							in bindings collect `(var ,symbol ,expression))
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

(jsel:defmacro 
 object 
 (&rest kv/pairs)
 "Transcode an object literal."
 (let ((object-name (gensym "object"))
	   (pairs (jsel:bunch-by-two kv/pairs)))
   `(let ((,object-name empty-object))
	  ,@(loop for (index-expr value-expr) in pairs
			  collect `(setq ,object-name ,(vector index-expr) ,value-expr))
	  ,object-name)))

(jsel:defmacro 
 cond
 (&body body)
 "Transcode a cond expression."
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
  "Collect a list of module variable names from a module."
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
  "Collect a list of module locations."
  (recur expressions nil))

(jsel:defmacro 
 with-modules (module-spec &body body)
 "Transcode BODY in an context where MODULES are available via
MODULE-SPEC, using RJS modules.  Deprecated in favor of RJS
module support."
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
  "Add an item to the module manifest."
  (cond 
   ((eq :out-of-module jsel:*module-manifest*) (error "Cannot extend a module manifest when there is not an active module."))
   (:otherwise
	(setf jsel:*module-manifest* (cons (cons module-level-name (list type meta)) jsel:*module-manifest*)))))

(defun jsel:get-manifest-item (name manifest)
  "Fetch a manifest item by name."
  (jsel:alist-lookup name manifest))

(defun-match jsel:transcode ((list 'quote expr)
							 (jsel:context-agnostic))
  (jsel:transcode (jsel:transcode-to-string expr)))

(defun-match jsel:transcode ((list-rest 'primitive-module body)
							 (jsel:context-agnostic))
  "Transcode a primitive module.  Inside a primitive module,
def-external and defmacro-external forms extend a statically
collected manifest of exportable objects.  These cannot be used
directly via primitive modules.

See def-primitive-module."
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
  "Concat symbols."
  (intern (apply #'concat (mapcar #'symbol-name args))))

(defun-match jsel:transcode ((list 'def-external (symbol name) expression)
							 (jsel:context-agnostic))
  "Inside a module, define an external value."
  (cond 
   (jsel:*module*
	(let ((actual-name (jsel:symbol-concat jsel:*module* (intern ".") name)))
	  (jsel:extend-module-manifest name :js-value `((:module . ,jsel:*module*) (:object-type . :any)))
	  (jsel:transcode `(setq ,actual-name ,expression) :either)
	  (jsel:extend-current-symbol-macro-context name (eval `(lambda (s) ',actual-name)))))
   (:otherwise (error "jsel:transcode def-external can only be used in a module context."))))

(defun-match jsel:transcode ((list-rest 'def-external (list-rest (symbol name) arguments) body)
							 (jsel:context-agnostic))
  "Inside a module, define an external function."
  (cond 
   (jsel:*module*
	(let ((actual-name (jsel:symbol-concat jsel:*module* (intern ".") name)))
	  (jsel:extend-module-manifest name :js-value `((:module . ,jsel:*module*) (:object-type . :function)))
	  (jsel:extend-current-symbol-macro-context name (eval `(lambda (s) ',actual-name)))
	  (jsel:transcode `(setq ,actual-name (lambda (,@arguments) ,@body)))))
   (:otherwise (error "jsel:transcode def-external can only be used in a module context."))))

(defun-match jsel:transcode ((list-rest 'defmacro-external (symbol name) arguments body)
							 (jsel:context-agnostic))
  "Inside a module define an external macro."
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

(defun-match jsel:transcode ((list-rest 'def-or-def-external forms)
							 (and context (jsel:context-agnostic)))
  "Form which defines an external value when in a module, and
otherwise defines a regular value."
  (if jsel:*module*
	  (recur `(def-external ,@forms) context)
	(recur `(def ,@forms) context)))

(defun-match jsel:transcode ((list-rest 'defmacro-or-defmacro-external forms)
							 (and context (jsel:context-agnostic)))
  "Form which defines an external macro when in a module, and
otherwise defines a regular macro."
  (if jsel:*module*
	  (recur `(defmacro-external ,@forms) context)
	(recur `(defmacro ,@forms) context)))


(defun-match jsel:transcode ((list-rest 'def-primitive-module name body)
							 (jsel:context-agnostic))
  "Define a primitive module, automatically handle making macro's
defined within available as module-name.macro-name."
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
  "Transcode a function call."
  (jsel:insert "(")
  (jsel:transcode fun)
  (jsel:insert ")")
  (jsel:insert "(")
  (jsel:transcode-csvs args)
  (jsel:insert ")"))

(defun jsel:re-escape (s)
  (replace-regexp-in-string (regexp-quote "\\") "\\\\" s))

(defun jsel:read-buffer (buffer)
  "Read the contents of a buffer into an s-expression."
  (with-current-buffer buffer
	(let* ((all (buffer-substring-no-properties (point-min) (point-max)))
		   (all (concat "(" all ")")))
	  (match (read-from-string all)
			 ((cons s-expr last-index)
			  s-expr)
			 (_ (error "Some problem reading string %S." all))))))

(defun jsel:jsel-file->js-file (filename)
  "Convert a jsel file name to a js filename."
  (match filename
		 ((concat root ".jsel")
		  (concat root ".js"))
		 (_ (concat _ ".js"))))

(defun* jsel:transcode-file (file &optional (output-name nil))
  "Transcode the file FILE to its js equivalent."
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
  "Transcode the file FILE into the current buffer."
  (let* ((already-open (find-buffer-visiting file))
		 (buffer (find-file-noselect file))
		 (s-expr (jsel:read-buffer buffer)))
	(with-current-buffer output-buffer
	  (jsel:transcode (append (list 'program
									`(comment ,(concat "Include: " file))) s-expr)))))

(defun* jsel:transcode-current-buffer ()
  "Transcode the current buffer to its js equivalent file.  "
  (interactive)
  (with-current-buffer (current-buffer)
	(save-buffer)
	(jsel:transcode-file (buffer-file-name (current-buffer)))))

(defun-match- jsel:macro-expand-1 ((list-rest (p #'jsel:macro-symbolp dispatch-key) arguments))
  "Macroexpand a jsel form once."
  (apply (jsel:get-macro-expander dispatch-key) arguments))
(defun-match jsel:macro-expand-1 (_)
  "Macroexpand a jsel form once, non-macro head case."
  _)

(defun jsel:transcode-to-string (expr)
  "Transcode a JSEL expression into a string, which is returned."
  (with-temp-buffer 
	(jsel:transcode expr)
	(buffer-substring (point-min)
					  (point-max))))

(defmacro* jsel:with-gensyms (gensyms &body body)
  (match gensyms
		 ((list) `(progn ,@body))
		 ((list-rest  (symbol s) gensyms)
		  `(let ((,s (gensym (concat "jsel:auto-gensym-" (symbol-name ',s) "-"))))
			 (jsel:with-gensyms ,gensyms ,@body)))))

(provide 'jsel)

