;; -*- lexical-binding: t; -*-
;;; calendar.el - Calendar configuration

;; Native CalDAV setup (choose one provider)
;; Uncomment the appropriate provider configuration

;; Option 1: Fastmail (recommended for simplicity)
(after! caldav
  (setq caldav-url "https://caldav.fastmail.com/")
  (setq caldav-username "your-email@fastmail.com")
  (setq caldav-save-directory "~/Documents/org/calendars/"))

;; Option 2: iCloud (if you have Apple ID)
;;(after! caldav
;;  (setq caldav-url "https://caldav.icloud.com/")
;;  (setq caldav-username "your-apple-id@icloud.com")
;;  (setq caldav-save-directory "~/Documents/org/calendars/"))

;; Option 3: Nextcloud (self-hosted)
;;(after! caldav
;;  (setq caldav-url "https://your-nextcloud.com/remote.php/dav/calendars/username/")
;;  (setq caldav-username "username")
;;  (setq caldav-save-directory "~/Documents/org/calendars/"))

;; org-caldav configuration
(after! org-caldav
  (setq org-caldav-url "https://your-provider.com/caldav/")
  (setq org-caldav-calendar-id "personal")
  (setq org-caldav-inbox-file "~/Documents/org/calendars/inbox.org")
  (setq org-caldav-calendar-file "~/Documents/org/calendars/personal.org")
  (setq org-caldav-sync-changes-to-org t)
  (setq org-caldav-auto-sync t)  ; Auto-sync every 30 minutes
  (setq org-caldav-save-buffers nil))  ; Don't prompt to save

;; Calendar display settings
(setq calendar-week-start-day 1)  ; Start week on Monday
(setq calendar-mark-diary-entries-flag t)

;; Diary integration with org-mode
(setq org-agenda-include-diary t)

;; Calendar holidays
(setq calendar-holidays
      '((holiday-fixed 1 1 "New Year's Day")
        (holiday-fixed 2 14 "Valentine's Day")
        (holiday-fixed 4 1 "April Fools' Day")
        (holiday-fixed 12 25 "Christmas")
        (holiday-float 11 4 4 "Thanksgiving")
        (holiday-float 9 1 1 "Labor Day")
        (holiday-float 10 2 2 "Columbus Day")
        (holiday-float 1 1 3 "Martin Luther King Jr. Day")
        (holiday-float 2 3 1 "Presidents' Day")
        (holiday-float 5 1 1 "Memorial Day")))

;; Keybindings for calendar (C-c a prefix for agenda/calendar)
(global-set-key (kbd "C-c a c") #'calendar)              ; Calendar view
(global-set-key (kbd "C-c a s") #'caldav-sync)           ; CalDAV sync
(global-set-key (kbd "C-c a o") #'org-calendar-view)     ; Org calendar