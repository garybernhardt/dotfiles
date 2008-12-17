;;; vimpulse.el --- emulates Vim's most useful features, including Visual mode

;; Copyright (C) 2007 Alessandro Piras and Brad Beveridge
;; 
;; Version: 0.2.0.1
;; Keywords: emulations
;; Human-Keywords: vim, visual-mode, rsi, ergonomics, Emacs pinky finger
;; Author: Alessandro Piras <laynor@gmail.com>
;; Maintainer: Jason Spiro <jasonspiro3@gmail.com>
;; Compatibility: Works on GNU Emacs 22.x; probably works elsewhere too
;; URL: http://www.emacswiki.org/elisp/vimpulse.el
;; 
;; This file is not part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation; either version 2 of the License, or any later version.
;;
;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.
;;
;; You should have received a copy of the GNU General Public License along with
;; this program; if not, write to the Free Software Foundation, Inc., 59 Temple
;; Place - Suite 330, Boston, MA 02111-1307, USA.

;;; Acknowledgements:

;; - Alessandro Piras <laynor@gmail.com> wrote vimpulse.
;; 
;; - Brad Beveridge <brad.beveridge@gmail.com> contributed some code.
;; 
;; - Jason Spiro <jasonspiro3@gmail.com> wrote all the top-of-file
;;   comments e.g. Installation, Usage, etc.  He has released his
;;   contributions to the public domain, so he is not listed in the
;;   copyright statement.
;;
;; - cppjavaperl <cppjavaperl@yahoo.com> added the tiny bits to 
;;   support rudimentary visual block mode, and a minor correction/addition
;;   to make completion keys C-n and C-p behave more like Vim.
;; 
;; We love patches.  Would you like to see your name here?  Please
;; send code and/or documentation patches to the maintainer.  Ideas,
;; comments, and test results are appreciated too.
;; 
;; Special thanks to Michael Kifer and all those who have contributed
;; to viper-mode.

;;; Commentary:

;; Vimpulse emulates Vim's most useful features, including Visual
;; mode.  Vimpulse a set of modifications to viper, the minor mode
;; that emulates Vi.  Vimpulse is not a minor mode; as soon as it is
;; loaded, viper will start working in a more Vim-like way.
;; 
;; The design plan for Vimpulse is for it to only emulate features
;; that are in Vim.  Unfortunately, other new features do not belong
;; in Vimpulse unless you can get the Vim people to implement those
;; features too.
;; 
;; Vimpulse is beta software.  It seems to work quite well already
;; though.

;;; Installation:

