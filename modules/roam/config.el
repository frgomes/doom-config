;;; roam/config.el --- org-roam configuration -*- lexical-binding: t; -*-

(after! org-roam
  ;; Set roam directory
  (setq org-roam-directory (file-truename "~/Documents/org/roam"))

  ;; Database location
  (setq org-roam-db-location "~/Documents/org/roam/db.sqlite3")

  ;; Daily notes template
  (setq org-roam-dailies-directory (file-truename "~/Documents/org/roam/dailies"))

  ;; Create directories if they don't exist
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))

  (unless (file-exists-p org-roam-dailies-directory)
    (make-directory org-roam-dailies-directory t))

  ;; org-roam-ui integration (optional)
  (when (featurep 'org-roam-ui)
    (setq org-roam-ui-open-on-start t))

  ;; Custom capture templates for roam
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?")
          ("r" "reference" plain "%?"
           :target (file+head "refs/${slug}" "%^{title}\n%U\n%a\n%+")
           :immediate-finish t
           :unnarrowed t)
          ("m" "meeting" entry "* %^{meeting-title}\n%U\n%?"
           :target (file+head "meetings/${slug}" "%^{meeting-title}\n"))
          ("p" "project" entry "* %^{project-title}\n%U\n%?"
           :target (file+head "projects/${slug}" "%^{project-title}\n")))))

(after! org-roam-dailies
  ;; Configure dailies
  (org-roam-dailies-autorename)
  (setq org-roam-dailies-capture-templates
        '(("d" "daily" entry "* %<%Y-%m-%d>\n%?%U")
          ("t" "task" entry "* TODO %?\n%U\n%a")
          ("n" "note" entry "* %?\n%U"))))

;; Integration with org-capture
(after! (org-roam org-roam-dailies org-capture)
  (org-roam-dailies-add-capture-template)
  (setq org-roam-capture-templates
        (append org-roam-capture-templates
                org-roam-dailies-capture-templates)))