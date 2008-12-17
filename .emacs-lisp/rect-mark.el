;;; rect-mark.el --- Mark a rectangle of text with highlighting.

;;; Copyright (C) 1994, 1995 Rick Sladkey <jrs@world.std.com>

;;; This file is not part of GNU Emacs but it is distributed under the
;;; same conditions as GNU Emacs.

;;; This is free software.
;;; GNU Emacs is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published
;;; by the Free Software Foundation; either version 2, or (at your
;;; option) any later version.

;;; GNU Emacs is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to the
;;; Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;; Author: Rick Sladkey <jrs@world.std.com>
;; Version: 1.4

;;; Commentary:

;; If you use both transient-mark-mode and picture-mode, you will
;; probably realize how convenient it would be to be able to highlight
;; the region between point and mark as a rectangle.  Have you ever
;; wished you could see where exactly those other two corners fell
;; before you operated on a rectangle?  If so, then this program is
;; for you.

;; For example, you can set the mark in preparation for a rectangle
;; command with `C-x r C-SPC', watch the highlighted rectangle grow as
;; you move the cursor to the other corner, and then issue the command
;; and the rectangle disappears.  Or if point and mark are already set
;; but you want to see what the region would look like as a rectangle,
;; try `C-x r C-x' which exchanges point and mark and makes the
;; highlighted region rectangular.

;; The default Emacs key-bindings put `point-to-register' on
;; `C-x r C-SPC' but since that command it is already on `C-x r SPC'
;; and since it is irresistably intuitive to put `rm-set-mark' on
;; `C-x r C-SPC', I have taken the liberty of recommending that you
;; override the default key-bindings.

;; You can also kill or copy rectangles onto the kill ring which is
;; convenient for yanking rectangles into ordinary buffers (i.e.  ones
;; not in picture mode) and for pasting rectangles into other window
;; system programs (e.g. xterm).  These keys are by default bound to
;; `C-x r C-w' and `C-x r M-w' by analogy to the normal kill and copy
;; counterparts.

;; Finally, there is mouse support for rectangle highlighting by
;; dragging the mouse while holding down the shift key.  The idea is
;; that this behaves exactly like normal mouse dragging except that
;; the region is treated as a rectangle.

;;; Usage:

;; Use this section in your "~/.emacs" when rect-mark isn't included
;; as an integral part of Emacs.  Don't forget to remove the first
;; three columns.

