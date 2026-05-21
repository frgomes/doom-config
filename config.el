;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; --- Identity ---
;; --- Identity (Dynamic from Git) ---
(setq user-full-name
      (shell-command-to-string "git config --get user.name | tr -d '\\n'"))

(setq user-mail-address
      (shell-command-to-string "git config --get user.email | tr -d '\\n'"))

;; --- UI & Fonts ---
(setq doom-theme 'doom-one)
(setq display-line-numbers-type t)

;; Standards for Plasma 6 (Using Nerd Fonts)
;; Ensure you've run M-x nerd-icons-install-fonts
(after! unicode-fonts
  (unicode-fonts-setup))


;; --- Diagrams and Charts ---

(after! markdown-mode
  (setq markdown-command "marked"))

(defun my/extract-inner-mermaid-block ()
  "Extract and return the raw inner text of the fenced Mermaid block at point."
  (interactive)
  (let ((orig-point (point))
        block-start block-end)
    (save-excursion
      ;; 1. Locate the inner block start (scan upward)
      (goto-char orig-point)
      (end-of-line) ; Ensures match if cursor is sitting on the opening fence line itself
      (if (re-search-backward "^[ \t]*```mermaid[ \t]*$" nil t)
          (progn
            (forward-line 1)
            (beginning-of-line)
            (setq block-start (point)))
        (user-error "Could not find matching opening ```mermaid fence"))

      ;; 2. Locate the inner block end (scan downward)
      (goto-char orig-point)
      (forward-line 1)
      (if (re-search-forward "^[ \t]*```[ \t]*$" nil t)
          (progn
            (beginning-of-line)
            (setq block-end (point)))
        (user-error "Could not find matching closing ``` fence"))

      ;; 3. Extract and return the clean string payload
      (if (and block-start block-end (< block-start block-end))
          (let ((inner-content (buffer-substring-no-properties block-start block-end)))
            (message "Successfully extracted inner Mermaid block.")
            inner-content)
        (user-error "Calculated block markers are invalid or empty")))))

(defun my/extract-inner-vega-block ()
  "Extract and return the raw inner text of the fenced Vega block at point."
  (interactive)
  (let ((orig-point (point))
        block-start block-end)
    (save-excursion
      ;; 1. Locate the inner block start (scan upward)
      (goto-char orig-point)
      (end-of-line) ; Ensures match if cursor is sitting on the opening fence line itself
      (if (re-search-backward "^[ \t]*```\\(?:vega-lite\\|vega\\)[ \t]*$" nil t)
          (progn
            (forward-line 1)
            (beginning-of-line)
            (setq block-start (point)))
        (user-error "Could not find matching opening ```vega fence"))

      ;; 2. Locate the inner block end (scan downward)
      (goto-char orig-point)
      (forward-line 1)
      (if (re-search-forward "^[ \t]*```[ \t]*$" nil t)
          (progn
            (beginning-of-line)
            (setq block-end (point)))
        (user-error "Could not find matching closing ``` fence"))

      ;; 3. Extract and return the clean string payload
      (if (and block-start block-end (< block-start block-end))
          (let ((inner-content (buffer-substring-no-properties block-start block-end)))
            (message "Successfully extracted inner Vega block.")
            inner-content)
        (user-error "Calculated block markers are invalid or empty")))))

(defun my/markdown-mermaid-view-png ()
  "Extract the Mermaid/Mermaid-Lite code block at point, compile to PNG, and display it."
  (interactive)
  (let ((mermaid-str nil)
        (png-file (make-temp-file "emacs-mermaid-" nil ".png"))
        (mmd-file (make-temp-file "emacs-mermaid-" nil ".mmd")))
    
    ;; 1. Context Detection
    (cond
     ;; Scenario A: Inside a Markdown buffer (Using outsourced clean function)
     ((derived-mode-p 'markdown-mode)
      (if (markdown-code-block-at-point-p)
          (setq mermaid-str (my/extract-inner-mermaid-block))
        (user-error "Cursor is not pointing inside a code block")))
     
     ;; Scenario B: Fallback to pure mermaid buffer logic
     ((derived-mode-p 'mermaid-mode)
      (setq mermaid-str (buffer-substring-no-properties (point-min) (point-max))))
     
     (t (user-error "Unsupported buffer environment mode")))

    ;; 2. The Core Compilation Pipeline
    (when (and mermaid-str (not (string-empty-p (string-trim mermaid-str))))
      (with-temp-buffer
        (insert mermaid-str)
        (write-region (point-min) (point-max) mmd-file nil 'silent))
      
      (let ((shell-command-switch "-ic"))
        (shell-command (format "export PUPPETEER_ARROW_ARGS='[\"--no-sandbox\", \"--disable-setuid-sandbox\"]'; mmdc -i %s -o %s -b transparent" 
                               (shell-quote-argument mmd-file) 
                               (shell-quote-argument png-file))))
      (delete-file mmd-file)
      
      ;; 3. Native Buffer Presentation
      (let ((buf (get-buffer-create "*Mermaid View*")))
        (with-current-buffer buf
          (read-only-mode -1)
          (erase-buffer)
          (let ((img (create-image png-file 'png nil)))
            (insert-image img))
          (read-only-mode 1))
        (display-buffer buf))
      (delete-file mmd-file))))

(defun my/markdown-vega-view-png ()
  "Extract the Vega/Vega-Lite code block at point, compile to PNG, and display it."
  (interactive)
  (let ((vega-str nil)
        (vega-file (make-temp-file "emacs-vega-" nil ".json"))
        (png-file  (make-temp-file "emacs-vega-" nil ".png"))
        (svg-file  (make-temp-file "emacs-vega-" nil ".svg")))
    
    ;; 1. Context Detection
    (cond
     ;; Scenario A: Inside a Markdown buffer (Using outsourced clean function)
     ((derived-mode-p 'markdown-mode)
      (if (markdown-code-block-at-point-p)
          (setq vega-str (my/extract-inner-vega-block))
        (user-error "Cursor is not pointing inside a code block")))
     
     ;; Scenario B: Fallback to pure JSON buffer logic
     ((derived-mode-p 'json-mode)
      (setq vega-str (buffer-substring-no-properties (point-min) (point-max))))
     
     (t (user-error "Unsupported buffer environment mode")))



    ;; 2. The Core Compilation Pipeline
    (when (and vega-str (not (string-empty-p (string-trim vega-str))))
      (with-temp-buffer
        (insert vega-str)
        (write-region (point-min) (point-max) vega-file nil 'silent))

      (shell-command (format "vl2svg %s %s" 
                             (shell-quote-argument vega-file) 
                             (shell-quote-argument svg-file)))
      (delete-file vega-file)

      (shell-command (format "resvg-cli %s %s" 
                             (shell-quote-argument svg-file) 
                             (shell-quote-argument png-file)))
      (delete-file svg-file)
      
      ;; 3. Native Buffer Presentation
      (let ((buf (get-buffer-create "*Vega View*")))
        (with-current-buffer buf
          (read-only-mode -1)
          (erase-buffer)
          (let ((img (create-image png-file 'png nil)))
            (insert-image img))
          (read-only-mode 1))
        (display-buffer buf))
      (delete-file png-file))))

(after! json-mode
  (map! :map json-mode-map
        :localleader
        :desc "View Vega Chart (PNG)" "v" #'my/markdown-vega-view-png))

(after! markdown-mode
  (map! :map markdown-mode-map
        :localleader
        :desc "View Embedded Vega (PNG)"    "v" #'my/markdown-vega-view-png
        :desc "View Embedded Mermaid (PNG)" "d" #'my/markdown-mermaid-view-png))

(defvar my/markdown-local-tmp-files nil
  "Tracks all local temporary PNG files generated during offline markdown previews.")

(defun my/markdown-filter-compile-embedded-blocks (string)
  "Processor that transforms both Vega and Mermaid code blocks into inline PNG references."
  (let ((processed-str string)
        (start-pos 0))
    
    ;; ==========================================
    ;; LOOP 1: Process Vega & Vega-Lite Blocks
    ;; ==========================================
    (while (string-match "^\\([ \t]*\\)```\\(?:vega-lite\\|vega\\)\n\\(\\(?:.\\|\n\\)*?\\)```" processed-str start-pos)
      (let* ((indent (match-string 1 processed-str))
             (vega-code (match-string 2 processed-str))
             (svg-file (make-temp-file "emacs-vega-local-" nil ".svg"))
             (png-file (make-temp-file "emacs-vega-local-" nil ".png"))
             (replacement-link ""))
        
        (push png-file my/markdown-local-tmp-files)
        
        ;; Compile Vega JSON to SVG
        (with-temp-buffer
          (insert vega-code)
          (shell-command-on-region (point-min) (point-max) "vl2svg" nil t)
          (write-region (point-min) (point-max) svg-file nil 'silent))
        
        ;; Render SVG to high-res PNG
        (shell-command (format "resvg-cli %s %s" 
                               (shell-quote-argument svg-file) 
                               (shell-quote-argument png-file)))
        (delete-file svg-file)
        
        (setq replacement-link (format "\n%s![Vega Chart](file://%s)\n" indent png-file))
        (setq processed-str (replace-match replacement-link t t processed-str))
        (setq start-pos (+ (match-beginning 0) (length replacement-link)))))

    ;; Reset cursor position for the second parsing engine sweep
    (setq start-pos 0)

    ;; ==========================================
    ;; LOOP 2: Process Mermaid Syntax Blocks
    ;; ==========================================
    (while (string-match "^\\([ \t]*\\)```mermaid\n\\(\\(?:.\\|\n\\)*?\\)
```" processed-str start-pos)
      (let* ((indent (match-string 1 processed-str))
             (mermaid-code (match-string 2 processed-str))
             (tmp-mmd-file (make-temp-file "emacs-mermaid-local-" nil ".mmd"))
             (png-file (make-temp-file "emacs-mermaid-local-" nil ".png"))
             (replacement-link ""))
        
        (push png-file my/markdown-local-tmp-files)
        
        ;; Save raw text block context to a temporary definition layout file
        (with-temp-buffer
          (insert mermaid-code)
          (write-region (point-min) (point-max) tmp-mmd-file nil 'silent))
        
        ;; Execute the local mermaid-cli binary pipeline tool natively
        ;; Note: We set background transparent (-b transparent) to cleanly blend with browser theme modes
        (shell-command (format "mmdc -i %s -o %s -b transparent" 
                               (shell-quote-argument tmp-mmd-file) 
                               (shell-quote-argument png-file)))
        (delete-file tmp-mmd-file)
        
        (setq replacement-link (format "\n%s![Mermaid Chart](file://%s)\n" indent png-file))
        (setq processed-str (replace-match replacement-link t t processed-str))
        (setq start-pos (+ (match-beginning 0) (length replacement-link)))))

    processed-str))

;; --- Safe Offline Preview Interceptor Engine ---

(defun my/markdown-preview-offline-embedded-advice (orig-fun &rest args)
  "Intercept markdown-preview to process both Vega and Mermaid blocks safely inside a clean workspace container."
  (let* ((original-buffer (current-buffer))
         (original-file (buffer-file-name))
         (working-buf (generate-new-buffer " *markdown-embedded-export*")))
    (unwind-protect
        (progn
          (with-current-buffer working-buf
            (insert-buffer-substring-no-properties original-buffer)
            (markdown-mode)
            (setq buffer-file-name original-file)
            
            ;; Execute the dual-loop text transformer sequence
            (let ((modified-text (my/markdown-filter-compile-embedded-blocks (buffer-string))))
              (erase-buffer)
              (insert modified-text))
            
            (apply orig-fun args)))
      
      (when (buffer-live-p working-buf)
        (kill-buffer working-buf)))))

;; Tear down old single-loop filter bindings completely
(advice-remove 'markdown-preview #'my/markdown-preview-offline-vega-advice)
(advice-remove 'markdown-preview #'my/markdown-preview-offline-embedded-advice)

;; Attach the new multi-engine pipeline to the preview handler
(advice-add 'markdown-preview :around #'my/markdown-preview-offline-embedded-advice)


;; --- Ripgrep (rg) Configuration ---
;; Optimized for mass find/replace and code navigation
(after! rg
  (setq rg-command-line-flags '("--hidden" "--glob" "!.git/*"))
  (setq rg-group-result t
        rg-show-columns t
        rg-ignore-case 'smart)
  ;; Automatically save all buffers after a mass wgrep change
  (setq wgrep-auto-save-buffer t))

;; --- Language Specifics ---
;; Java 11 symlink for Scala/Metals compatibility (openSUSE path)
(after! scala
  (setq lsp-metals-java-home "~/tools/jdk-11"))

;; AI Integration (Claude/Aider)
(after! claude-code-ide
  (setq claude-code-ide-model "claude-3-5-sonnet-latest"))

;; --- Second Brain (Org & Org-Roam) ---
;; Recommendation: Separate trees for Agenda performance
(setq org-directory "~/Documents/org/")
(setq org-roam-directory (file-truename "~/Documents/roam/"))

(after! org-roam
  (setq org-roam-dailies-directory "daily/")

  ;; Agenda Logic: Only include active TODOs and Daily logs
  ;; This prevents the UI from lagging as your Roam database grows.
  (setq org-agenda-files
        (list (expand-file-name "todo.org" org-directory)
              (expand-file-name "daily/" org-roam-directory)))

  ;; Optimized Capture Templates
  (setq org-roam-capture-templates
        '(("m" "main" plain "%?"
           :if-new (file+head "main/${slug}.org" "#+title: ${title}\n")
           :immediate-finish t :unnarrowed t)
          ("c" "code" plain "%?"
           :if-new (file+head "code/${title}.org" "#+title: ${title}\n")
           :immediate-finish t :unnarrowed t)
          ("p" "personal" plain "%?"
           :if-new (file+head "personal/${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)))

  (org-roam-db-autosync-mode))

;; --- Projectile Configuration ---
(after! projectile
  (setq projectile-project-search-path '("~/projects" "~/dotfiles"))
  ;; Hybrid indexing is faster on Linux/openSUSE
  (setq projectile-indexing-method 'hybrid))

;; --- Module & Secret Loading ---
(when (file-exists-p! "secret.el" doom-user-dir)
  (load! "secret"))

;; Modularizing configs for better Dotfile maintenance
(load! "modules/contacts/config")
(load! "modules/calendar/config")
(load! "modules/kanban/config")
(load! "modules/roam/config")
(load! "modules/hydra/config")

;; --- Custom File Redirection ---
;; Keeps this config.el clean from GUI-generated noise
(setq custom-file (expand-file-name "custom.el" doom-user-dir))
(when (file-exists-p custom-file)
  (load custom-file))

;; --- Keybindings ---
(map! :leader
      (:prefix ("n" . "notes")
       :desc "Find node"      "f" #'org-roam-node-find
       :desc "Insert node"    "i" #'org-roam-node-insert
       :desc "Capture node"   "c" #'org-roam-capture
       :desc "Graph"          "g" #'org-roam-graph
       :desc "Daily today"    "j" #'org-roam-dailies-capture-today)
      (:prefix ("s" . "search")
       :desc "Ripgrep Menu"   "R" #'rg-menu))
