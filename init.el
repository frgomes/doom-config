;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a link to Doom's Module Index where all
;;      of our modules are listed, including what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

;; Dark screen as soon as possible
(add-to-list 'default-frame-alist '(background-color . "#202020"))
(add-to-list 'default-frame-alist '(foreground-color . "#FFFFFF"))

(doom! :input
       ;;bidi
       ;;chinese
       ;;japanese
       ;;layout

       :completion
       company
       ;;(corfu +orderless)
       ;;helm
       ;;ido
       ivy
       ;;vertico

       :ui
       ;;deft
       doom
       ;;doom-dashboard
       ;;doom-quit
       (emoji +unicode)
       hl-todo
       hydra
       ;;indent-guides
       ;;ligatures
       minimap
       modeline
       ;;nav-flash
       ;;neotree
       ophints
       (popup +defaults)
       ;;tabs

       ;;ATTENTION: remember to run command: nerd-fonts-install-icons when first start Emacs after doom sync
       (treemacs +nerd-icons)

       unicode
       (vc-gutter +pretty)
       vi-tilde-fringe
       ;;window-select
       workspaces
       ;;zen

       :editor
       ;;(evil +everywhere)
       file-templates
       fold
       ;;(format +onsave)
       ;;god
       ;;lispy
       multiple-cursors
       ;;objed
       ;;parinfer
       ;;rotate-text
       snippets
       word-wrap

       :emacs
       dired
       electric
       ;;ibuffer
       undo
       vc

       :term
       ;;eshell
       shell
       ;;term
       vterm

       :checkers
       syntax
       (spell +flyspell)
       grammar

       :tools
       ;;ansible
       ;;biblio
       ;;collab
       ;;debugger
       ;;direnv
       ;;docker
       editorconfig
       ;;ein
       (eval +overlay)
       lookup
       (lsp +eglot)
       magit
       ;;make
       pass
       ;;pdf
       ;;prodigy
       ;;rgb
       ;;taskrunner
       ;;terraform
       ;;tmux
       tree-sitter
       ;;upload

       :os
       (:if (featurep :system 'macos) macos)
       ;;tty

       :lang
       ;;agda
       ;;beancount
       ;;(cc +lsp +tree-sitter)
       ;;clojure
       ;;common-lisp
       ;;coq
       ;;crystal
       ;;csharp
       data
       ;;(dart +flutter)
       ;;dhall
       ;;elixir
       ;;elm
       emacs-lisp
       ;;erlang
       ;;ess
       ;;factor
       ;;faust
       ;;fortran
       ;;fsharp
       ;;fstar
       ;;gdscript
       ;;(go +lsp +tree-sitter)
       ;;(graphql +lsp +tree-sitter)
       ;;(haskell +lsp +tree-sitter)
       ;;hy
       ;;idris
       json
       (java +lsp +tree-sitter)
       (javascript +lsp +tree-sitter)
       (typescript +lsp +tree-sitter)
       ;;julia
       kotlin
       latex
       ;;lean
       ;;ledger
       ;;lua
       markdown
       ;;nim
       ;;nix
       ;;ocaml
       org
       ;;php
       ;;plantuml
       ;;purescript
       python
       ;;qt
       ;;racket
       ;;raku
       rest
       rst
       ;;(ruby +rails)
       (rust +lsp +tree-sitter)
       (scala +lsp +tree-sitter)
       (scheme +guile)
       sh
       ;;sml
       ;;solidity
       ;;swift
       ;;terra
       (web +html +css +lsp +tree-sitter)
       yaml
       ;;zig

       :email
       ;;(mu4e +org +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       (calendar +gcal)
       ;;emms
       ;;everywhere
       ;;irc
       ;;(rss +org)
       ;;twitter

       :config
       ;;literate
       (default +bindings +smartparens))

;; if you want to change prefix for lsp-mode keybindings.
;(setq lsp-keymap-prefix "s-l")

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(cua-selection-mode t)
(global-set-key (kbd "C-M-<return>") 'cua-rectangle-mark-mode)
(global-set-key (kbd "C-` <return>") 'mc/edit-lines)
(global-set-key (kbd "C-` <right>")  'mc/mark-next-like-this)
(global-set-key (kbd "C-` <left>")   'mc/mark-previous-like-this)
(global-set-key (kbd "C-` <return>") 'mc/mark-all-like-this)
(global-set-key (kbd "C-` /")        'mc/mark-sgml-tag-pair)
(global-set-key (kbd "C-` <SPC>")    'mc/vertical-align-with-spaces)
