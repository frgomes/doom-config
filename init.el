;;; init.el -*- lexical-binding: t; -*-

;; Dark screen as soon as possible
(add-to-list 'default-frame-alist '(background-color . "#202020"))
(add-to-list 'default-frame-alist '(foreground-color . "#FFFFFF"))

(doom! :input
       ;;layout

       :completion
       company           ; The standard for auto-completion
       (vertico          ; Modern completion UI (Replaces Ivy)
        +icons           ; Better visual feedback
        +nerd-icons)     ; Best for Plasma 6 / Wayland stability

       :ui
       doom              ; Standard Doom look
       (emoji +unicode)  ; Required for modern text processing
       hl-todo           ; Highlight TODO/FIXME in your code
       hydra             ; Great for complex keybinding chains
       minimap           ; Useful for navigating large data scripts
       modeline          ; Lean bottom bar
       ophints           ; Operator hints
       (popup +defaults) ; Smart window management
       (treemacs +nerd-icons) ; Modern sidebar with Nerd Font support
       unicode           ; Display math/foreign symbols correctly
       (vc-gutter +pretty) ; Git status in the fringe
       vi-tilde-fringe   ; Visual end-of-file indicators
       workspaces        ; Keep Finance/AI projects separated

       :editor
       file-templates    ; Auto-populate new .py or .rs files
       fold              ; Code folding for long data structures
       multiple-cursors  ; Mass editing (replaces your manual binds)
       snippets          ; Code expansion
       word-wrap         ; Better for documentation/markdown

       :emacs
       dired             ; Powerful file manager
       electric          ; Smart indentation
       undo              ; Never lose your history
       vc                ; Version control integration

       :term
       vterm             ; The fastest terminal for Linux/openSUSE

       :checkers
       syntax            ; Flycheck for on-the-fly errors
       (spell +flyspell) ; Spell checking
       grammar           ; Writing assistance

       :tools
       editorconfig      ; Standardize spacing across projects
       (eval +overlay)   ; Run code snippets and see results in-line
       lookup            ; SPC s ... (The engine for your search tools)
       (lsp +eglot)      ; Lean LSP (Built-in to Emacs 29+, very stable)
       magit             ; The best Git interface ever made
       pass              ; Password management
       tree-sitter       ; Modern, fast syntax highlighting

       :os
       (:if (featurep :system 'macos) macos)

       :lang
       data              ; CSV, XML, etc.
       emacs-lisp        ; For editing this config
       json              ; Essential for web and data APIs
       (java +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (typescript +lsp +tree-sitter)
       markdown          ; READMEs and documentation
       (org +roam2)      ; For your "Critical Thinking" knowledge base
       python            ; Your financial scripting environment
       rest              ; Test HTTP APIs
       (rust +lsp +tree-sitter) ; Your backtesting engine
       (scala +lsp +tree-sitter)
       sh                ; Shell scripting
       (web +html +css +lsp +tree-sitter)
       yaml              ; Configuration files

       :config
       (default +bindings +smartparens))

;; --- Custom Keybindings & Settings ---

;; Scale text (useful for screen sharing or large monitors)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Native Multiple Cursors Binds (Doom Way)
;; The module already provides SPC e m, but these match your style:
(cua-selection-mode t)
(global-set-key (kbd "C-M-<return>") 'cua-rectangle-mark-mode)


;; --- Post-Installation Steps ---
;; 1. Run 'doom sync' in your terminal.
;; 2. Open Emacs and run 'M-x nerd-icons-install-fonts'.
;; 3. Ensure 'ripgrep' is installed on openSUSE: 'sudo zypper in ripgrep'.
