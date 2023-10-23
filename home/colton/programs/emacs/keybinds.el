(define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)

(require 'evil)
(require 'treemacs-evil)

; settings
(setq evil-symbol-word-search t)

; TODO: would be super cool to define helix-editor's normal state.
; see evil-define-motion and evil-define-state

;; leader key
(evil-set-leader 'normal (kbd "SPC"))

;; (evil-define-key 'normal 'global
  ;; (kbd "<leader>ff") nil ; file find
  ;; (kbd "<leader>po") nil ; project open
  ;; (kbd "<leader>to") nil ; tab other
  ;; (kbd "<leader>wo") nil ; window other
  ;; )

;; local leader key
; TODO: maybe this should trigger a state instead?
; TODO: i definitely want structured editing - this should be impl'd with evil-define-motion
(evil-set-leader 'normal (kbd "C-SPC") t)

(evil-mode 1)
