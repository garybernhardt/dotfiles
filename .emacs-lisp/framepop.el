;;; framepop.el --- display temporary buffers in a dedicated frame

;; Copyright (C) 1994 Free Software Foundation, Inc.

;; Author: David Smith <maa036@lancaster.ac.uk>
;; Maintainer: David Smith <maa036@lancaster.ac.uk>
;; Created: 8 Oct 1993
;; Modified: $Date: 1994/03/01 12:14:00 $
;; Version: $Revision: 2.12 $
;; RCS-Id: $Id: framepop.el,v 2.12 1994/03/01 12:14:00 maa036 Exp $
;; Keywords: help
;; LCD Archive Entry:
;; framepop|Dave M. Smith|dsmith@stats.adelaide.edu.au|
;; Display temporary buffers in a dedicated frame|
;; 21-Feb-1994|2.12|~/misc/framepop.el.Z|

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; 1. PURPOSE

;; Defines temp-buffer-show-function to display buffers in a dedicated
;; temporary frame (and so requires a display which can accomodate
;; separate frames). The frame is automatically shrink-wrapped to just
;; contain the buffer (restricted to a maximum and minimum
;; size). Buffers thus affected include *Help*, completion buffers and
;; buffer listings.
;;
;; Commands are provided for manipulating the FramePop frame:
;; scrolling, resizing, window manager functions, and also a facility
;; for copying the displayed buffer. You need never lose that handy
;; *Help* buffer again!

;; 2. INSTALLATION

