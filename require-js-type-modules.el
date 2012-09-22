(require 'jsel)

(eval-when (compile load eval) 
  (require 'shadchen))

(jsel:defvar-force-init jsel:*require-js-project-root* nil)
(jsel:defvar-force-init jsel:*rjs-module-manifests* (make-hash-table :test 'equal))
(jsel:defvar-force-init jsel:*rjs-module* nil)


(defun jsel:get-directory (the-directory)
  (interactive "D")
  the-directory)

(defun jsel:get-require-js-project-root ()
  (if jsel:*require-js-project-root* jsel:*require-js-project-root*
	(let ((dir (file-truename (call-interactively #'jsel:get-directory))))
	  (setq jsel:*require-js-project-root* dir)
	  dir)))

(defun jsel:requirement->module-file (r)
  (file-truename 
   (concat 
	(jsel:get-require-js-project-root) 
	"/scripts/" 
	(symbol-name (jsel:require-form->module-id r)) ".jsel")))

(defun jsel:compile-rjs-module (symbolic-id)
  (let* ((file (jsel:requirement->module-file symbolic-id))
		 (file-open-already (find-buffer-visiting file))
		 (buffer (find-file-noselect file))
		 (contents (jsel:read-buffer buffer))
		 (jsel:*rjs-module* symbolic-id)
		 (output-name (jsel:jsel-file->js-file file)))
	(message "bound")
	(assert (and (= (length contents) 1)
				 (equal (car (car contents)) 'rjs-module))
			()
			"An rjs-module must consist of a single rjs-module form.  Got forms: %S." contents)
	(with-current-buffer (find-file-noselect output-name)
	  (delete-region (point-min) (point-max))
	  (jsel:transcode (car contents))
	  (save-buffer))
	(message "post transcode")
	(if (not file-open-already)
		(kill-buffer buffer))
	(setf (gethash symbolic-id jsel:*rjs-module-manifests*) jsel:last-manifest)
	jsel:last-manifest))


(defun jsel:get-rjs-manifest (symbolic-module-indicator)
  (let ((manifest (gethash symbolic-module-indicator jsel:*rjs-module-manifests*)))
	(if manifest manifest
	  (progn 
		(jsel:compile-rjs-module symbolic-module-indicator)
		(jsel:get-rjs-manifest symbolic-module-indicator)))))

(defun jsel:rjs-file->symbolic-id (file)
  (match (file-truename file)
		 ((concat (equal (concat (jsel:get-require-js-project-root) "/scripts/")) id ".js")
		  id)))

(defun jsel:require-form->module-id (require-form)
  (match require-form
		 ((symbol it) it)
		 ((list-rest id args) id)))

(defun jsel:require-form->local-name (require-form)
  (match require-form 
		 ((or (symbol it)
			  (list it :using (list-rest _)))
		  it)
		 ((list mod-id :as (symbol local-name))
		  local-name)
		 ((list mod-id :using (list-rest _) :as (symbol local-name))
		  local-name)
		 ((list mod-id :as (symbol local-name) :using (list-rest _))
		  local-name)
		 (_ (error "Malformed rjs-module require form: %S." require-form))))

(defun jsel:require-form-has-local-name-p (require-form)
  (match require-form 
		 ((or (symbol it)
			  (list mod-if :using (list-rest _))) 
		  nil)
		 ((list mod-id :as (symbol local-name))
		  local-name)
		 ((list mod-id :using (list-rest _) :as (symbol local-name))
		  local-name)
		 ((list mod-id :as (symbol local-name) :using (list-rest _))
		  local-name)
		 (_ (error "Malformed rjs-module require form: %S." require-form))))

(defun jsel:require-form->using-symbols (require-form)
  (match require-form 
		 ((symbol it) nil)
		 ((list mod-id :using (list-rest symbols))
		  symbols)
		 ((list mod-id :as (symbol local-name))
		  nil)
		 ((list mod-id :using (list-rest symbols) :as (symbol local-name))
		  symbols)
		 ((list mod-id :as (symbol local-name) :using (list-rest symbols))
		  symbols)
		 (_ (error "Malformed rjs-module require form: %S." require-form))))

(defun jsel:manifest->name-list (manifest)
  (loop for item in manifest collect
		(match item 
			   ((list name type meta)
				name))))

(defun-match- jsel:all-a-in-b ((list) b test)
  t)
(defun-match jsel:all-a-in-b ((list-rest s rest) (list-rest b) test)
  (if (funcall test s b)
	  (recur rest b test)
	`(fail ,s)))
(defun-match jsel:all-a-in-b (l1 l2)
  (recur l1 l2 #'member))

(defun-match- jsel:using-member (el (list))
  nil)

(defun-match jsel:using-member (el (list-rest (equal el) rest))
  el)

(defun-match jsel:using-member (el (list-rest (and (list (equal el) as)
												   this) rest))
  this)

(defun-match jsel:using-member (el (list-rest _ rest))
  (recur el rest))

(defun jsel:using-lookup-as (el using)
  (let-if result (jsel:using-member el using)
		  (match result
				 ((symbol s) s)
				 ((list (symbol _)
						(symbol s))
				  s))))

(defun jsel:using-name-part (s)
  (match s 
		 ((symbol s)
		  s)
		 ((list n s)
		  n)))



(defun jsel:check-require-uses-exported-symbols (req-form manifest)
  (match (jsel:all-a-in-b (mapcar #'jsel:using-name-part (jsel:require-form->using-symbols req-form))
						  (jsel:manifest->name-list manifest))
		 ((equal t) t)
		 ((list 'fail on)
		  (error "While compiling module `%S` tried to use symbol
		  `%S` which is not exported by module `%S`."
				 jsel:*rjs-module*
				 on
				 (jsel:require-form->module-id req-form)))))

(defun jsel:get-actual-name (alist)
  (jsel:alist-lookup :actual-name alist))

(defun jsel:collect-static-bindings (req-form manifest)
  (let ((using-form (jsel:require-form->using-symbols
					 req-form))
		(local-name (jsel:require-form->local-name 
					 req-form))
		(mod-id (jsel:require-form->module-id 
				 req-form))) 
	(loop for item in manifest append 
		  (match item 
				 ((list name :macro (funcall #'jsel:get-actual-name actual-name))
				  (let ((used-as (jsel:using-lookup-as name using-form))
						(dotted-name
						 (jsel:symbol-concat 
						  local-name
						  (intern ".")
						  name)))
					(append 
					 (list 
					  (list dotted-name actual-name)
					  )
					 (if used-as
						 (list (list used-as actual-name))
					   nil))))
				 ((list name :js-value meta)
				  (let ((used-as (jsel:using-lookup-as name using-form)))
					(if used-as 
						(list (list used-as 
									(jsel:symbol-concat 
									 local-name
									 (intern ".")
									 name)))
					  (list))))
				 (_ (list))))))


(defun jsel:require^manifest->symbol-macros (req manifest)
  (jsel:check-require-uses-exported-symbols req manifest)
  (jsel:collect-static-bindings req manifest))

(defun jsel:require-forms^manifests->symbol-macros 
  (reqs manifests)
  (loop for r in reqs and
		m in manifests append
		(jsel:require^manifest->symbol-macros r m)))

(jsel:defmacro 
 rjs-module (requirements &body body)
 (message "in macro")
 (if jsel:*rjs-module*
	 (let* ((module-files (mapcar #'jsel:requirement->module-file requirements))
			(module-ids (mapcar #'jsel:require-form->module-id requirements))
			(local-names (mapcar #'jsel:require-form->local-name requirements))
			(manifests (mapcar* 
							   #'jsel:compile-rjs-module
							   module-ids))
			(jsel:*rjs-module* nil)
			(symbol-macro-binds 
			 (jsel:require-forms^manifests->symbol-macros requirements manifests)))
	   (message "at least manifest %S" symbol-macro-binds)
	   (let ((output `(define [,@(mapcar #'symbol-name module-ids)] 
						(lambda ,local-names
						  (symbol-macro-letq ,symbol-macro-binds
											 (primitive-module ,@body))))))
		 (message "%S" output)
		 output))
   (error "RJS-Module only works in an rjs module file.")))

(jsel:defmacro 
 rjs-require (requirements &body body)
(let* ((module-files (mapcar #'jsel:requirement->module-file requirements))
				 (module-ids (mapcar #'jsel:require-form->module-id requirements))
				 (local-names (mapcar #'jsel:require-form->local-name requirements))
				 (manifests (mapcar* 
							 #'jsel:compile-rjs-module
							 module-ids))
				 (symbol-macro-binds 
				  (jsel:require-forms^manifests->symbol-macros requirements manifests)))
			(let ((output `(require [,@(mapcar #'symbol-name module-ids)] 
							 (lambda ,local-names
							   (symbol-macro-letq ,symbol-macro-binds
												  ,@body)))))
			  output)))




