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

;; This code below requires installation of Vega tools like this:
;; pnpm add -g vega-lite resvg-cli 
(defun my/markdown-vega-view-png ()
  "Extract the Vega/Vega-Lite code block at point, compile to PNG, and display it."
  (interactive)
  (let ((json-str nil)
        (png-file (make-temp-file "emacs-vega-" nil ".png"))
        (svg-file (make-temp-file "emacs-vega-" nil ".svg")))
    
    ;; 1. Context Detection via Text Properties
    (cond
     ;; Scenario A: Inside a Markdown buffer
     ((derived-mode-p 'markdown-mode)
      (if (markdown-code-block-at-point-p)
          (let ((pos (point))
                block-start block-end)
            (save-excursion
              ;; Find the beginning of the fenced block property region
              (setq block-start (previous-single-property-change (1+ pos) 'face nil (point-min)))
              ;; Find the end of the fenced block property region
              (setq block-end (next-single-property-change pos 'face nil (point-max)))
              
              (when (and block-start block-end)
                (goto-char block-start)
                ;; If sitting on the opening backticks line, skip past it to inner JSON
                (when (looking-at "^[ \t]*```")
                  (forward-line 1)
                  (setq block-start (point)))
                
                (goto-char block-end)
                ;; If sitting on the closing backticks line, back up to clean line end
                (beginning-of-line)
                (when (looking-at "^[ \t]*
```")
                  (forward-line -1)
                  (end-of-line)
                  (setq block-end (point)))
                
                (setq json-str (buffer-substring-no-properties block-start block-end)))))
        (user-error "Cursor is not pointing inside a code block")))
     
     ;; Scenario B: Fallback to pure JSON buffer logic
     ((derived-mode-p 'json-mode)
      (setq json-str (buffer-substring-no-properties (point-min) (point-max))))
     
     (t (user-error "Unsupported buffer environment mode")))

    ;; 2. The Core Compilation Pipeline
    (when (and json-str (not (string-empty-p (string-trim json-str))))
      (with-temp-buffer
        (insert json-str)
        (shell-command-on-region (point-min) (point-max) "vl2svg" nil t)
        (write-region (point-min) (point-max) svg-file nil 'silent))
      
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
        (display-buffer buf)))))

(after! json-mode
  (map! :map json-mode-map
        :localleader
        :desc "View Vega Chart (PNG)" "v" #'my/markdown-vega-view-png))

(after! markdown-mode
  (map! :map markdown-mode-map
        :localleader
        :desc "View Embedded Vega (PNG)" "v" #'my/markdown-vega-view-png))


(defvar my/vega-local-tmp-files nil
  "Tracks local temporary PNG files generated during offline markdown previews.")

(defun my/markdown-filter-compile-vega-blocks (string)
  "Processor that transforms Vega code blocks in STRING into inline PNG image markdown references."
  (let ((processed-str string)
        (start-pos 0))
    ;; Match markdown code fences labeled vega or vega-lite
    (while (string-match "^\\([ \t]*\\)```\\(?:vega-lite\\|vega\\)\n\\(\\(?:.\\|\n\\)*?\\)
```" processed-str start-pos)
      (let* ((indent (match-string 1 processed-str))
             (vega-code (match-string 2 processed-str))
             (svg-file (make-temp-file "emacs-vega-local-" nil ".svg"))
             (png-file (make-temp-file "emacs-vega-local-" nil ".png"))
             (replacement-link ""))
        
        (push png-file my/vega-local-tmp-files)
        
        ;; 1. Process Vega text payload to SVG locally
        (with-temp-buffer
          (insert vega-code)
          (shell-command-on-region (point-min) (point-max) "vl2svg" nil t)
          (write-region (point-min) (point-max) svg-file nil 'silent))
        
        ;; 2. Convert SVG to PNG locally
        (shell-command (format "resvg-cli %s %s" 
                               (shell-quote-argument svg-file) 
                               (shell-quote-argument png-file)))
        (delete-file svg-file)
        
        ;; 3. Create a local file path reference using absolute file protocol paths
        (setq replacement-link (format "\n%s![Vega Chart](file://%s)\n" indent png-file))
        
        (setq processed-str (replace-match replacement-link t t processed-str))
        (setq start-pos (+ (match-beginning 0) (length replacement-link)))))
    processed-str))

;; --- Safe Offline Preview Interceptor ---

(defun my/markdown-preview-offline-vega-advice (orig-fun &rest args)
  "Intercept markdown-preview to process Vega blocks safely without recursion loops."
  (let* ((original-buffer (current-buffer))
         (original-file (buffer-file-name))
         ;; Create a hidden working buffer to shield the original text
         (working-buf (generate-new-buffer " *markdown-vega-export*")))
    (unwind-protect
        (progn
          ;; 1. Sync the core contents to our export sandbox
          (with-current-buffer working-buf
            (insert-buffer-substring-no-properties original-buffer)
            ;; Enable markdown-mode so internal commands know how to process it
            (markdown-mode)
            ;; Fake the file association so 'marked' can find relative assets if needed
            (setq buffer-file-name original-file)
            
            ;; 2. Run the string filter replacement loop inline
            (let ((modified-text (my/markdown-filter-compile-vega-blocks (buffer-string))))
              (erase-buffer)
              (insert modified-text))
            
            ;; 3. Execute the actual preview command context inside the sandbox buffer
            (apply orig-fun args)))
      
      ;; 4. Always clean up the hidden background buffer when finished
      (when (buffer-live-p working-buf)
        (kill-buffer working-buf)))))

;; Clear out all problematic loop/legacy hooks completely
(advice-remove 'markdown-standalone #'my/markdown-preview-compile-vega-advice)
(advice-remove 'grip-get-buffer-string #'my/grip-compile-vega-wrapper)
(advice-remove 'markdown-compile #'my/markdown-compile-offline-vega-advice)
(advice-remove 'markdown-preview #'my/markdown-preview-offline-vega-advice)

;; Bind the new safe advice to the preview engine
(advice-add 'markdown-preview :around #'my/markdown-preview-offline-vega-advice)


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