;; ;; Support for marking a rectangle of text with highlighting.
;; (define-key ctl-x-map "r\C-@" 'rm-set-mark)
;; (define-key ctl-x-map [?r ?\C-\ ] 'rm-set-mark)
;; (define-key ctl-x-map "r\C-x" 'rm-exchange-point-and-mark)
;; (define-key ctl-x-map "r\C-w" 'rm-kill-region)
;; (define-key ctl-x-map "r\M-w" 'rm-kill-ring-save)
;; (define-key global-map [S-down-mouse-1] 'rm-mouse-drag-region)
;; (autoload 'rm-set-mark "rect-mark"
;;   "Set mark for rectangle." t)
;; (autoload 'rm-exchange-point-and-mark "rect-mark"
;;   "Exchange point and mark for rectangle." t)
;; (autoload 'rm-kill-region "rect-mark"
;;   "Kill a rectangular region and save it in the kill ring." t)
;; (autoload 'rm-kill-ring-save "rect-mark"
;;   "Copy a rectangular region to the kill ring." t)
;; (autoload 'rm-mouse-drag-region "rect-mark"
;;   "Drag out a rectangular region with the mouse." t)

;; Use this section in your "~/.emacs" to modify picture mode so that
;; it automatically uses the rect-mark equivalents of many commands.

;; ;; One vision of a better picture mode.
;; (add-hook 'picture-mode-hook 'rm-example-picture-mode-bindings)
;; (autoload 'rm-example-picture-mode-bindings "rect-mark"
;;   "Example rect-mark key and mouse bindings for picture mode.")

;;; Code:


;;;###autoload (define-key ctl-x-map "r\C-@" 'rm-set-mark)
;;;###autoload (define-key ctl-x-map [?r ?\C-\ ] 'rm-set-mark)
;;;###autoload (define-key ctl-x-map "r\C-x" 'rm-exchange-point-and-mark)
;;;###autoload (define-key ctl-x-map "r\C-w" 'rm-kill-region)
;;;###autoload (define-key ctl-x-map "r\M-w" 'rm-kill-ring-save)
;;;###autoload (define-key global-map [S-down-mouse-1] 'rm-mouse-drag-region)

;; Our state variables, each internal and buffer local.
(defvar rm-mark-active nil)
(defvar rm-overlay-list)
(defvar rm-old-transient-mark-mode)
(defvar rm-force)
(defvar rm-old-global-variables)

;; A list of our buffer local variables.
(defconst rm-our-local-variables
  '(rm-mark-active
    rm-overlay-list
    rm-old-transient-mark-mode
    rm-force
    rm-old-global-variables))

;; System variables which must temorarily be buffer local.
(defconst rm-temporary-local-variables
  '(transient-mark-mode
    ;; Alas, we can no longer uninstall a post command hook from a post
    ;; command hook (as of 19.28 at least) so we must leave it installed
    ;; globally.
    ;post-command-hook
    deactivate-mark-hook))

;; Those commands which don't necessarily deactivate the mark but
;; should.  This is a partial list as of Emacs 19.22.  Most problems
;; are the result of the pathological case of a zero-width rectangle.
(defconst rm-deactivate-mark-commands
  '(clear-rectangle
    copy-rectangle
    copy-rectangle-to-register
    kill-rectangle
    open-rectangle
    string-rectangle
    yank-rectangle
    keyboard-quit))

;;; Quiet the byte-compiler.
(defvar killed-rectangle)
(defvar picture-mode-map)
(defvar deactivate-mark-hook)


;;;###autoload
(defun rm-example-picture-mode-bindings ()
  "Example rect-mark keyboard and mouse bindings for picture mode."
  (define-key picture-mode-map "\C-@" 'rm-set-mark)
  (define-key picture-mode-map [?\C-\ ] 'rm-set-mark)
  (define-key picture-mode-map [down-mouse-1] 'rm-mouse-drag-region)
  (define-key picture-mode-map "\C-x\C-x" 'rm-exchange-point-and-mark)
  (define-key picture-mode-map "\C-w" 'rm-kill-region)
  (define-key picture-mode-map "\M-w" 'rm-kill-ring-save)
  (define-key picture-mode-map "\C-y" 'yank-rectangle)
  ;; Prevent `move-to-column-force' from deactivating the mark.
  (defun move-to-column-force (column)
    (let ((deactivate-mark deactivate-mark))
      (move-to-column (max column 0) t)
      (hscroll-point-visible))))

;;;###autoload
(defun rm-set-mark (force)
  "Set mark like `set-mark-command' but anticipates a rectangle.
This arranges for the rectangular region between point and mark
to be highlighted using the same face that is used to highlight
the region in `transient-mark-mode'.  This special state lasts only
until the mark is deactivated, usually by executing a text-modifying
command like \\[kill-rectangle], by inserting text, or by typing \\[keyboard-quit].

With optional argument FORCE, arrange for tabs to be expanded and
for spaces to inserted as necessary to keep the region perfectly
rectangular.  This is the default in `picture-mode'."
  (interactive "P")
  (rm-activate-mark force)
  (push-mark nil nil t))

;;;###autoload
(defun rm-exchange-point-and-mark (force)
  "Like `exchange-point-and-mark' but treats region as a rectangle.
See `rm-set-mark' for more details.

With optional argument FORCE, tabs are expanded and spaces are
inserted as necessary to keep the region perfectly rectangular.
This is the default in `picture-mode'."
  (interactive "P")
  (rm-activate-mark force)
  (exchange-point-and-mark))

;;;###autoload
(defun rm-kill-region (start end)
  "Like kill-rectangle except the rectangle is also saved in the kill ring.
Since rectangles are not ordinary text, the killed rectangle is saved
in the kill ring as a series of lines, one for each row of the rectangle.
The rectangle is also saved as the killed rectangle so it is available for
insertion with yank-rectangle."
  (interactive "r")
  (rm-kill-ring-save start end)
  (delete-rectangle start end)
  (and (interactive-p)
       rm-mark-active
       (rm-deactivate-mark)))

;;;###autoload
(defun rm-kill-ring-save (start end)
  "Copies the region like rm-kill-region would but the rectangle isn't killed."
  (interactive "r")
  (setq killed-rectangle (extract-rectangle start end))
  (kill-new (mapconcat (function
			(lambda (row)
			  (concat row "\n")))
		       killed-rectangle ""))
  (and (interactive-p)
       rm-mark-active
       (rm-deactivate-mark)))

;;;###autoload
(defun rm-mouse-drag-region (start-event)
  "Highlight a rectangular region of text as the the mouse is dragged over it.
This must be bound to a button-down mouse event."
  (interactive "e")
  (let* ((start-posn (event-start start-event))
	 (start-point (posn-point start-posn))
	 (start-window (posn-window start-posn))
	 (start-frame (window-frame start-window))
	 (bounds (window-edges start-window))
	 (top (nth 1 bounds))
	 (bottom (if (window-minibuffer-p start-window)
		     (nth 3 bounds)
		   ;; Don't count the mode line.
		   (1- (nth 3 bounds))))
	 (click-count (1- (event-click-count start-event))))
    (setq mouse-selection-click-count click-count)
    (mouse-set-point start-event)
    (rm-activate-mark)
    (let (end-event
	  end-posn
	  end-point
	  end-window)
      (track-mouse
	(while (progn
		 (setq end-event (read-event)
		       end-posn (event-end end-event)
		       end-point (posn-point end-posn)
		       end-window (posn-window end-posn))
		 (or (mouse-movement-p end-event)
		     (eq (car-safe end-event) 'switch-frame)))
	  (cond
	   ;; Ignore switch-frame events.
	   ((eq (car-safe end-event) 'switch-frame)
	    nil)
	   ;; Are we moving within the original window?
	   ((and (eq end-window start-window)
		 (integer-or-marker-p end-point))
	    (goto-char end-point)
	    (rm-highlight-rectangle start-point end-point))
	   ;; Are we moving on a different window on the same frame?
	   ((and (windowp end-window)
		 (eq (window-frame end-window) start-frame))
	    (let ((mouse-row (+ (nth 1 (window-edges end-window))
				(cdr (posn-col-row end-posn)))))
	      (cond
	       ((< mouse-row top)
		(mouse-scroll-subr (- mouse-row top)
				   nil start-point))
	       ((and (not (eobp))
		     (>= mouse-row bottom))
		(mouse-scroll-subr (1+ (- mouse-row bottom))
				   nil start-point)))))
	   (t
	    (let ((mouse-y (cdr (cdr (mouse-position))))
		  (menu-bar-lines (or (cdr (assq 'menu-bar-lines
						 (frame-parameters)))
				      0)))
	      ;; Are we on the menu bar?
	      (and (integerp mouse-y) (< mouse-y menu-bar-lines)
		   (mouse-scroll-subr (- mouse-y menu-bar-lines)
				      nil start-point)))))))
      (and (eq (get (event-basic-type end-event) 'event-kind) 'mouse-click)
	   (eq end-window start-window)
	   (numberp end-point)
	   (if (= start-point end-point)
	       (setq deactivate-mark t)
	     (push-mark start-point t t)
	     (goto-char end-point)
	     (rm-kill-ring-save start-point end-point)))
      )))


(defun rm-activate-mark (&optional force)
  ;; Turn on rectangular marking mode by temporarily (and in a buffer
  ;; local way) disabling transient mark mode and manually handling
  ;; highlighting from a post command hook.
  (setq rm-force (and (not buffer-read-only)
		      (or force
			  (eq major-mode 'picture-mode))))
  ;; Be careful if we are already marking a rectangle.
  (if rm-mark-active
      nil
    ;; Make each of our state variables buffer local.
    (mapcar (function make-local-variable) rm-our-local-variables)
    (setq rm-mark-active t
	  rm-overlay-list nil
	  rm-old-transient-mark-mode transient-mark-mode)
    ;; Remember which system variables weren't buffer local.
    (setq rm-old-global-variables
	  (apply (function nconc)
		 (mapcar (function
			  (lambda (variable)
			    (and (not (assoc variable
					     (buffer-local-variables)))
				 (list variable))))
			 rm-temporary-local-variables)))
    ;; Then make them all buffer local too.
    (mapcar (function make-local-variable) rm-temporary-local-variables)
    ;; Making transient-mark-mode buffer local doesn't really work
    ;; correctly as of 19.22: the current buffer's value affects all
    ;; displayed buffers.
    (setq transient-mark-mode nil)
    (add-hook 'post-command-hook 'rm-post-command)
    (add-hook 'deactivate-mark-hook 'rm-deactivate-mark)))

(defun rm-post-command ()
  ;; An error in a post-command function can be fatal if it re-occurs
  ;; on each call, thus the condition-case safety nets.
  ;; We have to do things this way because deactivate-mark doesn't
  ;; (in general) get called if transient-mark-mode isn't turned on.
  (if rm-mark-active
      (if (or (not mark-active)
	      deactivate-mark
	      (memq this-command rm-deactivate-mark-commands))
	  (condition-case nil
	      (rm-deactivate-mark)
	    (error nil))
	(condition-case info
	    (rm-highlight-rectangle (mark) (point))
	  (error
	   (ding)
	   (message "rect-mark trouble: %s" info)
	   (condition-case nil
	       (rm-deactivate-mark)
	     (error nil)))))
    (and (boundp 'rm-overlay-list)
	 (condition-case nil
	     (rm-deactivate-mark)
	   (error nil)))))

(defun rm-highlight-rectangle (start end)
  ;; This function is used to highlight the rectangular region from
  ;; START to END.  We do this by putting an overlay on each line
  ;; within the rectangle.  Each overlay extends across all the
  ;; columns of the rectangle.  We try to reuse overlays where
  ;; possible because this is more efficient and results in less
  ;; flicker.  If rm-force is nil and the buffer contains tabs or
  ;; short lines, the higlighted region may not be perfectly
  ;; rectangular.
  (save-excursion
    ;; Calculate the rectangular region represented by point and mark,
    ;; putting start in the north-west corner and end in the
    ;; south-east corner.  We can't effectively use
    ;; operate-on-rectangle because it doesn't work for zero-width
    ;; rectangles as of 19.22.
    (and (> start end)
	 (setq start (prog1
			 end
		       (setq end start))))
    (let ((start-col (save-excursion
		       (goto-char start)
		       (current-column)))
	  (end-col (save-excursion
		     (goto-char end)
		     (current-column)))
	  (deactivate-mark deactivate-mark))
      (and (> start-col end-col)
	   (setq start-col (prog1
			       end-col
			     (setq end-col start-col))
		 start (save-excursion
			 (goto-char start)
			 (move-to-column start-col rm-force)
			 (point))
		 end (save-excursion
		       (goto-char end)
		       (move-to-column end-col rm-force)
		       (point))))
      ;; Force a redisplay so we can do reliable window start/end
      ;; calculations.
      (sit-for 0)
      (let ((old rm-overlay-list)
	    (new nil)
	    overlay
	    (window-start (max (window-start) start))
	    (window-end (min (window-end) end)))
	;; Iterate over those lines of the rectangle which are visible
	;; in the currently selected window.
	(goto-char window-start)
	(while (< (point) window-end)
	  (let ((row-start (progn
			     (move-to-column start-col rm-force)
			     (point)))
		(row-end (progn
			   (move-to-column end-col rm-force)
			   (point))))
	    ;; Trim old leading overlays.
	    (while (and old
			(setq overlay (car old))
			(< (overlay-start overlay) row-start)
			(/= (overlay-end overlay) row-end))
	      (delete-overlay overlay)
	      (setq old (cdr old)))
	    ;; Reuse an overlay if possible, otherwise create one.
	    (if (and old
		     (setq overlay (car old))
		     (or (= (overlay-start overlay) row-start)
			 (= (overlay-end overlay) row-end)))
		(progn
		  (move-overlay overlay row-start row-end)
		  (setq new (cons overlay new)
			old (cdr old)))
	      (setq overlay (make-overlay row-start row-end))
	      (overlay-put overlay 'face 'region)
	      (setq new (cons overlay new)))
	    (forward-line 1)))
	;; Trim old trailing overlays.
	(mapcar (function delete-overlay) old)
	(setq rm-overlay-list (nreverse new))))))

(defun rm-deactivate-mark ()
  ;; This is used to clean up after `rm-activate-mark'.
  ;; Alas, we can no longer uninstall a post command hook from a post
  ;; command hook (as of 19.28 at least) so we must leave it installed
  ;; globally.
  ;(setq post-command-hook (delq 'rm-post-command post-command-hook))
  (setq deactivate-mark-hook (delq 'rm-deactivate-mark deactivate-mark-hook))
  (setq transient-mark-mode rm-old-transient-mark-mode)
  (mapcar (function delete-overlay) rm-overlay-list)
  (mapcar (function kill-local-variable) rm-old-global-variables)
  (mapcar (function kill-local-variable) rm-our-local-variables)
  (and transient-mark-mode
       mark-active
       (deactivate-mark)))

(provide 'rect-mark)

;;; rect-mark.el ends here
