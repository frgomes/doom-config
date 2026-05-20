;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; --- UI & Fonts ---
;; Optimized for Plasma 6 Nerd Fonts
(package! unicode-fonts)

;; --- Diagrams and Charts ---
;;(package! vega-view
;;  :recipe (:host github :repo "applied-science/emacs-vega-view"))

;; --- AI & LLM Tools ---
;; Note: Ensure 'aider' and 'claude-code' binaries are in your openSUSE $PATH
(package! claude-code-ide
  :recipe (:host github :repo "manzaltu/claude-code-ide.el"))
;; Optional: Uncomment if you decide to use Aider or Ollama
;; (package! aidermacs)

;; --- Knowledge Management & Contacts ---
(package! org-vcard)  ; vCard import/export
(package! ebdb)       ; Modern contact database
(package! org-caldav) ; Sync with your Google/Nextcloud calendars
(package! org-kanban) ; Visualizing your project tasks

;; --- Org-Roam UI ---
;; We only need to declare the UI; the base org-roam is handled by (org +roam2) in init.el
(package! org-roam-ui
  :recipe (:host github :repo "org-roam/org-roam-ui"))
(package! polymode)
(package! poly-markdown)

;; --- Search & Refactor ---
;; This provides the 'rg' command and the wgrep-compatible search buffer
(package! rg)

;; --- Unpinning Logic ---
;; Use this only if a Doom-pinned version is broken on your rolling release.
;; (unpin! org-roam)
