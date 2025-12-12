;;; hydra/config.el --- Second Brain hydra menu -*- lexical-binding: t; -*-

;; Define missing org-capture-contacts function
(defun org-capture-contacts ()
  "Create a new contact entry."
  (interactive)
  (org-capture nil "c"))

;; Main Second Brain Hydra
(defhydra second-brain-hydra (:hint nil :exit t)
  "
Second Brain Menu

ORG-ROAM (NOTES)      CONTACTS               CALENDAR               GTD/KANBAN           MIND MAPS
  n f: find node        c c: create            a c: calendar view     g a: agenda          m g: generate
  n i: insert link      c i: import vCard      a s: sync CalDAV       g i: inbox           m p: export PNG
  n b: backlinks        c e: export vCard      a o: org calendar      g c: capture         m s: export SVG
  n g: graph view       c s: search                                   g k: kanban view     m d: export PDF
  n a: add alias                                                                           m o: open directory
  n d: daily note                                                                          m r: from roam node
  n t: today's note
  n c: quick capture

QUIT
  q: quit hydra
"
  ("q" nil :exit t)

  ;; Org-roam - prefix n
  ("n f" org-roam-node-find)
  ("n i" org-roam-node-insert)
  ("n b" org-roam-buffer-toggle)
  ("n g" org-roam-graph)
  ("n a" org-roam-alias-add)
  ("n d" org-roam-dailies-goto-date)
  ("n t" org-roam-dailies-capture-today)
  ("n c" org-roam-capture)

  ;; Contacts - prefix c
  ("c c" org-capture-contacts)
  ("c i" org-vcard-import)
  ("c e" org-vcard-export)
  ("c s" ebdb)

  ;; Calendar - prefix a
  ("a c" calendar)
  ("a s" caldav-sync)
  ("a o" org-calendar-view)

  ;; GTD/Kanban - prefix g
  ("g a" org-agenda)
  ("g i" (lambda () (interactive) (find-file "~/Documents/org/gtd/inbox.org")))
  ("g c" org-capture)
  ("g k" (lambda () (interactive) (find-file "~/Documents/org/gtd/kanban.org") (org-kanban-mode 1)))

  ;; Mind Maps - prefix m
  ("m g" org-mind-map)
  ("m p" org-mind-map-export-png)
  ("m s" org-mind-map-export-svg)
  ("m d" org-mind-map-export-pdf)
  ("m o" (lambda () (interactive) (find-file "~/Documents/org/mindmaps/")))
  ("m r" org-roam-mind-map-from-node))

;; Global keybinding for the Second Brain hydra
(global-set-key (kbd "C-c b") 'second-brain-hydra/body)