(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(defvar my-packages '(
  starter-kit
  starter-kit-bindings
  starter-kit-lisp
  starter-kit-ruby
  clojure-mode
  clojure-test-mode
  markdown-mode
  puppet-mode
  nrepl
  paredit
  textmate
  color-theme-solarized))

(dolist (pkg my-packages)
  (when (not (package-installed-p pkg))
    (package-install pkg)))

(load-theme 'solarized-dark t)

(textmate-mode)

(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode))
(add-to-list 'auto-mode-alist '("\\.pp\\'" . puppet-mode))

(setq show-trailing-whitespace t)
(setq require-final-newline t)

(setq ruby-insert-encoding-magic-comment nil)

;; Add .emacs.d to load-path
(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))
(add-to-list 'load-path dotfiles-dir)

(load "benburkert-lisp.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
