;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "English")
 '(fringe-mode 0 nil (fringe))
 '(global-font-lock-mode t nil (font-lock))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil nil (tool-bar))
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

; don't open new frames when opening files in aquamacs
(setq one-buffer-one-frame-mode nil)

; use cmd as meta in aquamacs
(setq-default mac-command-modifier 'meta)
(setq-default mac-option-modifier nil)

; use a box cursor
(setq cursor-type 'box)
(setq default-cursor-type 'box)

; GRB: append my emacs lisp path to the load-path
(setq load-path (cons "~/.emacs-lisp" load-path))

; GRB: load python mode
(load-file "~/.emacs-lisp/python-mode.el")
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

; GRB: load rest mode
(autoload 'rst-mode "~/.emacs-lisp/rst-mode" "mode for editing reStructuredText documents" t)
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
		("\\.rest$" . rst-mode)) auto-mode-alist))

; GRB: no tabs
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)
(setq-default default-tab-width 4)

; GRB: confirm exit
;(setq confirm-kill-emacs #'yes-or-no-p)

; GRB: C-style indentation in CSS mode
(setq cssm-indent-function #'cssm-c-style-indenter)

; GRB: set the font.  See these messages:
;  http://lists.sourceforge.jp/mailman/archives/macemacsjp-english/2007-January/000858.html
;  http://lists.sourceforge.jp/mailman/archives/macemacsjp-english/2007-January/000860.html
; (require 'carbon-font)
; (add-to-list 'default-frame-alist
;  	     '(font . "-*-*-medium-r-normal--10-*-*-*-*-*-fontset-osaka"))

(global-set-key "\C-cb" 'gary-insert-comment)

; GRB: keybindings
(global-set-key (quote [?\e ?g]) (quote goto-line))
(global-set-key '[?\e ?(] 'start-kbd-macro)
(global-set-key '[?\e ?)] 'end-kbd-macro)
(global-set-key [?\e ?n] 'call-last-kbd-macro)

; GRB: cycle through selective-display levels
(setq selective-display-level 0)
(setq selective-display-increment 4)
(setq max-selective-display-level 8)
(defun switch-selective-display ()
  "Switch to the next selective display level, starting over if appropriate"
  (if (>= selective-display-level max-selective-display-level)
      (setq selective-display-level 0)
    (setq selective-display-level
          (+ selective-display-increment
             selective-display-level)))
  (interactive)
  (set-selective-display selective-display-level))
(global-set-key "\M-c" 'switch-selective-display)

; GRB: use html-mode for kid templates
(add-to-list 'auto-mode-alist '("\\.kid?\\'" . html-mode))

; GRB: turn off menu bar
(menu-bar-mode nil)

(autoload 'psvn "psvn:w" "PSVN")

(setq viper-mode nil)                ; enable Viper at load time
;(setq viper-ex-style-editing nil)  ; can backspace past start of insert / line
(require 'viper)                   ; load Viper
(require 'vimpulse)                ; load Vimpulse
(require 'redo)			   ; enable vim-style redo
(require 'rect-mark)		   ; enable prettier rectangular selections

; GRB: don't go into insert mode for shells, because that trips me up
; when I expect to be able to use C-w to switch through all my windows
;(delq 'shell-mode viper-insert-state-mode-list)
;(delq 'eshell-mode viper-insert-state-mode-list)

; GRB: resize and move the window if we're in a windowing system
(defun resize-frame ()
  "Resize current frame"
  (interactive)
  (set-frame-size (selected-frame) 239 68))
(defun move-frame ()
  "Move current frame"
  (interactive)
  (set-frame-position (selected-frame) 0 0))
(if (not (eq window-system 'nil))
    (progn
     (move-frame)
     (resize-frame)))

; GRB: split the windows
(progn
  (interactive)
  (split-window-horizontally 80)
  (other-window 1)
  ;(split-window-horizontally 80)
  ;(other-window 1)
  (split-window)
  (other-window 1)
  (eshell)
  (other-window -3))

; GRB: use C-o and M-o to switch windows
(global-set-key "\C-o" 'other-window)
(defun prev-window ()
  (interactive)
  (other-window -1))
(global-set-key "\M-o" 'prev-window)

; GRB: turn off VC mode completely
(set-variable 'vc-handled-backends ())

; GRB: highlight trailing whitespace
(set-default 'show-trailing-whitespace t)

; GRB: open temporary buffers in a dedicated window split
(setq special-display-regexps
        '("^\\*Completions\\*$"
          "^\\*Help\\*$"
          "^\\*grep\\*$"
          "^\\*Apropos\\*$"
          "^\\*elisp macroexpansion\\*$"
          "^\\*local variables\\*$"
          "^\\*Compile-Log\\*$"
          "^\\*Quail Completions\\*$"
          "^\\*Occur\\*$"
          "^\\*frequencies\\*$"
          "^\\*compilation\\*$"
          "^\\*Locate\\*$"
          "^\\*Colors\\*$"
          "^\\*tumme-display-image\\*$"
          "^\\*SLIME Description\\*$"
          "^\\*.* output\\*$"           ; tex compilation buffer
          "^\\*TeX Help\\*$"
          "^\\*Shell Command Output\\*$"
          "^\\*Async Shell Command\\*$"
          "^\\*Backtrace\\*$"))
(setq grb-temporary-window (nth 2 (window-list)))
(defun grb-special-display (buffer &optional data)
  (let ((window grb-temporary-window))
    (with-selected-window window
      (switch-to-buffer buffer)
      window)))
(setq special-display-function #'grb-special-display)

; Unset cmd-space
(global-unset-key (quote [67108896]))

; GRB: Don't show the startup screen
(setq inhibit-startup-message t)

; GRB: always fill at 78 characters
(add-hook 'text-mode-hook #'turn-on-auto-fill)
(setq-default fill-column 78)

;(require 'color-theme)
;(color-theme-pok-wog)
;(color-theme-robin-hood)

; map gw to fill region like it does in vim
(define-key viper-vi-global-user-map "gw" 'fill-region)

(setq-default auto-fill-function
              (lambda ()
                (do-auto-fill)
                (set-window-hscroll
                 (selected-window) 0)))

; by default, grep into compressed files if possible when using M-x
; grep
(setq-default grep-command "zgrep -nH -e ")

(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e))