;; To make use of this package, place this file in your load-path,
;; byte-compile it *before* loading it (or do M-x ad-deactivate-all
;; first), and add the following line to your .emacs:
;;
;;   (cond (window-system (require 'framepop)))

;; Several user functions are defined and stored in framepop-map. You
;; will probably want to bind these to keys with (for example) the
;; following command in your .emacs:
;;
;;   (define-key global-map [f1] framepop-map)
;;
;; Type M-x framepop-display-help (bound to `?' in framepop-map) for
;; more information.

;; 3. CUSTOMIZATION

;; The maximum and minimum height of the framepop buffer are
;; determined by the user options framepop-max-frame-size and
;; framepop-min-frame-size.

;; The variable framepop-frame-parameters holds the FramePop frame
;; parameters. You can define colours, fonts and positions for the
;; FramePop frame here. For example, you could place the following in
;; your .emacs:
;;
;;   (setq framepop-frame-parameters
;;      '((name . nil)                     ; use buffer name
;;        (unsplittable . t)               ; always include this
;;        (menu-bar-lines . 0)             ; no menu bar
;;        (minibuffer . nil)               ;    or minubuffer
;;        (left . -1)                      ; top left corner of screen,
;;        (top . 30)                       ;    away from my main frame
;;        (width . 71)                     ; narrower, so it fits nicely
;;        (background-color . "orchid4")   ; I like purple. So sue me.
;;        (foreground-color . "cornsilk")  
;;        (font . "-*-courier-bold-o-*-*-12-*-*-*-m-*-*-*")))

;; There are lots of nifty things that can be done with the advice
;; package to make FramePop work that much better. Many such things
;; will be done for you automatically if you
;;
;;   (require 'advice)
;;
;; before loading the framepop package. See the end of this file
;; ("Customizations using advice") for more details.

;; Buffer names listed in the variable framepop-do-not-display-list
;; will not be displayed in the framepop-frame by default.
;;
;; You may set the variable framepop-auto-resize to t to have the
;; FramePop frame automatically resize to accomodate buffers which
;; change size. If you do not, initially empty buffers (which are
;; likely to grow) get a FramePop frame of full size.
;;
;; Alternatively, for greater control over the behaviour of the
;; framepop frame, you can redefine the variable framepop-lines to a
;; lambda expression which will return the desired height of a buffer
;; to be displayed in the framepop frame. It may also return nil,
;; meaning that the buffer should not be displayed in the FramePop
;; frame, but in an ordinary window instead. The default value of this
;; lambda expression is the number of lines in the buffer, except that
;; empty buffers and compilation buffers (both of which are likely to
;; grow) get full size. You may wish to disable this feature, or
;; perhaps make other constraints based on buffer mode, etc. For
;; example, placing the following in your .emacs will force the
;; framepop frame to have as many lines as the buffer being displayed
;; provided it is not the *Completions* buffer (which will not be
;; displayed in the FramePop frame at all):
;;
;;   (setq framepop-lines
;;     '(lambda (buf)
;;   	 (if (string= (buffer-name buf) "*Completions*") nil
;;   	   (save-excursion
;;   	     (set-buffer buf)
;;   	     (+ (count-lines (point-min) (point-max)) 1)))))
;;         
;; This will cause empty buffers to have the minimum height, because
;; the maximum and minimum frame sizes (as specified in
;; framepop-max-frame-size and framepop-min-frame-size) are enforced
;; independently of framepop-lines. To get around this, define advice
;; around the function framepop-frame-height.
;;
;; The default value of framepop-lines is framepop-default-lines

;; 5. AVAILABILITY
;;
;; The latest version of framepop.el is available from (in increasing
;; order of likelihood):
;;
;; By WWW:
;;    http://mathssun5.lancs.ac.uk:2080/~maa036/elisp/dir.html 
;; By anonymous FTP:
;;    /anonymous@wingra.stat.wisc.edu:pub/src/emacs-lisp/framepop.el.gz
;; Or from the Emacs-Lisp archive.

;; 6. BUGS: 
;;
;; 1. For some weird reason, if framepop-toggle-frame is bound to a
;;    single-event key, you need to press that key *twice* to
;;    deiconify the frame.
;; 2. It'd be nice to make the popup frame invisible instead of simply
;;    iconifying or lowering it, but make-frame-visible is buggy...
;; 3. Sometimes, the mouse pointer will end up within the newly
;;    created or sized FramePop frame. This will stuff up continuing
;;    minibuffer entries or key sequences, which is a pain in the arse. A
;;    really gross hack has been implemented to counteract this: the
;;    mouse pointer is warped if this occurs. It's not foolproof.
;; 5. framepop-pull-down apparently does not work as advertised, and
;;    has strange behaviour when the current buffer is the same as the
;;    framepop buffer. In some situations, it can cause core dumps. This
;;    is apparently an Emacs 19.22 bug.  If you are willing to trust it,
;;    set the variable framepop-pull-down-crashes to nil
;; 6. I'd like to redefine framepop-wrap so that it saves the window
;;    configuration, displays the requested buffer in the framepop-frame,
;;    and then restores the window configuration. But that's another job
;;    for another version
;; 7. There is no section 4 in the introductory comments.
;;
;; Report bugs, fixes, suggestions, praise etc., to be kept informed
;; of new versions, or just to say you like this package, send mail
;; to the author with M-x framepop-submit-feedback. Go on, do it now!
;; --- I just like getting mail, actually.

;;; Code:

(defconst framepop-version (substring "$Revision: 2.12 $" 11 -2)
  "The revision number of the framepop package.

The complete RCS ID is:
$Id: framepop.el,v 2.12 1994/03/01 12:14:00 maa036 Exp $")

;;; Customizable variables

(defvar framepop-max-frame-size 35
  "*Maximum height of the FramePop frame")

(defvar framepop-min-frame-size 5
  "*Minimum height of the FramePop frame")

(defvar framepop-auto-resize nil
  "*If non-nil, the FramePop frame will dynamically resize for changing buffers")

;; If you want the title of the FramePop frame to be *Help* or
;; *Completions* or whatever, remove the (name . "FRAMEPOP") parameter
;; in framepop-frame-parameters below.
;;
;; If you want the FramePop frame to autoraise when selected,
;; uncomment the approprate line below
;;
;; Colours and positions are also good things to set here. There
;; should be no "height" parameter.

(defvar framepop-frame-parameters '((name . "FRAMEPOP") 
				    (unsplittable . t) ; always include this
				    (width . 80) ; this parameter is needed
				    ;;(auto-raise . t)
				    (menu-bar-lines . 0)
				    (minibuffer . nil))
  "Default parameters used in with the FramePop frame")

(defvar framepop-lines 
  'framepop-lines-default
  "Lambda expression of one argument BUF, returning the number of lines
the framepop frame should have to display BUF. If nil is returned, BUF is
not displayed in the framepop frame.")

(defvar framepop-do-not-display-list '("*BBDB*" "*Buffer List*")
  "List of buffer names which will not appear in the FramePop frame.
This behaviour is implemented by the function framepop-lines-default")

;;; Variables controlling gross hacks

(defvar framepop-hack-help-buffer-title t
  "Try and produce sensible names for copied help buffers")

(defvar framepop-warp-pointer t
  "*If non-nil, warp the mouse pointer if necessary to avoid the FramePop frame
being selected")

(defvar framepop-warp-to 'topleft
  "*Place in the selected frame to warp the cursor to, when necessary
Choose from 'topleft 'topright 'botleft and 'botright. This will be changed
automatically if necessary.")

(defvar framepop-pull-down-crashes t
  "*Set to nil of you're willing to trust framepop-pull-down not to coredump.
On my system it does it all the time.")

;;; System variables

(defvar framepop-in-wrap nil
  "Flag set to t during the execution of commands wrapped with framepop-wrap")

(defvar framepop-last-displayed-buffer ""
  "Name of last buffer displayed in temp frame")

(defvar framepop-map nil)
(if framepop-map nil
  (setq framepop-map (make-sparse-keymap))
  (define-key framepop-map "?" 'framepop-display-help)
  (define-key framepop-map "s" 'framepop-show-frame)
  (define-key framepop-map "d" 'framepop-delete-frame)
  (define-key framepop-map "i" 'framepop-make-invisible-frame)
  (define-key framepop-map "w" 'framepop-resize-frame)
  (define-key framepop-map "g" 'framepop-grow)
  (define-key framepop-map "c" 'framepop-copy-frame)
  (define-key framepop-map "/" 'framepop-pull-down)
  (define-key framepop-map ">" 'framepop-eob)
  (define-key framepop-map "<" 'framepop-bob)
  (define-key framepop-map "v" 'framepop-scroll-frame)
  (define-key framepop-map "l" 'framepop-lower-frame)
  (define-key framepop-map "r" 'framepop-raise-frame)
  (define-key framepop-map "x" 'framepop-iconify-frame)
  (define-key framepop-map "z" 'framepop-toggle-frame)
  (define-key framepop-map "b" 'framepop-display-buffer))

(defvar framepop-frame nil)

;;; Shut up the byte compiler

(eval-when-compile 
  (require 'compile)
  (require 'advice)
  (require 'reporter))

;;; System functions

(defun framepop-frame-height (buf)
  "Return the desired height of a FramePop frame showing buffer BUF
Enforces the limits set by framepop-max-frame-size and framepop-min-frame-size"
  (let ((lines (funcall framepop-lines buf)))
    (if lines
	(max (min framepop-max-frame-size 
		  (funcall framepop-lines buf))
	     framepop-min-frame-size))))

(defun framepop-buffer nil
  ;; Return the buffer the framepop window is showing, or nil
  (if (frame-live-p framepop-frame)
      (window-buffer (frame-root-window framepop-frame))))

(defun framepop-count-visual-lines (buf &optional max frame)
  "Return the number of visual lines in BUF
as opposed to the actual lines. The maximum size of a visual line is
determined by the width of frame FRAME (defaults to
framepop-frame). If MAX is supplied, counting stops after MAX
lines. MAX defaults to framepop-max-frame-size."
  ;; There is an off-by-one error here; a line containing 79 characters
  ;; generates 2 lines. 
  (let* ((count 0)
	 (max (or max framepop-max-frame-size))
	 (frame (or frame framepop-frame))
	 (width  (- (or (frame-width framepop-frame) 
			(cdr (assq 'width framepop-frame-parameters))
			(frame-width (selected-frame))) 1))
	 col)
    (save-excursion
      (set-buffer buf)
      (if truncate-lines
	  (min max (count-lines (point-min) (point-max)))
	(save-excursion
	  (goto-char (point-min))
	  (while (and (not (eobp)) (< count max))
	    ;; Add one for this logical line
	    (setq count (1+ count))
	    (while (not (eolp))
	      ;; Add on the extra screen lines it generates
	      (setq col (+ (current-column) width))
	      (move-to-column col)
	      (if (and (eq (current-column) col) (not (eolp)))
		  (setq count (1+ count))))
	    ;; move to the next line, if possible
	    (if (not (eobp)) (forward-char 1)))
	  ;; Add one for a terminating newline
	  (if (and (eobp) (eq (preceding-char) ?\n))
	      (setq count (1+ count)))
	  count)))))

(defun framepop-lines-default (buf)
  "The default value for framepop-lines.
Ensures that the FramePop frame will be big enough to display all of BUF.
However, returns nil for buffers in framepop-do-not-display-list."
  (save-excursion
    (set-buffer buf)
    (if (member (buffer-name) framepop-do-not-display-list) nil
      (+ 
       (if (and (not framepop-auto-resize)
		(or 
		 (eq (buffer-size) 0)
		 (string= (buffer-name) "*grep*")
		 (string-match "\\*[Cc]ompilation\\*" (buffer-name))))
	   framepop-max-frame-size
	 (framepop-count-visual-lines buf))
	 (if (cdr (assq 'minibuffer (frame-parameters framepop-frame)))
	     1 0)
	 1 ;; for the mode line
	 ))))

;;; User commands

(defun framepop-resize-frame (&optional buf)
  "Resize the framepop frame to accomodate buffer BUF
BUF defaults to the buffer displayed in the framepop frame
Also ensures that none of the resized window is left unused, by scrolling
the window down if necessary"
  (interactive)
  (let* ((win (frame-root-window framepop-frame))
	 (buf (or buf (window-buffer win))))
    (modify-frame-parameters framepop-frame 
			     (list (cons 'height 
					 (framepop-frame-height buf))))
    (framepop-pull-down)
    ))

(defun framepop-pull-down nil
  "If the last line of the framepop buffer is visible, try to place it
on the last window line"
  (interactive)
  (if (and (not (interactive-p)) framepop-pull-down-crashes) nil
    (let* ((win (frame-root-window framepop-frame))
	   (buf (window-buffer win))
	   (pmax (save-excursion
		   (set-buffer buf)
		   (point-max))))
      (if (= (window-end win) pmax)
	  (let ((oldwin (selected-window)))
	    (select-window win)
	    (save-excursion
	      (goto-char pmax)
	      (recenter -1))
	    (select-window oldwin))))))

(defun framepop-grow (lines)
  "Increase the height of the framepop frame by LINES lines
When called interactively, LINES is the numeric prefix argument"
  (interactive "p")
  (modify-frame-parameters 
   framepop-frame
   (list (cons 'height
	       (max 2 (+ lines
			 (cdr (assoc 'height 
				     (frame-parameters framepop-frame)))))))))
(defun framepop-display-help nil
  "Display help for the framepop commands"
  (interactive)
  (describe-function 'framepop-display-buffer)
  (save-excursion
    (set-buffer (framepop-buffer)) ; *Help*
    (save-excursion
      (goto-char (point-min))
      (delete-region (point)
		     (progn
		       ;; Delete the framepop-display-buffer-specific stuff
		       (forward-line 7)
		       (point)))
      (insert "Framepop help:\n\n")))
  (if framepop-auto-resize nil
    (framepop-resize-frame)))

(defun framepop-display-buffer (buf)
  ;; Note: the fifth line of this docstring should begin general help:
  ;; see framepop-display-help
  "Display-buffer for FramePop
Displays BUF in a separate frame -- the FramePop frame.
BUF bay be a buffer or a buffer name.
 
You can display a buffer in the FramePop frame with \\[framepop-display-buffer].
Several commands are available for manipulating the FramePop frame:
 
Duplicate the FramePop frame:         \\[framepop-copy-frame]
Copy the FramePop frame and buffer:   \\[universal-argument] \\[framepop-copy-frame]
Scroll the FramePop frame:            \\[framepop-scroll-frame]
\[De\]iconify the FramePop frame:       \\[framepop-toggle-frame]
Iconify the FramePop frame:           \\[framepop-iconify-frame]
Lower the FramePop frame              \\[framepop-lower-frame]
Raise the FramePop frame              \\[framepop-raise-frame]
Change the FramePop frame height:     \\[framepop-grow]
Re-shrink-wrap the buffer             \\[framepop-resize-frame]
Show top part of buffer               \\[framepop-bob]
Show last part of buffer:             \\[framepop-eob]
Realign the buffer in the window:     \\[framepop-pull-down]
Make the framepop frame invisible:    \\[framepop-make-invisible-frame]
Destroy the framepop frame:           \\[framepop-delete-frame]
Resurrect the framepop frame:         \\[framepop-show-frame]
Display this help:                    \\[framepop-display-help]

You can send mail to the author of the FramePop package by typing
\\[framepop-submit-feedback]."
  (interactive "bDisplay buffer: ")
  (and (stringp buf) (setq buf (get-buffer buf)))
  (let ((oframe (selected-frame))
	(omouse (mouse-position))
	(lines (framepop-frame-height buf)))
    (if (not lines)
	;; framepop-lines should return nil for buffers which
	;; shouldn't be displayed in the framepop frame
	(display-buffer buf)
      (if (frame-live-p framepop-frame) nil
	;; No existing framepop frame
	(setq framepop-frame 
	      (make-frame (cons (cons 'height lines)
				framepop-frame-parameters))))
      ;; (make-frame-invisible framepop-frame) ; buggy
      (make-frame-visible framepop-frame)
      (select-frame framepop-frame)
      (delete-other-windows)
      ;; If the old buffer was auto-resizing, stop it
      (if (eq after-change-function 'framepop-resizer)
	  (setq after-change-function nil))
	  ;; (progn
	  ;;   (let ((temp framepop-old-acf))
	  ;; 	 (setq framepop-old-acf nil)
	  ;; 	 ;; Need to protect against after-change-function being
	  ;; 	 ;; called at this point, hence the let above
	  ;; 	 (setq after-change-function temp))))
      ;; When displaying a buffer in the framepop frame, the
      ;; previously displayed buffer comes to the top of
      ;; buffer-list. I'm not sure why this happens, but this fixes it.
      (bury-buffer (current-buffer))
      (switch-to-buffer buf t)
      (bury-buffer buf)
      (if (and framepop-auto-resize 
	       ;; If there is already an acf, don't set it
	       (not (and (assq 'after-change-function (buffer-local-variables))
			 after-change-function)))
	  (progn
	    (make-local-variable 'after-change-function)
	    ;; (make-local-variable 'framepop-old-acf)
	    ;; (setq framepop-old-acf nil)
	    ;; (setq framepop-old-acf 
	    ;;	  (if (eq after-change-function 'framepop-resizer) nil
	    ;;	    after-change-function))
	    (setq after-change-function 'framepop-resizer)))
      (framepop-resize-frame)
      (setq framepop-last-displayed-buffer (buffer-name buf))
      (raise-frame framepop-frame)
      (if (minibuffer-window-active-p (minibuffer-window)) nil
	;; Replace the default message with something more suitable
	(message (substitute-command-keys 
		  "Type \\[framepop-scroll-frame] to scroll, \\[framepop-iconify-frame] to iconify")))
      ;; If the framepop frame has just covered the mouse pointer, move it
      (if framepop-warp-pointer 
	  (framepop-fiddle-pointer omouse))
      ;; reselect the old frame so keystrokes keep going to the same place
      (select-frame oframe))))

(defun framepop-fiddle-pointer (omouse)
  "Try and move the pointer out of the framepop frame into the original frame"
  ;; Don't ask me why this sit-for is necessary. It just is. Without
  ;; it, (car (mouse-position)) can get the wrong value. I think I may just
  ;; throw up now and be done with it.
  (sit-for 0)
  (if (eq (car (mouse-position)) framepop-frame)
      ;; Pointer has ended up in framepop frame. This is bad.
      (let* ((try-ring '((topleft . topright)
			(topright . botright)
			(botright . botleft)
			(botleft . topleft)))
	    (try framepop-warp-to)
	    (mframe (car omouse)) ;; the frame the pointer used to be in
	    (fw (frame-width mframe))
	    (fh (- (frame-height mframe) 1))
	    (winner)
	    (done))
	(while (not done)
	  (let* ((xpos (assoc try
			      (list '(topleft . 0) '(botleft . 0) 
				    (cons 'topright fw) (cons 'topleft fw))))
		 (ypos (assoc try
			      (list '(topleft . 0) '(topright . 0) 
				    (cons 'botright fh) (cons 'botleft fh)))))
	    (set-mouse-position mframe
				;; Use 'topleft for nonsensical frameop-warp-to
				(or (cdr xpos) 0) 
				(or (cdr ypos) 0))
	    (raise-frame framepop-frame)
	    (setq winner try)
	    (setq try (cdr (assq try try-ring)))
	    (setq done (or (eq try framepop-warp-to) ; give up
			   (eq (car (mouse-position)) mframe) ; Egad! It worked
			   ))))
	(if (eq try framepop-warp-to) nil
	  ;; Reset framepop-warp-to to the sensible value
	  (setq framepop-warp-to winner)))))

(defun framepop-resizer (beg end pre-change-length)
  "Bound to after-change-function to automatically resize the framepop frame"
  ;; If a after-change-buffer has somehow escaped being reset, do it now
  (if (eq (framepop-buffer) (current-buffer)) nil
    (setq after-change-function nil))
  ;; otherwise...
  (framepop-resize-frame))

(defun framepop-iconify-frame nil
  "Iconify the FramePop frame"
  (interactive)
  (if (frame-live-p framepop-frame)
      (iconify-frame framepop-frame)
    (message "FramePop frame deleted")))

(defun framepop-make-invisible-frame nil
  "Make the FramePop frame invisible"
  (interactive)
  (if (frame-live-p framepop-frame)
      (make-frame-invisible framepop-frame)
    (message "FramePop frame deleted")))

(defun framepop-show-frame nil
  "Force the FramePop frame to be visible"
  (interactive)
  (if (frame-live-p framepop-frame) 
      (raise-frame framepop-frame)
    (let ((buf (or
		(get-buffer framepop-last-displayed-buffer)
		(get-buffer "*Help*"))))
      (if buf
	  (framepop-display-buffer buf)
	(message "Last displayed temporary buffer has been killed.")))))

(defun framepop-delete-frame nil
  "Delete (destroy) the FramePop frame"
  (interactive)
  (delete-frame framepop-frame))

(defun framepop-toggle-frame nil
  "Iconify or deiconify the FramePop frame"
  (interactive)
  (if (frame-live-p framepop-frame)
      (let ((oframe (selected-frame)))
	(select-frame framepop-frame t)
	(iconify-or-deiconify-frame)
	(bury-buffer (framepop-buffer))
	(select-frame oframe))
    (message "No active FramePop frame")))
      
(defun framepop-scroll-frame (n)
  "Like scroll-other-window, but scrolls the window in the FramePop frame"
  (interactive "P")
  (framepop-show-frame)
  (save-window-excursion
    (select-window (frame-root-window framepop-frame))
    (scroll-up n)))

(defun framepop-bob nil
  "Go to the beginning of the framepop buffer, resizing it first"
  (interactive)
  (framepop-show-frame)
  (framepop-resize-frame)
  (let* ((win (frame-root-window framepop-frame))
	 (buf (window-buffer win)))
    (set-window-point win (save-excursion
			    (set-buffer buf)
			    (point-min)))))

(defun framepop-eob nil
  "Go to the end of the framepop buffer, resizing it first
Useful for buffers (e.g. compilations) which grow"
  (interactive)
  (framepop-show-frame)
  (framepop-resize-frame)
  (let* ((win (frame-root-window framepop-frame))
	 (buf (window-buffer win)))
    (set-window-point win (save-excursion
			    (set-buffer buf)
			    (point-max)))
    (framepop-pull-down)))

(defun framepop-lower-frame nil
  "Lower the FramePop frame"
  (interactive)
  (if (frame-live-p framepop-frame)
      (lower-frame framepop-frame)
    (message "No active FramePop frame")))

(defun framepop-raise-frame nil
  "Raise the FramePop frame"
  (interactive)
  (if (frame-live-p framepop-frame)
      (raise-frame framepop-frame)
    (message "No active FramePop frame")))

(defun framepop-copy-frame (copy-buffer)
  "Duplicate the FramePop frame, and maybe the displayed buffer as well.
With a prefix arg (COPY-BUFFER), the buffer is also copied and given a
unique name. This is useful for *Help*, *Completions* etc."
  (interactive "P")
  (let ((oframe (selected-frame))
	new-frame
	buf
	contents
	pos) 
    (select-frame framepop-frame)
    (setq pos (point))
    (setq new-frame (make-frame (frame-parameters framepop-frame)))
    (modify-frame-parameters new-frame '((name . nil)))
    (if copy-buffer 
	(progn
	  (let ((helpobj))
	    (setq buf (if (and framepop-hack-help-buffer-title
			       (string= (buffer-name) "*Help*")
			       (progn
				 (condition-case ()
				     (save-excursion
				       (goto-char (point-min))
				       (search-forward ":" (min
							    (save-excursion
							     (end-of-line)
							     (point))
							    (+ (point-min) 50)))
				       (setq helpobj (buffer-substring 
						      (point-min) 
						      (match-beginning 0))))
				   (error nil))
				 ;; (intern-soft helpobj)
				 ))
			  (generate-new-buffer (format "*Help* on %s" helpobj))
			(generate-new-buffer (buffer-name)))))
	  (select-frame new-frame)
	  (setq contents (buffer-string))
	  (save-excursion
	    (set-buffer buf)
	    (insert contents)
	    (goto-char pos)
	    (switch-to-buffer buf))))
    (select-frame oframe)))

(defun framepop-wrap (function buffer)
  "Define a wrapper on FUNCTION so that BUFFER will appear in a FramePop frame
BUFFER may be a buffer, a buffer name, or a sexp evaluating to a buffer or
buffer name. The function is advised with around advice named
framepop-display-buffer-in-framepop-frame.

WARNING: this will not work on autoloaded functions unless forward
advice has been enabled. You must use ad-activate to activate the advice
after the package has been loaded. See advice.el for details."
  (require 'advice)
  (require 'backquote)
  (ad-add-advice
   function 
   (ad-make-advice
    'framepop-display-buffer-in-framepop-frame
    t
    t
    (` (advice lambda nil
	       ;; docstring:
	       (, (format "Displays %s buffer in a FramePop frame" 
			  (if (stringp buffer) buffer "output")))
	       ;; body
	       (let ((framepop-in-wrap t))
		 ad-do-it
		 (let* ((arg (, buffer)) 
			(buf (if (stringp arg) (get-buffer arg) arg)))
		   (cond ((bufferp buf)
			  (delete-windows-on buf)
			  (framepop-display-buffer buf))))))))
		 
   'around
   'last)
  (ad-activate function))

(defun framepop-enable nil
  "Enable automatic pop-up temporary windows"
  (interactive)
  (if (and temp-buffer-show-function 
	   (not (eq temp-buffer-show-function 'framepop-display-buffer)))
      (message "Warning: framepop.el has redefined temp-buffer-show-function"))
  (setq temp-buffer-show-function 'framepop-display-buffer))

(defun framepop-disable nil
  "Disable automatic pop-up temporary windows"
  (interactive)
  (setq temp-buffer-show-function nil))

(defun framepop-submit-feedback ()
  "Sumbit feedback on the FramePop package by electronic mail"
  (interactive)
  (require 'reporter)
  (reporter-submit-bug-report
   "David M. Smith <dsmith@stats.adelaide.edu.au>"
   (concat "framepop.el; version " framepop-version)
   '(framepop-lines framepop-frame-parameters)))


;;; Customizations using advice
;;; ---------------------------

;;; There are lots of useful things we can do with advice, but I
;;; really want to avoid forcing everyone to load the advice package
;;; just for framepop (advice is BIG). So here's a compromise: If
;;; advice has been loaded, the customizations below will be made.

;;; To get all the benefits below, you should add the following lines
;;; to your .emacs before the (require 'framepop) call:

;;;   (require 'advice)

(if (featurep 'advice)
    (progn
      
      ;; (setq ad-activate-on-definition t) ; allow forward advice
      ;; (ad-start-advice)			 ; make forward advice work

;;; The following ensures that "Click mouse-2 on a completion" works

      (defadvice mouse-choose-completion (before framepop-use-other-window act)
	"Insert the completion into the *previously* selected window"
	(if (minibuffer-window-active-p (minibuffer-window))
	    (select-window (minibuffer-window))
	  (other-window -1 t)))
      
;;; You may use the function framepop-wrap to force buffers which do
;;; not normally appear in a FramePop frame to do so automatically. For
;;; example, the following commands force *Shell Command Output*
;;; buffers to appear in the FramePop frame:
      
      (framepop-wrap 'shell-command "*Shell Command Output*")
      (framepop-wrap 'shell-command-on-region "*Shell Command Output*")
      
;;; You can also do this for the compile function, as shown below. In
;;; addition we also add the following advice to work around the
;;; strange way compile displays its windows:
      
      (framepop-wrap 'compile "*compilation*")
      (framepop-wrap 'grep "*grep*")
      (defadvice compile-internal (around framepop-save-windows activate)
	"Save the window configuration for use with framepop"
	(let ((winconf (current-window-configuration)))
	  ad-do-it
	  (if framepop-in-wrap
	      (set-window-configuration winconf))))

;;; In addition, the following advice makes C-c C-c work in compil-
;;; ation (including *grep*) buffers displayed in the FramePop frame

      (defadvice compile-goto-error (around framepop-other-frame protect activate)
	"Use something other than the framepop frame to display the buffer"
	(let ((infp (eq (selected-frame) framepop-frame))
	      buf wc pt)
	  (if infp
	      (progn
		(setq buf (current-buffer))
		(other-frame 1)
		(setq wc (current-window-configuration))
		(set-buffer buf)))
	  ad-do-it
	  (if infp
	      (progn
		(setq buf (current-buffer))
		(setq pt (point))
		(set-window-configuration wc)
		(let ((pop-up-frames nil))
		  (pop-to-buffer buf))
		(set-window-point (get-buffer-window buf) pt)))))

;;; The above advised functions are part of compile.el, which is
;;; autoloaded. We need to activate these advices after compile.el has
;;; loaded.

      (eval-after-load "compile"
		       '(progn
			  (ad-activate 'compile)
			  (ad-activate 'grep)
			  (ad-activate 'compile-internal)
			  (ad-activate 'compile-goto-error)))

;;; Similarly, the following advice makes C-c C-C in *Occur* buffers
;;; (which appear in the FramePop frame without intervention) work properly.

      (defadvice occur-mode-goto-occurrence (before framepop-other-frame
						    activate)
	"Use something other than the framepop frame to display the buffer"
	(if (eq (selected-frame) framepop-frame)
	    (let ((buf (current-buffer)))
	      (other-frame 1)
	      (set-buffer buf))))

;;; Under normal (i.e. without framepop) circumstances, completion
;;; buffers disappear after use. The following advice similarly
;;; arranges for a framepop frame displaying completions to get out of
;;; the way after use. NOTE: A better choice might be to iconify or
;;; make invisible the framepop frame rather that simply lowering it,
;;; but bugs in make-frame-visible cause problems here.
      
      (defun framepop-completions-buffer-p nil
	;; Return non-nil if the framepop buffer is a completions buffer
	(let ((buf (framepop-buffer)))
	  (and buf 
	       (string-match "[cC]ompletions" (buffer-name buf)))))

      (defvar framepop-go-away-function 'framepop-lower-frame
	"*Function called to make the framepop frame go away")
      
      (defun framepop-maybe-go-away nil
	;; Get rid of the framepop frame if it shows completions buffer
	(if (framepop-completions-buffer-p) 
	    (funcall framepop-go-away-function)))

      (defadvice completing-read (after framepop-go-away protect activate)
	"Get rid of the FramePop frame showing the completions"
	(framepop-maybe-go-away))

      ;; It would seem we only need protected advice for
      ;; completing-read, but that subr is often called from other
      ;; subrs and advice won't work. The following advices get around
      ;; some of the cases where this happens, but unfortunately in
      ;; such cases C-g won't lower the framepop frame, as desired.

      (defadvice minibuffer-complete-and-exit (before framepop-go-away
						      activate)
	"Get rid of the FramePop frame showing the completions"
	(framepop-maybe-go-away))

      (defadvice exit-minibuffer (before framepop-go-away activate)
	"Get rid of the FramePop frame showing the completions"
	(framepop-maybe-go-away))

      (defadvice mouse-choose-completion (after framepop-go-away activate)
	"Get rid of the FramePop frame showing the completions"
	(framepop-maybe-go-away))

      (defadvice keyboard-quit (before framepop-go-away activate)
	"Get rid of the FramePop frame showing the completions"
	(framepop-maybe-go-away))

      (defadvice abort-recursive-edit (before framepop-go-away activate)
	"Get rid of the FramePop frame showing the completions"
	(framepop-maybe-go-away))
      
;;; End of advice customizations
      ))

(framepop-enable)

(provide 'framepop)

;;; framepop.el ends here
