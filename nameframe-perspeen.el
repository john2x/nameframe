;;; nameframe-perspeen.el --- Nameframe integration with perspeen.el

;; Author: John Del Rosario <john2x@gmail.com>
;; URL: https://github.com/john2x/nameframe
;; Version: 0.4.1-beta
;; Package-Requires: ((nameframe "0.4.1-beta") (perspeen "0.1.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package advises the `nameframe-make-frame' function to
;; switch to a perspeen workspace after creating a frame.

;; To use this library, put this file in your Emacs load path,
;; and call (nameframe-perspeen-mode t).

;;; Code:

(require 'nameframe)
(require 'perspeen)

;;;###autoload
(define-minor-mode nameframe-perspeen-mode
  "Global minor mode that switches workspace when creating frames.
With `nameframe-perspeen-mode' enabled, creating frames with
`nameframe-make-frame' will automatically switch to a workspace
with that frame's name."
  :init-value nil
  :lighter nil
  :global t
  :group 'nameframe
  :require 'nameframe-perspeen
  (cond
   (nameframe-perspeen-mode
    (add-hook 'nameframe-make-frame-hook #'nameframe-perspeen--make-frame-persp-switch-hook)
    (add-hook 'focus-in-hook #'nameframe-perspeen--switch-workspace-focus))
   (t
    (remove-hook 'nameframe-make-frame-hook #'nameframe-perspeen--make-frame-persp-switch-hook)
    (remove-hook 'focus-in-hook #'nameframe-perspeen--switch-workspace-focus))))

(defun nameframe-perspeen--make-frame-persp-switch-hook (frame)
  "Used as a hook function to switch workspace based on FRAME's name."
  (perspeen-new-ws-internal (nameframe--get-frame-name frame))
  (perspeen-update-mode-string))

(defun nameframe-perspeen--switch-workspace-focus ()
  "Switch to the workspace with the same name as the current frame."
  (let* ((frame-name (nameframe--get-frame-name (selected-frame)))
         (ws (car (seq-filter (lambda (w) (string= (perspeen-ws-struct-name w) frame-name)) perspeen-ws-list)))
         (default-ws (car (seq-filter (lambda (w) (string= (perspeen-ws-struct-name w) perspeen-workspace-default-name)) perspeen-ws-list))))
    (if ws
        (progn
          (message (concat "Switching to workspace " frame-name))
          (perspeen-switch-ws-internal ws)
          (perspeen-update-mode-string))
      (if default-ws
          (progn
            (message (concat "Workspace with name " frame-name " not found! Switching to default workspace."))
            (perspeen-switch-ws-internal default-ws)
            (perspeen-update-mode-string))
        (message (concat "Workspace with name " frame-name " not found!"))))))


(provide 'nameframe-perspeen)

;;; nameframe-perspeen.el ends here
