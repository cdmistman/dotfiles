; plugins
(require 'flycheck)
(require 'lsp-treemacs)
(require 'lsp-ui)
(require 'helm-lsp)

(require 'lsp-mode)
(require 'treesit)

(setq treesit-extra-load-path `(,nixpkgs/tree-sitter-dir))
(setq lsp-bash--bash-ls-server-command `(,nixpkgs/bash-language-server "start"))
(setq lsp-clients--clangd-command `(,nixpkgs/clangd))
(setq lsp-clients-typescript-tls-path `(,nixpkgs/typescript-language-server "--stdio"))
(setq lsp-clients-typescript-project-ts-server-path (path/join nixpkgs/typescript "lib" "node_modules" "typescript" "lib"))
(setq lsp-css--server-command `(,nixpkgs/vscode-css-language-server "--stdio"))
(setq lsp-eslint-server-command `(,nixpkgs/vscode-eslint-language-server "--stdio"))
(setq lsp-go-gopls-server-path nixpkgs/gopls)
; TODO: graphql lsp doesn't support custom server path
; TODO: html lsp doesn't support custom server path
; TODO: json lsp doesn't support custom server path
; TODO: markdown lsp doesn't support custom server path
(setq lsp-rust-analyzer-server-command `(,nixpkgs/rust-analyzer))
; TODO: svelte lsp doesn't support custom server path

(lsp-treemacs-sync-mode 1)

(defun override--treesit (mode-prefix &optional override-mode)
  "Override a given mode with a treesit mode."
  (let* ((mode-prefix-str (symbol-name mode-prefix))
         (old-mode (intern (concat mode-prefix-str "-mode")))
         (new-mode (if override-mode
                        override-mode
                       (intern (concat mode-prefix-str "-ts-mode")))))
    (add-to-list 'major-mode-remap-alist `(,old-mode . ,new-mode))))

;; bash
(add-hook 'sh-mode-hook 'lsp-deferred)

;; c
(override--treesit 'c)
(add-hook 'c-ts-mode-hook 'lsp-deferred)

;; c++
(override--treesit 'c++)
(add-hook 'c++-ts-mode-hook 'lsp-deferred)

(override--treesit 'c-or-c++)
(add-hook 'c-or-c++-ts-mode-hook 'lsp-deferred)

;; csharp
(override--treesit 'csharp)

;; css
(override--treesit 'css)
(add-hook 'css-ts-mode-hook 'lsp-deferred)
(add-hook 'less-ts-mode-hook 'lsp-deferred)
(add-hook 'scss-mode-hook 'lsp-deferred)

;; docker
(require 'dockerfile-mode)
(override--treesit 'dockerfile)

;; go
(override--treesit 'go)
(add-hook 'go-ts-mode-hook 'lsp-deferred)

;; graphql
(require 'graphql-mode)

;; html
(autoload 'html-ts-mode (path/join user-emacs-directory "languages" "html") nil t)
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-ts-mode))

;; java
(override--treesit 'java)

;; javascript
(override--treesit 'js)
(add-hook 'js-ts-mode-hook 'lsp-deferred)

;; json
(override--treesit 'json)

;; lisps
(require 'paredit)

;; nix
; (require 'nix)
(require 'nix-mode)
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection `(,nixpkgs/nixd))
                  :major-modes '(nix-mode)
                  :initialized-fn (lambda (workspace)
                    (with-lsp-workspace workspace
                      (lsp--set-configuration
                       (lsp-configuration-section "nixd"))))
                  :synchronize-sections '("nixd")
                  :server-id 'nix-nixd))

;; python
(override--treesit 'python)

;; ruby
(override--treesit 'ruby)

;; rust
(override--treesit 'rust)
(add-hook 'rust-ts-mode-hook 'lsp-deferred)

;; svelte
(require 'svelte-mode)
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-mode))
(setq svelte-display-submode-name t)

;; typescript
(add-hook 'typescript-ts-mode-hook 'lsp-deferred)
;; (setq svelte--typescript-submode 'typescript-ts-mode)
(defun svelte--load-typescript-submode ()
  "Load `typescript-mode' and patch it."
  (when (require 'typescript-ts-mode nil t)
    (customize-set-variable 'typescript-indent-level svelte-basic-offset)
    (defconst svelte--typescript-submode
      (svelte--construct-submode 'typescript-mode
                                 :name "TypeScript"
                                 :end-tag "</script>"
                                 :syntax-table typescript-mode-syntax-table
                                 :propertize #'typescript-syntax-propertize
                                 :indent-function #'js-indent-line
                                 :keymap typescript-mode-map))))
