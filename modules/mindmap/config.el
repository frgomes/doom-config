;; -*- lexical-binding: t; -*-
;;; mindmap.el - Mind mapping configuration

;; org-mind-map configuration
(after! org-mind-map
  (setq org-mind-map-engine "dot")  ; GraphViz engine
  (setq org-mind-map-include-local-tags t)
  (setq org-mind-map-export-dir "~/Documents/org/mindmaps/")

  ;; Custom colors for TODO states
  (setq org-mind-map-todo-colors
        '(("TODO" . "#ff6b6b")
          ("NEXT" . "#4ecdc4")
          ("IN-PROGRESS" . "#45b7d1")
          ("DONE" . "#95e77e")
          ("WAITING" . "#ffe66d")
          ("CANCELLED" . "#95a5a6")))

  ;; Node colors by level
  (setq org-mind-map-node-level-colors
        '("#3498db"  ; Level 1
          "#2ecc71"  ; Level 2
          "#e74c3c"  ; Level 3
          "#f39c12"  ; Level 4
          "#9b59b6"  ; Level 5
          "#1abc9c"  ; Level 6
          "#34495e")) ; Level 7+

  ;; Export formats
  (setq org-mind-map-default-extension ".png")
  (setq org-mind-map-graphviz-args '("-Gcharset=utf-8" "-Gdpi=300"))

  ;; Auto-open generated mind maps
  (setq org-mind-map-auto-open nil))

;; Ensure Graphviz is installed
(unless (executable-find "dot")
  (message "Graphviz 'dot' not found. Install it for mind map generation.")
  (message "On Ubuntu/Debian: sudo apt install graphviz")
  (message "On macOS: brew install graphviz"))

;; Keybindings for mind mapping
(map! :leader
      (:prefix ("m" . "mindmap")
       :desc "Generate Mind Map" "g" #'org-mind-map
       :desc "Export to PNG" "p" #'org-mind-map-export-png
       :desc "Export to SVG" "s" #'org-mind-map-export-svg
       :desc "Export to PDF" "d" #'org-mind-map-export-pdf
       :desc "Open Mindmaps Dir" "o" (lambda () (interactive) (find-file "~/Documents/org/mindmaps/"))))

;; Hook for mind map generation
(add-hook! 'org-mode-hook
  (defun my/org-mind-map-keywords ()
    "Add mind map keywords"
    (setq-local org-mind-map--default-keywords
                '("PROJECT" "IDEA" "NOTE" "TASK" "GOAL" "CONCEPT"))))