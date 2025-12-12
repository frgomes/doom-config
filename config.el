;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(use-package! unicode-fonts
  :config
  (unicode-fonts-setup))
(set-fontset-font t 'unicode "Noto Color Emoji" nil 'append)


;; Metals requires Java17 but user projects may require older versions of Java.
;; More info: https://github.com/scalameta/metals/issues/6952
;; Below we configure Metals globally so that it assumes that Java11 is a good choice
;; for all projects. This is probaly a bad idea. I guess that a better choice would be
;; retrieving the desired JDK version from every project, from its build.sbt. 
(after! scala
  (setq lsp-metals-java-home "~/tools/jdk-11")) ;; this is a symlink to the actual JDK


;;;; integrate with aider https://github.com/MatthewZMD/aidermacs
;;(use-package! aidermacs
;;  :defer
;;  :bind (("C-c c a" . aidermacs-transient-menu))
;;  :config
;;  (aidermacs-setup-minor-mode)
;;  ;; (setenv "OPENAI_API_KEY" (password-store-get "z.ai/rgomes"))
;;  :custom
;;  ;; (aidermacs-comint-mode)
;;  ;; (aidermacs-default-model "openrouter/deepseek/deepseek-r1:free")
;;  ;; (aidermacs-default-editor-model "openrouter/qwen/qwen3-coder:free")
;;  (aidermacs-default-chat-mode 'code)
;;  (aidermacs-use-architect-mode t)
;;)


(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools

;;; Second Brain Configuration
;; Load secret configuration (contains credentials)
(when (file-exists-p! "secret.el" doom-user-dir)
  (load! "secret"))

;; Load module configurations
(load! "modules/contacts/config")
(load! "modules/calendar/config")
(load! "modules/kanban/config")
(load! "modules/mindmap/config")
(load! "modules/roam/config")
(load! "modules/hydra/config")  ; NEW: Hydra menu system

;; Org-roam keybindings (C-c n prefix)
(global-set-key (kbd "C-c n f") 'org-roam-node-find)      ; Find node
(global-set-key (kbd "C-c n i") 'org-roam-node-insert)    ; Insert link
(global-set-key (kbd "C-c n b") 'org-roam-buffer-toggle)  ; Toggle backlinks
(global-set-key (kbd "C-c n g") 'org-roam-graph)          ; Graph view
(global-set-key (kbd "C-c n a") 'org-roam-alias-add)      ; Add alias
(global-set-key (kbd "C-c n d") 'org-roam-dailies-goto-date)       ; Daily note
(global-set-key (kbd "C-c n t") 'org-roam-dailies-capture-today)   ; Today's note
(global-set-key (kbd "C-c n c") 'org-roam-capture)         ; Quick capture
