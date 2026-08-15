(setq package-enable-at-startup nil)

(require 'use-package)

(use-package eldoc
  :demand t)

(use-package xref
  :demand t)

(use-package project
  :demand t
  :config
  (define-key global-map (kbd "C-c p") project-prefix-map))

(use-package flymake
  :demand t
  :hook (prog-mode . flymake-mode))

(use-package emacs
  :ensure nil
  :init
  (setq completion-cycle-threshold 3
        tab-always-indent 'complete
        read-extended-command-predicate #'command-completion-default-include-p
        enable-recursive-minibuffers t
        minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))

  (defun susan/crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))

  (advice-add #'completing-read-multiple :filter-args #'susan/crm-indicator)
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  (setq-default cursor-type 'bar
                line-spacing 0.12)
  (setq make-pointer-invisible t
        org-edit-src-content-indentation 0
        use-default-font-for-symbols t)

  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (global-display-line-numbers-mode 1)
  (global-visual-line-mode 1)
  (electric-indent-mode -1)

  :config
  (defconst susan/mono-font-family "RecMonoDuotone Nerd Font Mono")
  (defconst susan/variable-font-family "RecMonoDuotone Nerd Font Propo")
  (defconst susan/unicode-font-family "Noto Sans")
  (defconst susan/cjk-font-family "Noto Sans CJK SC")
  (defconst susan/emoji-font-family "Noto Color Emoji")

  (defun susan/font-family-available-p (family)
    (and (display-graphic-p)
         (member family (font-family-list))))

  (defun susan/set-fontset-font-if-available (characters family &optional add)
    (when (susan/font-family-available-p family)
      (set-fontset-font t characters (font-spec :family family) nil (or add 'prepend))))

  (defun susan/apply-fontset-fonts ()
    (when (display-graphic-p)
      (dolist (range '((#x2500 . #x259F)   ; Box Drawing, Block Elements
                       (#x2800 . #x28FF)   ; Braille Patterns
                       (#xE000 . #xF8FF)   ; Private Use Area
                       (#xF0000 . #xFFFFD)
                       (#x100000 . #x10FFFD)))
        (susan/set-fontset-font-if-available range susan/mono-font-family))
      (susan/set-fontset-font-if-available 'symbol susan/mono-font-family)
      (susan/set-fontset-font-if-available 'unicode susan/unicode-font-family 'append)
      (dolist (script '(han kana hangul cjk-misc bopomofo))
        (susan/set-fontset-font-if-available script susan/cjk-font-family 'append))
      (dolist (range '((#x1F000 . #x1FAFF)
                       (#x2600 . #x27BF)))
        (susan/set-fontset-font-if-available range susan/emoji-font-family))))

  (defun susan/apply-fonts (&optional frame)
    (with-selected-frame (or frame (selected-frame))
      (when (display-graphic-p)
        (set-face-attribute 'default frame
                            :font susan/mono-font-family
                            :height 130
                            :weight 'medium)
        (set-face-attribute 'variable-pitch frame
                            :font susan/variable-font-family
                            :height 130
                            :weight 'medium)
        (set-face-attribute 'fixed-pitch frame
                            :font susan/mono-font-family
                            :height 130
                            :weight 'medium)
        (susan/apply-fontset-fonts))
      (set-face-attribute 'font-lock-comment-face frame :slant 'italic)
      (set-face-attribute 'font-lock-keyword-face frame :slant 'italic)))

  (susan/apply-fonts)
  (add-to-list 'default-frame-alist `(font . ,(format "%s-13" susan/mono-font-family)))
  (add-hook 'after-make-frame-functions #'susan/apply-fonts))

(use-package server
  :ensure nil
  :config
  (unless (or noninteractive (daemonp) (server-running-p))
    (server-start)))

(use-package savehist
  :ensure nil
  :config
  (savehist-mode 1))

(use-package tab-bar
  :ensure nil
  :config
  (tab-bar-mode 1)
  (tab-bar-history-mode 1))

(use-package which-key
  :ensure nil
  :config
  ;; which-key is built into modern Emacs; Nix should not fetch it.
  (which-key-mode 1)
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit t
        which-key-separator " -> "))

(use-package consult
  :demand t
  :bind (("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ("M-y" . consult-yank-pop)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :config
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-bookmark
   consult-recent-file
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

(use-package consult-xref
  :ensure nil
  :after consult
  :demand t
  :config
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  (consult-customize
   consult-xref :preview-key '(:debounce 0.4 any)))

(use-package vertico
  :demand t
  :config
  (setq vertico-resize t)
  (vertico-mode 1))

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :demand t
  :config
  (marginalia-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-separator ?\s)
  (corfu-quit-no-match t)
  :demand t
  :config
  (global-corfu-mode 1))

(use-package susan-treesit-grammars
  :ensure nil
  :if (locate-library "susan-treesit-grammars")
  :demand t)

(use-package treesit
  :ensure nil
  :config
  (dolist (dir (list "/run/current-system/sw/lib"
                     "/run/current-system/sw"
                     (expand-file-name "~/.nix-profile/lib")
                     (expand-file-name "~/.nix-profile")
                     (format "/etc/profiles/per-user/%s/lib" (user-login-name))
                     (format "/etc/profiles/per-user/%s" (user-login-name))))
    (when (file-directory-p dir)
      (add-to-list 'treesit-extra-load-path dir)))
  (setq treesit-font-lock-level 4)
  (dolist (remap '((c-mode . c-ts-mode)
                   (c++-mode . c++-ts-mode)
                   (c-or-c++-mode . c-or-c++-ts-mode)
                   (js-mode . js-ts-mode)
                   (javascript-mode . js-ts-mode)
                   (typescript-mode . typescript-ts-mode)
                   (rust-mode . rust-ts-mode)))
    (add-to-list 'major-mode-remap-alist remap)))

(use-package eglot
  :ensure nil
  :hook ((c-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (c-ts-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure)
         (elixir-mode . eglot-ensure)
         (elixir-ts-mode . eglot-ensure)
         (heex-ts-mode . eglot-ensure)
         (js-mode . eglot-ensure)
         (js-ts-mode . eglot-ensure)
         (nix-ts-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (rust-ts-mode . eglot-ensure)
         (tsx-ts-mode . eglot-ensure)
         (typescript-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure))
  :config
  (setq eglot-autoshutdown t)
  (dolist (server '(((c-mode c-ts-mode c++-mode c++-ts-mode) . ("clangd"))
                    ((elixir-mode elixir-ts-mode heex-ts-mode) . ("language_server.sh"))
                    (((js-mode :language-id "javascript")
                      (js-ts-mode :language-id "javascript")
                      (tsx-ts-mode :language-id "typescriptreact")
                      (typescript-ts-mode :language-id "typescript")
                      (typescript-mode :language-id "typescript"))
                     . ("typescript-language-server" "--stdio"))
                    (nix-ts-mode . ("nixd"))
                    ((rust-mode rust-ts-mode) . ("rust-analyzer"))))
    (add-to-list 'eglot-server-programs server)))

(use-package c-ts-mode
  :ensure nil
  :mode (("\\.c\\'" . c-ts-mode)
         ("\\.h\\'" . c-or-c++-ts-mode)
         ("\\.cc\\'" . c++-ts-mode)
         ("\\.cpp\\'" . c++-ts-mode)
         ("\\.cxx\\'" . c++-ts-mode)
         ("\\.hh\\'" . c++-ts-mode)
         ("\\.hpp\\'" . c++-ts-mode)
         ("\\.hxx\\'" . c++-ts-mode)))

(use-package elixir-ts-mode
  :mode (("\\.ex\\'" . elixir-ts-mode)
         ("\\.exs\\'" . elixir-ts-mode)
         ("mix\\.lock\\'" . elixir-ts-mode)))

(use-package heex-ts-mode
  :mode ("\\.heex\\'" . heex-ts-mode))

(use-package js
  :ensure nil
  :mode (("\\.cjs\\'" . js-ts-mode)
         ("\\.js\\'" . js-ts-mode)
         ("\\.jsx\\'" . js-ts-mode)
         ("\\.mjs\\'" . js-ts-mode)))

(use-package nix-ts-mode
  :mode ("\\.nix\\'" . nix-ts-mode))

(use-package rust-ts-mode
  :ensure nil
  :mode ("\\.rs\\'" . rust-ts-mode))

(use-package typescript-ts-mode
  :ensure nil
  :mode (("\\.cts\\'" . typescript-ts-mode)
         ("\\.mts\\'" . typescript-ts-mode)
         ("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode)))

(use-package clang-format
  :preface
  (defun susan/clang-format-on-save ()
    (add-hook 'before-save-hook #'clang-format-buffer nil t))
  :hook ((c-mode . susan/clang-format-on-save)
         (c++-mode . susan/clang-format-on-save)
         (c-ts-mode . susan/clang-format-on-save)
         (c++-ts-mode . susan/clang-format-on-save)))

(use-package direnv
  :config
  (direnv-mode 1))

(use-package agent-shell
  :demand t
  :bind ("C-c a" . agent-shell)
  :config
  (require 'agent-shell-openai)
  (require 'agent-shell-opencode)
  (setq agent-shell-session-restore-verbosity 'full
        agent-shell-openai-authentication
        (agent-shell-openai-make-authentication :login t)
        agent-shell-opencode-authentication
        (agent-shell-opencode-make-authentication :none t)
        agent-shell-agent-configs
        (list (agent-shell-openai-make-codex-config)
              (agent-shell-opencode-make-agent-config))))

(defun susan/setup-ghostel-buffer ()
  (display-line-numbers-mode -1)
  (visual-line-mode -1)
  (setq-local bidi-display-reordering nil
              bidi-paragraph-direction 'left-to-right)
  ;; Calling this even when already nil marks the buffer as explicitly opted
  ;; out, so `meow-global-mode' does not re-enable it after `ghostel-mode-hook'.
  (when (fboundp 'meow-mode)
    (funcall 'meow-mode -1)))

(defun susan/new-ghostel ()
  (interactive)
  (require 'ghostel)
  (funcall 'ghostel t))

(defun susan/ghostel-exec (argv)
  (unless argv
    (user-error "No command supplied"))
  (require 'ghostel)
  (let ((buffer (generate-new-buffer (symbol-value 'ghostel-buffer-name))))
    (pop-to-buffer buffer (append display-buffer--same-window-action
                                  '((category . comint))))
    (funcall 'ghostel-exec buffer (car argv) (cdr argv))))

(use-package ghostel
  :hook (ghostel-mode . susan/setup-ghostel-buffer)
  :bind (("C-c t" . ghostel)
         :map ghostel-semi-char-mode-map
         ("C-x C-q" . ghostel-send-next-key)))

(use-package meow
  :config
  (setq meow-keypad-leader-dispatch "C-c")

  (meow-motion-overwrite-define-key
   '("h" . meow-next)
   '("a" . meow-prev)
   '("<escape>" . ignore))

  (meow-leader-define-key
   '("?" . meow-cheatsheet)
   '("c" . meow-keypad-start)
   '("h" . meow-keypad-describe-key)
   '("m" . meow-keypad-describe-mode))

  ;; Gallium v2 normal/Rowstag, translated by physical QWERTY key position.
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("1" . meow-expand-1)
   '("2" . meow-expand-2)
   '("3" . meow-expand-3)
   '("4" . meow-expand-4)
   '("5" . meow-expand-5)
   '("6" . meow-expand-6)
   '("7" . meow-expand-7)
   '("8" . meow-expand-8)
   '("9" . meow-expand-9)
   '("-" . negative-argument)
   '("i" . meow-reverse)
   '("'" . meow-inner-of-thing)
   '(";" . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("n" . meow-append)
   '("N" . meow-open-below)
   '("z" . meow-back-word)
   '("Z" . meow-back-symbol)
   '("m" . meow-change)
   '("t" . meow-delete)
   '("T" . meow-backward-delete)
   '("d" . meow-next-word)
   '("D" . meow-next-symbol)
   '("s" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("y" . meow-left)
   '("Y" . meow-left-expand)
   '("o" . meow-insert)
   '("O" . meow-open-above)
   '("h" . meow-next)
   '("H" . meow-next-expand)
   '("a" . meow-prev)
   '("A" . meow-prev-expand)
   '("e" . meow-right)
   '("E" . meow-right-expand)
   '("p" . meow-join)
   '("k" . meow-search)
   '("u" . meow-block)
   '("U" . meow-to-block)
   '("," . meow-yank)
   '("b" . meow-quit)
   '("B" . meow-goto-line)
   '("c" . meow-replace)
   '("C" . meow-swap-grab)
   '("r" . meow-kill)
   '("v" . meow-till)
   '("f" . meow-undo)
   '("F" . meow-undo-in-selection)
   '("w" . meow-visit)
   '("l" . meow-mark-word)
   '("L" . meow-mark-symbol)
   '("q" . meow-line)
   '("Q" . meow-goto-line)
   '("j" . meow-save)
   '("J" . meow-sync-grab)
   '("x" . meow-pop-selection)
   '("/" . repeat)
   '("<escape>" . ignore))

  (meow-global-mode 1))

(use-package ligature
  :config
  (add-to-list 'ligature-ignored-major-modes 'ghostel-mode)
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures
   'prog-mode
   '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
     ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
     "-<" "-<<" "-~" "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
     "#_(" ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*" "/**"
     "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
     "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
     "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
     "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
     "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
     "<~" "<~~" "</" "</>" "~@" "~-" "~>" "~~" "~~>" "%%"))
  (global-ligature-mode 1))

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-medium t))

(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :hook (org-mode . org-indent-mode)
  :config
  (setq org-todo-keywords
        '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i)" "BLOCKED(b)"
                    "|" "DONE(d)" "WONT-DO(!)"))
        org-agenda-files '("~/org"))
  (custom-set-faces
   '(org-todo ((t (:inherit font-lock-keyword-face :weight bold :height 0.8))))
   '(org-done ((t (:inherit font-lock-keyword-face :weight bold :height 0.8))))))

(use-package toc-org
  :commands toc-org-enable
  :hook (org-mode . toc-org-enable))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package org-appear
  :commands org-appear-mode
  :hook (org-mode . org-appear-mode)
  :init
  (setq org-hide-emphasis-markers t
        org-appear-autoemphasis t
        org-appear-autolinks t
        org-appear-autosubmarkers t))

(defun susan/shell-command (name command)
  (start-process-shell-command name nil command))

(use-package windmove
  :ensure nil
  :demand t)

(defun susan/screenshot-region-to-clipboard ()
  (interactive)
  (susan/shell-command "screenshot-region"
                       "slurp | grim -g - - | wl-copy"))

(defun susan/screenshot-full-to-clipboard ()
  (interactive)
  (susan/shell-command "screenshot-full"
                       "grim - | wl-copy"))

(defun susan/screenshot-full-to-file ()
  (interactive)
  (susan/shell-command
   "screenshot-full-file"
   "mkdir -p ~/Pictures && grim ~/Pictures/screenshot-$(date +'%Y-%m-%d-%H-%M-%S').png"))

(defun susan/screenshot-region-to-file ()
  (interactive)
  (susan/shell-command
   "screenshot-region-file"
   "mkdir -p ~/Pictures && slurp | grim -g - ~/Pictures/screenshot-slurp-$(date +'%Y-%m-%d-%H-%M-%S').png"))

(defun susan/window-swap (direction)
  (let ((other (windmove-find-other-window direction)))
    (unless other
      (user-error "No window in direction %s" direction))
    (window-swap-states (selected-window) other)
    (select-window other)))

(defun susan/window-swap-up ()
  (interactive)
  (susan/window-swap 'up))

(defun susan/window-swap-down ()
  (interactive)
  (susan/window-swap 'down))

(defun susan/other-frame-backward ()
  (interactive)
  (other-frame -1))

(defun susan/move-buffer-to-other-frame (step)
  (let ((buffer (current-buffer)))
    (other-frame step)
    (switch-to-buffer buffer)))

(defun susan/move-buffer-to-previous-frame ()
  (interactive)
  (susan/move-buffer-to-other-frame -1))

(defun susan/move-buffer-to-next-frame ()
  (interactive)
  (susan/move-buffer-to-other-frame 1))

(defun susan/xdg-apps ()
  (let ((data-dirs
         (cons (or (getenv "XDG_DATA_HOME")
                   (expand-file-name "~/.local/share"))
               (split-string (or (getenv "XDG_DATA_DIRS")
                                 "/usr/local/share:/usr/share")
                             path-separator t)))
        apps)
    (dolist (data-dir data-dirs)
      (let ((app-dir (expand-file-name "applications" data-dir)))
        (when (file-directory-p app-dir)
          (dolist (file (directory-files-recursively app-dir "\\.desktop\\'"))
            (with-temp-buffer
              (insert-file-contents file)
              (goto-char (point-min))
              (when (re-search-forward "^Name=\\(.+\\)$" nil t)
                (let ((name (match-string 1)))
                  (goto-char (point-min))
                  (unless (re-search-forward "^NoDisplay=true$" nil t)
                    (push (propertize name 'susan/desktop-file file)
                          apps)))))))))
    (delete-dups apps)))

(defun susan/launch-xdg-app (app)
  (when-let ((desktop-file (get-text-property 0 'susan/desktop-file app)))
    (let ((process-connection-type nil))
      (start-process "xdg-app" nil "gio" "launch" desktop-file))))

(defun susan/reka-key-to-xkb (key-string)
  "Convert KEY-STRING for Reka, including modified symbolic keys."
  (let* ((event (aref (kbd key-string) 0))
         (basic (event-basic-type event))
         (mods (mapcar (lambda (mod)
                         (alist-get mod reka--modifier-bits))
                       (event-modifiers event)))
         (key (cond
               ((characterp basic) basic)
               ((and basic (symbolp basic)) (symbol-name basic))
               ((symbolp event)
                (replace-regexp-in-string
                 "\\`\\(?:A-\\|C-\\|H-\\|M-\\|s-\\|S-\\)+" ""
                 (symbol-name event)))
               (t (user-error "Unsupported Reka key: %s" key-string)))))
    (list event key (apply #'logior mods))))

(defun susan/setup-reka-buffer ()
  "Keep Reka's external-window buffers out of Meow's modal states."
  (when (fboundp 'meow-mode)
    (funcall 'meow-mode -1)))

(defun susan/reka-select-created-window (window)
  "Select WINDOW after Reka displays a newly managed Wayland surface."
  (when (window-live-p window)
    (select-window window 'norecord))
  window)

(defvar susan/reka--frame-focus-state
  (make-symbol "reka-frame-focus")
  "Cache marker for focus directed to an Emacs frame.")

(defvar susan/reka--focus-timer nil
  "Pending timer for a coalesced Reka focus update.")

(defun susan/reka--apply-focus-request ()
  "Send the latest safe focus request to Reka."
  (setq susan/reka--focus-timer nil)
  (when reka-handle
    (let* ((buffer (window-buffer (selected-window)))
           (can-focus-window
            (and (reka--is-reka-buffer buffer)
                 (not this-command)
                 (= 0 (length unread-command-events))
                 (= 0 (length (this-single-command-keys)))
                 (= 0 (minibuffer-depth))
                 (= 0 (recursion-depth))))
           (state (if can-focus-window
                      buffer
                    susan/reka--frame-focus-state)))
      (unless (eq state reka--last-focused)
        (reka-set-focus-request
         reka-handle
         (when can-focus-window
           (buffer-local-value 'reka-window buffer)))
        (setq reka--last-focused state)))))

(defun susan/reka-update-focus-request (&rest _)
  "Coalesce Reka focus updates until the current command has finished."
  (unless (timerp susan/reka--focus-timer)
    (setq susan/reka--focus-timer
          (run-at-time 0 nil #'susan/reka--apply-focus-request))))

(use-package reka
  :ensure nil
  :if (and (getenv "REKA_SESSION") (locate-library "reka"))
  :demand t
  :hook (reka-mode . susan/setup-reka-buffer)
  :bind (("s-<return>" . susan/new-ghostel)
         ("s-S-<return>" . consult-buffer)
         ("s-y" . windmove-left)
         ("s-h" . windmove-down)
         ("s-a" . windmove-up)
         ("s-e" . windmove-right)
         ("s-S-y" . susan/other-frame-backward)
         ("s-S-e" . other-frame)
         ("s-S-a" . susan/window-swap-up)
         ("s-S-h" . susan/window-swap-down)
         ("C-s-y" . susan/move-buffer-to-previous-frame)
         ("C-s-e" . susan/move-buffer-to-next-frame)
         ("C-s-a" . susan/window-swap-up)
         ("C-s-h" . susan/window-swap-down)
         ("s-S-c" . kill-current-buffer)
         ("<print>" . susan/screenshot-region-to-clipboard)
         ("C-<print>" . susan/screenshot-full-to-clipboard)
         ("S-<print>" . susan/screenshot-full-to-file)
         ("s-S-<print>" . susan/screenshot-region-to-file))
  :init
  (setq reka-intercept-prefixes
        '("s-<return>" "s-S-<return>"
          "s-y" "s-h" "s-a" "s-e"
          "s-S-y" "s-S-h" "s-S-a" "s-S-e" "s-S-c"
          "C-s-y" "C-s-h" "C-s-a" "C-s-e"
          "<print>" "C-<print>" "S-<print>" "s-S-<print>"))
  :config
  (advice-add 'reka--key-to-xkb :override #'susan/reka-key-to-xkb)
  (advice-add 'reka--create-buffer :filter-return
              #'susan/reka-select-created-window)
  (advice-add 'reka--update-focus-request :override
              #'susan/reka-update-focus-request)

  ;; Reloading the config re-enables Meow globally before reaching Reka.
  ;; Re-apply the external-buffer opt-out to wrappers which already exist.
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when (derived-mode-p 'reka-mode)
        (susan/setup-reka-buffer))))

  ;; `early-default.el' starts Reka before pwayl creates its first frame.
  ;; It deliberately leaves compositor bindings empty until this config has
  ;; installed the complete key conversion and intercept list.
  (when (bound-and-true-p susan/reka-early-bootstrap)
    (setq susan/reka-early-bootstrap nil)
    (reka-push-intercept-prefixes))

  (defvar consult-source-xdg-apps
    `(:name "Apps"
      :narrow ?a
      :category app
      :items ,(lambda ()
                (sort (susan/xdg-apps) #'string-lessp))
      :action ,#'susan/launch-xdg-app))

  (setq consult-buffer-sources
        (append (delq 'consult-source-xdg-apps consult-buffer-sources)
                '(consult-source-xdg-apps)))

  (unless reka-handle
    (reka-enable)))
