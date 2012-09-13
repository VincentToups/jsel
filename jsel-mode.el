(provide 'jsel-mode)

(defvar jsel-syntax-table (make-syntax-table emacs-lisp-mode-syntax-table))
(defvar jsel-mode-map (copy-keymap lisp-mode-map))
(defun jsel-mode ()
  "JSEL-mode"
  (interactive)
  (kill-all-local-variables)
  (emacs-lisp-mode)
  (eldoc-mode nil)
  (set-syntax-table jsel-syntax-table)
  (use-local-map jsel-mode-map)
  (set (make-local-variable 'font-lock-defaults) '(lisp-font-lock-keywords lisp-font-lock-keywords-1))
  (setq major-mode 'jsel-mode)
  (setq mode-name "JSEL")
  (run-hooks 'jsel-mode-hook)
  (local-set-key (kbd "C-c C-c") #'jsel:transcode-current-buffer))

(add-to-list 'auto-mode-alist '("\\.jsel" . jsel-mode))

