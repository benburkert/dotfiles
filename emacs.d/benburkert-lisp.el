;; Stolen from
;; https://github.com/bodil/emacs.d/blob/master/bodil-lisp.el

(defun add-lisp-hook (func)
  (dolist (mode '(scheme emacs-lisp lisp clojure lolisp))
    (add-hook (intern (concat (symbol-name mode) "-mode-hook")) func)))

;; Paredit for all lisps
(autoload 'paredit-mode "paredit.el" nil t)
(add-lisp-hook (lambda ()
                 (paredit-mode 1)))
(add-lisp-hook (lambda ()
                 (rainbow-delimiters-mode 1)))

;; Make paredit play nice with eldoc
(eval-after-load "eldoc"
  '(eldoc-add-command
    'paredit-backward-delete
    'paredit-close-round))

;; Setup C-c v to eval whole buffer in all lisps
(define-key lisp-mode-shared-map (kbd "C-c v") 'eval-buffer)

;; Lambdas
(defun lambda-as-lambda (mode pattern)
  (font-lock-add-keywords
   mode `((,pattern
           (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                     "λ" 'decompose-region)))))))

;;; Emacs Lisp

(lambda-as-lambda 'emacs-lisp-mode "(\\(\\<lambda\\>\\)")

(defun remove-elc-on-save ()
  "If you're saving an elisp file, likely the .elc is no longer valid."
  (make-local-variable 'after-save-hook)
  (add-hook 'after-save-hook
            (lambda ()
              (if (file-exists-p (concat buffer-file-name "c"))
                  (delete-file (concat buffer-file-name "c"))))))

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'remove-elc-on-save)

(define-key emacs-lisp-mode-map (kbd "M-.") 'find-function-at-point)

;;; Clojure

(autoload 'clojure-mode "clojure-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.cljs?$" . clojure-mode))

(lambda-as-lambda 'clojure-mode "(\\(\\<fn\\>\\)")

;; For some reason paredit fails to bind paredit-backward-delete to backspace
(add-hook 'clojure-mode-hook
          (lambda () (define-key clojure-mode-map (kbd "DEL") 'paredit-backward-delete)))

;; nRepl
(autoload 'nrepl-jack-in "clojure-mode" nil t)
(eval-after-load "clojure-mode" '(require 'nrepl))
;; (setq nrepl-lein-command "bin/lein")
;; (setq nrepl-server-command "echo \"lein repl :headless\" | $SHELL -l")
(setq nrepl-tab-command 'indent-for-tab-command)
(setq nrepl-popup-stacktraces nil)

(add-to-list 'same-window-buffer-names "*nrepl*")
(add-hook 'nrepl-mode-hook 'subword-mode)
(add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)

;; Run tests in nRepl
(defun nrepl-run-tests (ns)
  (interactive (list (nrepl-current-ns)))
  (save-buffer)
  (nrepl-load-current-buffer)
  (with-current-buffer "*nrepl*"
    (nrepl-send-string
     (format "(clojure.test/run-tests '%s)" ns)
     nrepl-buffer-ns (nrepl-handler (current-buffer)))))
(eval-after-load "clojure-mode"
  '(define-key clojure-mode-map (kbd "C-c C-,") 'nrepl-run-tests))

;;Kibit

(require 'compile)
(add-to-list 'compilation-error-regexp-alist-alist
         '(kibit "At \\([^:]+\\):\\([[:digit:]]+\\):" 1 2 nil 0))
(add-to-list 'compilation-error-regexp-alist 'kibit)

(defun kibit ()
  "Run kibit on the current project.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile "lein kibit"))

;;; Lolisp

(define-derived-mode lolisp-mode scheme-mode "Lolisp")
(add-to-list 'auto-mode-alist '("\\.loli$" . lolisp-mode))

(lambda-as-lambda 'lolisp-mode "(\\(\\<lambda\\>\\)")


;;; Various inferior lisps

;; ClojureScript REPL
(defun clojurescript-repl ()
  (interactive)
  (run-lisp "/home/bodil/workspace/clojurescript/script/repl"))
(defun clojurescript-replnode ()
  (interactive)
  (run-lisp "/home/bodil/workspace/clojurescript/script/replnode"))

;; Clojure-Py REPL
(defun clojurepy-repl ()
  (interactive)
  (run-lisp "/usr/local/bin/clojurepy"))

;; Datomic REPL
(defun datomic-repl ()
  (interactive)
  (let ((datomic-path "/home/bodil/datomic/"))
    (let ((classpath
           (let ((classpath
                  (shell-command-to-string
                   (concat datomic-path "bin/classpath"))))
             (replace-regexp-in-string
              "\n" ""
              (mapconcat
               'identity
               (mapcan (lambda (i) (file-expand-wildcards
                               (concat datomic-path i)))
                       (split-string classpath ":")) ":")))))
      (run-lisp (concat "java -server -Xmx1g -cp "
                        classpath
                        " clojure.main -i "
                        datomic-path
                        "bin/bridge.clj -r")))))
