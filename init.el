(require 'shadchen)
(defun jsel:pwd ()
  (file-truename 
   (match (pwd)
		  ((concat "Directory " dir)
		   dir))))
(setq load-path
	  (cons (jsel:pwd) load-path))

(require 'jsel)
(require 'jsel-mode)

