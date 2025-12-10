;; -*- lexical-binding: t; -*-
;;; kanban.el - Kanban and GTD configuration

;; org-kanban configuration - Hybrid GTD/Kanban
(after! org-kanban
  ;; GTD-style columns with kanban visualization
  (setq org-kanban-columns
        "INBOX(5) | NEXT(3) | IN-PROGRESS(2) | WAITING(3) | DONE(10)")

  ;; Key mappings for easy transitions
  (setq org-kanban-keymap
        '(("i" . org-kanban-insert-item)
          ("d" . org-kanban-delete-item)
          ("l" . org-kanban-shift-left)
          ("r" . org-kanban-shift-right)
          ("n" . org-kanban-next-line)
          ("p" . org-kanban-previous-line)
          ("q" . org-kanban-quit))))

;; Hybrid GTD with org-super-agenda
(after! org-super-agenda
  (org-super-agenda-mode)

  ;; Define GTD states
  (setq org-todo-keywords
        '((sequence "INBOX(i)" "NEXT(n)" "IN-PROGRESS(p)" "WAITING(w)" "|" "DONE(d)")
          (sequence "PROJECT(j)" "SOMEDAY(s)" "|" "CANCELLED(c)")))

  ;; Custom agenda views combining GTD and kanban
  (setq org-agenda-custom-commands
        '(("g" "GTD Hybrid View"
           ((agenda "" ((org-super-agenda-groups
                         '((:name "Today's Schedule"
                            :time-grid t
                            :date today)
                           (:name "Deadlines Today"
                            :deadline today
                            :order 3)))))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Actions")
                   (org-super-agenda-groups
                    '((:name "Priority Next"
                       :priority "A"
                       :order 1)
                      (:name "Regular Next"
                       :priority "B"
                       :order 2)))))
            (todo "IN-PROGRESS"
                  ((org-agenda-overriding-header "Currently Working On")))
            (todo "PROJECT"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-super-agenda-groups
                    '((:name "Active Projects"
                       :tag ("project" "active")
                       :order 1)
                      (:name "Planning Phase"
                       :tag "planning"
                       :order 2)))))
            (todo "WAITING"
                  ((org-agenda-overriding-header "Waiting For")
                   (org-super-agenda-groups
                    '((:name "External Dependencies"
                       :tag "external")
                      (:name "Scheduled"
                       :tag "scheduled")))))))))

;; GTD capture templates
(after! org-capture
  (setq org-capture-templates
        '(("i" "Inbox" entry (file+headline "~/Documents/org/gtd/inbox.org" "Inbox")
           "* %?\n%U\n%i\n%a")
          ("t" "Task" entry (file+headline "~/Documents/org/gtd/tasks.org" "Tasks")
           "* TODO %?\n%U")
          ("p" "Project" entry (file+headline "~/Documents/org/gtd/projects.org" "Projects")
           "* PROJECT %?\n%U\n** NEXT Initial task")
          ("m" "Meeting" entry (file+headline "~/Documents/org/gtd/meetings.org" "Meetings")
           "* %? :meeting:\n%U\n** Attendees\n** Agenda\n** Notes\n** Action Items"))))

;; Org agenda settings
(setq org-agenda-files
      '("~/Documents/org/gtd/inbox.org"
        "~/Documents/org/gtd/tasks.org"
        "~/Documents/org/gtd/projects.org"
        "~/Documents/org/gtd/meetings.org"
        "~/Documents/org/kanban/"))

;; Refile targets
(setq org-refile-targets
      '(("~/Documents/org/gtd/tasks.org" :maxlevel . 3)
        ("~/Documents/org/gtd/projects.org" :maxlevel . 3)
        ("~/Documents/org/gtd/someday.org" :level . 1)))

;; GTD settings
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-include-deadlines t)
(setq org-deadline-warning-days 14)

;; Keybindings for GTD
(map! :leader
      (:prefix ("g" . "gtd")
       :desc "GTD Agenda" "g" #'org-agenda
       :desc "Process Inbox" "i" #'org-agenda-list
       :desc "Capture" "c" #'org-capture
       :desc "Kanban View" "k" #'org-kanban))