;; Copy vimpulse.el to somewhere in your load-path (e.g. your
;; site-lisp directory), then add these three Lisp statements to the
;; .emacs file in your home directory:
;; 
;(setq viper-mode t)
;(require 'viper)
;(require 'vimpulse)
;; 
;; Leave out the initial semicolons.  You should not change the order
;; of the statements.  The first two lines enable viper; the third
;; enables vimpulse.
;; 
;; If you will be using C-r (the redo key) and you use GNU Emacs, also
;; visit http://www.wonderworks.com/download/redo.el and save and
;; install redo.el.  XEmacs and Aquamacs come with redo.el included.
;;
;; If you want block visual mode (i.e. rectangle selection), 
;; remove the leading semicolons from the lines under the 
;; "Block Visual Mode keys" section in this file.  Also download and 
;; install http://www.emacswiki.org/elisp/download/rect-mark.el 
;; in your load-path and add the Lisp expression (require 'rect-mark)
;; to your .emacs file. 
;;
;; Then you can use C-v to go into block visual
;; mode, C-y to yank the rectangular selection, and C-p to paste the 
;; yanked rectangle of text.  C-y and C-p are used because it was a 
;; simple way to add visual block mode in a way *close* to Vim 
;; without having to hack viper mode to use the normal 'y' and 'p'
;; keys.  (If you map 'y' and 'p' instead, it screws up viper's 
;; "normal" yanking and pasting [non-visual mode]).  In the future,
;; it would be nice to see vimpulse provide this the "right" way,
;; but at this point I'm too inexperienced with elisp to make that
;; happen.
;;
;;   Note that this "implementation" of visual block mode doesn't 
;; support yanking text to a specific register (i.e. "x C-y to yank
;; the selected text to register 'x').  But it appears (at this 
;; point) that none of the visual modes provided by vimpulse provide 
;; that capability (yet). 
;;
;; cppjavaperl (regarding visual block mode instructions)

;; 
;; We would love it if you sent an email to the maintainer telling us
;; whether you liked or disliked vimpulse, and why.

;;; Usage:

;; Tip:
;; 
;; Vimpulse makes C-r run "redo" in command mode but you can still get
;; reverse i-search by pressing C-s then C-r.

;;; Bugs:

;; We would appreciate very much if you report bugs, except for the
;; one-char-off bug which is already a known bug.
;; 
;; Also, Jason Spiro has a little occasionally-irritating problem with
;; the "h" key not going left at certain places on his
;; emacs-snapshot-gtk 22.0.50.1 (Ubuntu package version 20060915-1).
;; To reproduce, he types a closing parenthesis on a line by itself,
;; then goes to end of line, then presses 'h'.  It doesn't happen when
;; he uses plain viper, only when he uses vimpulse.  He uses
;; mic-paren.el, but it still happens even without mic-paren.  He will
;; investigate more later.

;;; Development and documentation TODOs:

;; - add Customize option to let users stop C-r from being redo
;; 
;; - email and try to get redo.el included with GNU Emacs (since I
;;   won't include redo.el here since nobody else includes it in their
;;   Lisp files either)
;; 
;; - copy more features from Brad's work in darcs and from vimpact
;;   into vimpulse
;; 
;; - doc: look in google chat log, find description of one-char-off
;;   bug, see if it applies to this or to the not-yet-released
;;   viper-x, and if to this, mention under Bugs
;; 
;; - doc: fix ref to "your home directory": Windows users don't have
;;   one
;; 
;; - doc: list all new keys (and maybe all differences from viper) in
;;   Usage section
;; 
;; - doc: describe all new keys in Usage section; can look at Vim
;;   manual for ideas
;; 
;; - try to clean up namespace to use only vimpulse- prefix (but do I
;;   need to worry about the viper-visual- stuff, or is that a
;;   separate-enough prefix?)
;; 
;; - once one-char-off bug is fixed, if there are no more known bugs,
;;   bump version to 0.9
;; 
;; - try to get vimpulse included with upstream viper; also, ideally,
;;   if you pressed "v" in viper, viper would offer to load vimpulse.
;;   (likely to happen?  Consider that Kifer, the viper maintainer,
;;   told me he doesn't need vim keys.  Then again, maybe I could
;;   convince him that it's worth it to ship vim keys, for other
;;   people's benefit.)

;;; Development questions:

;; - In vimpulse, like in real vim, C-r only does redo in command
;;   mode; in insert mode it does something else.  (In vimpulse that
;;   "something else" is reverse i-search.)  Should it do reverse
;;   i-search in insert mode too?
;; 
;; - When you press "v" for visual mode, Vimpulse modifies the mode
;;   section of the modeline, so it reads e.g. "(Emacs-Lisp visual)".
;;   Shouldn't it do something to the <V> indicator instead?

;;; Change Log:

;; Version 0.2.0.1: changes submitted by cppjavaperl:
;;  - Added support for block visual mode (i.e. rectangle selection).
;;  - Made C-p look for matches *prior* to the cursor, added C-n
;;    binding to look for matches *before* the cursor.  This works 
;;    more like Vim does.

;; Version 0.2.0.0: Brad merged in several changes, including:
;;  - exit visual mode when the mark deactivates
;;  - changed the window manipulation to be global
;;  - added gf (goto file at point)
;;  - added \C-] and \C-t, tag jump & pop
;;  - added a helper function for defining keys
;;  - commented out show-paren-function, what is it meant to do?

;; Version 0.1.0.1: No code changes.  Small documentation changes,
;; including updates on moving-left bug.

;; Version 0.1: Initial release.

;;; Code:

;; Begin visual mode code {{{

;; local variables
(eval-when-compile (require 'easy-mmode))
(require 'advice)
(defgroup viper-visual nil
  "visual-mode for viper"
  :prefix "viper-visual-"
  :group 'emulations)

 (define-minor-mode viper-visual-mode
  "Toggles visual mode in viper"
  :lighter " visual"
  :initial-value nil
  :global nil
  :group 'viper-visual)   
(defvar viper-visual-mode-map (make-sparse-keymap)
  "Viper Visual mode keymap. This keymap is active when viper is in VISUAL mode")
(defvar viper-visual-mode-linewise nil
  "If non nil visual mode will operate linewise")
(defcustom viper-visual-load-hook nil
  "Hooks to run after loading viper-visual-mode."
  :type 'hook
  :group 'viper-visual)

(defadvice viper-move-marker-locally (around viper-move-marker-locally-wrap activate)
 (unless viper-visual-mode
   ad-do-it))

(defadvice viper-deactivate-mark (around viper-deactivate-mark-wrap activate)
 (unless viper-visual-mode
   ad-do-it))

;; this thing is just to silence the byte compiler
;; and stop it bugging about free variable
;; viper--key-maps in emacs 21 :)
(defmacro my-get-emulation-keymap ()
  (if (= emacs-major-version 22)
      'viper--key-maps
    'minor-mode-map-alist))

(defadvice viper-normalize-minor-mode-map-alist (after viper-add-visual-maps activate)
  "This function modifies minor-mode-map-alists to include the visual mode keymap"
    (push (cons 'viper-visual-mode viper-visual-mode-map) (my-get-emulation-keymap)))

;; Keys that differ from normal mode
(defun viper-visual-mode-to-insert-mode () ;TODO: fix behavior to behave like vim
  (interactive)
  (viper-visual-mode 'toggle)
  (viper-change-state-to-insert))

(defun viper-visual-yank-command ()
  (interactive)
  (viper-visual-mode 'toggle)
  (viper-prefix-arg-com ?r 1 ?y))

(defun viper-visual-delete-command ()
  (interactive)
  (viper-visual-mode 'toggle)
  (viper-prefix-arg-com ?r 1 ?d))

(defun viper-visual-change-command ()
  (interactive)
  (viper-visual-mode 'toggle)
  (viper-prefix-arg-com ?r 1 ?c))
 
(defun viper-visual-replace-region (&optional arg)
  (interactive "P")
  (viper-visual-mode 'toggle)
  (cond
   ((= (mark) (point)) nil)
   (t 
    (if (< (mark) (point)) (exchange-point-and-mark))
    (viper-replace-char arg)		
    (let ((c (char-after (point))))
      (dotimes (i (- (mark) (point)))
	(cond
	 ((member (char-after (point)) '(?\r ?\n))
	  (forward-char))
	  (t (delete-char 1)
	     (insert c))))))))

(define-key viper-visual-mode-map "v" 'viper-visual-mode)
(define-key viper-visual-mode-map "V" 'viper-visual-mode)
(define-key viper-visual-mode-map "\C-v" 'viper-visual-mode)
(define-key viper-visual-mode-map "d" 'viper-visual-delete-command)
(define-key viper-visual-mode-map "x" 'viper-visual-delete-command)
(define-key viper-visual-mode-map "D" 'viper-visual-delete-command)
(define-key viper-visual-mode-map "d" 'viper-visual-delete-command)
(define-key viper-visual-mode-map "y" 'viper-visual-yank-command)
(define-key viper-visual-mode-map "i" 'viper-visual-mode-to-insert-mode)
(define-key viper-visual-mode-map "u" 'viper-visual-mode)
(define-key viper-visual-mode-map "c" 'viper-visual-change-command)
(define-key viper-visual-mode-map "F" 'viper-visual-change-command)
(define-key viper-visual-mode-map "c" 'viper-visual-change-command)
(define-key viper-visual-mode-map "C" 'viper-visual-change-command)
(define-key viper-visual-mode-map "s" 'viper-visual-change-command)
(define-key viper-visual-mode-map "S" 'viper-visual-change-command)
(define-key viper-visual-mode-map "r" 'viper-visual-replace-region)
(define-key viper-visual-mode-map "o" 'exchange-point-and-mark)
(define-key viper-visual-mode-map "O" 'exchange-point-and-mark)
;; Keys that have no effect in visual mode
(define-key viper-visual-mode-map "t" 'undefined)
(define-key viper-visual-mode-map "." 'undefined)
(define-key viper-visual-mode-map "T" 'undefined)
(add-hook 'post-command-hook '(lambda ()
				(if (and viper-visual-mode viper-visual-mode-linewise)
				    (beginning-of-line))))
   

;;;###auto-load
(defun viper-visual-mode-toggle(&optional arg)
  (interactive "P")
  (make-local-variable 'viper-visual-mode-linewise)
  (unless viper-visual-mode
    (deactivate-mark)
    (viper-change-state-to-vi))
  (when viper-visual-mode
    (setq viper-visual-mode-linewise nil)
    (set-mark (point))
    ;;(setq viper-visual-linewise line-wise)
    ;;(viper-change-state 'VISUAL)
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;; Force transient-mark-mode to have visual selection ;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    (if (fboundp 'transient-mark-mode)
	(transient-mark-mode t))))

(defun viper-visual-mode-linewise (&optional arg)
  "Starts viper visual mode in `linewise' mode"
  (interactive "P")
  (beginning-of-line)
  (viper-visual-mode 'toggle)
  (setq viper-visual-mode-linewise t))
(add-hook 'viper-visual-mode-hook 'viper-visual-mode-toggle t)
(run-hooks 'viper-visual-load-hook)

;; We need to detect when a command has deactivated the mark so that
;; Vimpulse is able to exit Visual mode
(defun vimpulse-detect-mark-deactivate ()
  (when (and viper-visual-mode (not mark-active))
    (viper-visual-mode 'toggle)))
(add-hook 'deactivate-mark-hook 'vimpulse-detect-mark-deactivate)

(provide 'viper-visual-mode)

;; }}} End visual mode code



 



;; Begin main Vim emulation code {{{

;;;;
;;;; Almost all of this code is taken from extended-viper 
;;;; coded by Brad Beveridge (bradbev@gmail.com)
;;;;

; make :n cycle through buffers on the current window
(setq ex-cycle-other-window nil) 

(define-key viper-vi-global-user-map "gg"   'viper-goto-first-line) 
(define-key viper-vi-global-user-map "zt"   'viper-line-to-top)
(define-key viper-vi-global-user-map "zb"   'viper-line-to-bottom)
(define-key viper-vi-global-user-map "zz"   'viper-line-to-middle)
(define-key viper-vi-global-user-map "*"    'viper-search-forward-for-word-at-point) 
(define-key viper-vi-global-user-map "#"    'viper-search-backward-for-word-at-point) 
(define-key viper-vi-global-user-map " "	nil)
(define-key viper-vi-global-user-map "gf"   'find-file-at-point)
(define-key viper-vi-global-user-map "\C-]" 'viper-jump-to-tag-at-point)
(define-key viper-vi-global-user-map "\C-t" 'pop-tag-mark)

; Map undo and redo from XEmacs' redo.el
(define-key viper-vi-global-user-map "u"    'undo)
(define-key viper-vi-global-user-map "\C-r" 'redo)
(define-key viper-vi-global-user-map "O"	'my-viper-open-new-line-above)
(define-key viper-vi-global-user-map "o"	'my-viper-open-new-line-below)

; Window manipulation
(define-key global-map "\C-w" (make-sparse-keymap))
(define-key global-map "\C-w\C-w" 'viper-cycle-windows)
(define-key global-map "\C-ww" 'viper-cycle-windows)
(define-key global-map "\C-wo" 'delete-other-windows)
(define-key global-map "\C-wc" 'delete-window)

; Block Visual Mode keys
;(define-key viper-vi-global-user-map "\C-y" 'rm-kill-ring-save)
;(define-key viper-vi-global-user-map "\C-v" 'rm-set-mark)
;(define-key viper-vi-global-user-map "\C-p" 'yank-rectangle)

; Insert mode keys
; Vim-like completion keys
(define-key viper-insert-global-user-map "\C-p" 'dabbrev-expand)
(define-key viper-insert-global-user-map "\C-n" 'my-viper-abbrev-expand-after)
(define-key viper-insert-global-user-map [backspace] 'backward-delete-char-untabify)

(defvar viper-extra-ex-commands '(
      ("sp" "split")
      ("split" (split-window))
      ("b" "buffer")
      ("bd" "bdelete")
      ("bdelete" (viper-kill-current-buffer))
      ("bn" "next")
      ("vs" "vsplit")   ; Emacs and Vim use inverted naming conventions for splits :)
      ("vsplit" (split-window-horizontally))
))
    
;;; My code (Alessandro)
(defun my-viper-open-new-line-above (&optional arg)
  (interactive)
  (viper-Open-line arg)
  (indent-according-to-mode))
(defun my-viper-open-new-line-below (&optional arg)
  (interactive)
  (viper-open-line arg)
  (indent-according-to-mode))

;;; His code (Brad)
(defun viper-goto-first-line ()
  "Send point to the start of the first line."
  (interactive)
  (viper-goto-line 1)) 

(defun viper-kill-current-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer nil)) 

(defun viper-cycle-windows ()
  "Cycle point to another window."
  (interactive) 
  (select-window (next-window)))

(defun viper-search-for-word-at-point (forward)
  "Search forwards or bacward for the word under point."
  (let ((word (thing-at-point 'word)))
    (setq viper-s-string word)
    (setq viper-s-forward forward)
    (viper-search word forward 1))) 

(defun viper-search-forward-for-word-at-point ()
  (interactive)
  (viper-search-for-word-at-point t))

(defun viper-search-backward-for-word-at-point ()
  (interactive)
  (viper-search-for-word-at-point nil))

;;; Manipulation of Vipers functions by using the advice feature
;;; Many of the functions here rely as heavily on Viper's internals as Viper itself
;;; Additional Ex mode features.
;;; ex-token-alist is defined as a constant, but it appears I can safely push values to it!
(require 'advice)
(defadvice viper-ex (around viper-extended-ex-commands (arg &optional string) activate)
  ad-do-it) 

(setq ex-token-alist (append viper-extra-ex-commands ex-token-alist))
;;End of Brad's code


;;; cppjavaperl's code
(defun my-viper-abbrev-expand-after ()
  (interactive)
  (dabbrev-expand -1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	Paren Matching workaround to work more like viper                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FIXME: What is this code _trying_ to do?  It some bugs with deleting ()'s 
;; FIXME: it advances the cursor (and let it there on unmatched paren!)
;; (defadvice show-paren-function (around viper-add-visual-maps activate)
;;   "modifies paren matching under viper to work like in (almost) like in vim"
;;   (if viper-vi-basic-minor-mode
;;       (cond
;;        ((= (char-after (point)) ?\)) ;; FIXME!!!!!
;; 	(forward-char)
;; 	ad-do-it
;; 	(backward-char))
;;        ((= (char-after (- (point) 1)) ?\)) nil)
;;        (t ad-do-it))
;;     ad-do-it))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;; VISUAL MODE HACKS ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key viper-vi-basic-map "v" 'viper-visual-mode)
(define-key viper-vi-basic-map "V" 'viper-visual-mode-linewise)

;; We need to detect when a command has deactivated the mark so that
;; Vimpulse is able to exit Visual mode
(defun vimpulse-detect-mark-deactivate ()
  (when (and viper-visual-mode (not mark-active))
    (viper-visual-mode 'toggle)))
(add-hook 'deactivate-mark-hook 'vimpulse-detect-mark-deactivate)

;; Define a helper function that sets up the viper keys in a given map.
;; This function is useful for creating movement maps or altering existing
;; maps
(defun vimpulse-set-movement-keys-for-map (map)
  (define-key map "\C-d" 'viper-scroll-up)
  (define-key map "\C-u" 'viper-scroll-down)
  (define-key map "j" 'viper-next-line)
  (define-key map "k" 'viper-previous-line)
  (define-key map "l" 'viper-forward-char)
  (define-key map "h" 'viper-backward-char))

;; EXAMPLE, the following lines enable Vim style movement in help
;; and dired modes.
;; create a movement map and set the keys
;(setq vimpulse-movement-map (make-sparse-keymap))
;(vimpulse-set-movement-keys-for-map vimpulse-movement-map)
;(viper-modify-major-mode 'dired-mode 'emacs-state vimpulse-movement-map) 
;(viper-modify-major-mode 'help-mode 'emacs-state vimpulse-movement-map)

;; }}} End main Vim emulation code

(provide 'vimpulse)
