;; -*- lexical-binding: t; -*-
;;; contacts.el - Contact management configuration

;; org-vcard configuration - vCard support
(after! org-vcard
  (setq org-vcard-default-language "en")
  (setq org-vcard-export-file-extension ".vcf")
  (setq org-vcard-import-include-all-attributes t)

  ;; Map vCard fields to org properties
  (setq org-vcard-mapping-table
        '(("FN" . "%[FULL_NAME]")
          ("EMAIL" . "%[EMAIL]")
          ("TEL" . "%[PHONE]")
          ("ADR" . "%[ADDRESS]")
          ("URL" . "%[WEBSITE]")
          ("NOTE" . "%[NOTES]")))

  ;; Set contacts directory
  (setq org-vcard-contacts-dir "~/Documents/org/contacts/"))

;; EBDB configuration - Enhanced contact database
(after! ebdb
  (ebdb-initialize)
  (setq ebdb-file "~/Documents/org/contacts/ebdb")
  (setq ebdb-sources-files '("~/Documents/org/contacts/contacts.org"))

  ;; Enable EBDB completion in org-mode
  (setq ebdb-complete-mail t)
  (setq ebdb-mail-allow-aliases nil)

  ;; Format for displaying contacts
  (setq ebdb-record-field-formatter
        (lambda (record field)
          (pcase field
            ('name (ebdb-dwim-name record))
            ('mail (mapconcat #'identity (ebdb-record-field record 'mail) ", "))
            (_ (ebdb-record-field record field))))))

;; org-contacts - Simple org-mode based contacts
(after! org-contacts
  (setq org-contacts-files '("~/Documents/org/contacts/contacts.org"))
  (setq org-contacts-email-link-description 'email)
  (setq org-contacts-icon-property "ICON"))

;; Keybindings for contacts
(map! :leader
      (:prefix ("c" . "contacts")
       :desc "Import vCard" "i" #'org-vcard-import
       :desc "Export vCard" "e" #'org-vcard-export
       :desc "Create contact" "c" #'org-capture-contacts
       :desc "Search contacts" "s" #'ebdb))