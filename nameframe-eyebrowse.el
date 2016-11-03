;;; nameframe-eyebrowse.el --- Nameframe integration with eyebrowse.el

;; Author: John Del Rosario <john2x@gmail.com>, surya <surya46584@gmail.com>
;; URL: https://github.com/john2x/nameframe
;; Package-Version: 20160927.2103
;; Version: 0.4.1-beta
;; Package-Requires: ((nameframe "0.4.1-beta") (eyebrowse "1.12"))

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
;; switch to a eyebrowse after creating a frame.

;; To use this library, put this file in your Emacs load path,
;; and call (nameframe-eyebrowse-mode t).

;;; Code:

(require 'nameframe)
(require 'eyebrowse)

;;;###autoload
(define-minor-mode nameframe-eyebrowse-mode
  "Global minor mode that switches eyebrowse when creating frames.
With `nameframe-eyebrowse-mode' enabled, creating frames with
`nameframe-make-frame' will automatically switch to a eyebrowse
with that frame's name."
  :init-value nil
  :lighter nil
  :global t
  :group 'nameframe
  :require 'nameframe-eyebrowse
  (cond
   (nameframe-eyebrowse-mode
    (add-hook 'nameframe-make-frame-hook #'nameframe-eyebrowse--make-frame-switch-hook))
   (t
    (remove-hook 'nameframe-make-frame-hook #'nameframe-eyebrowse--make-frame-switch-hook))))

(defun nameframe-eyebrowse--make-frame-switch-hook (frame)
  "Used as a hook function to switch eyebrowse based on FRAME's name."
  (nameframe-switch-frame (nameframe--get-frame-name frame))
  (progn
    (eyebrowse-init)
    (eyebrowse-switch-to-window-config-1)
    (eyebrowse-rename-window-config (eyebrowse--get 'current-slot) (nameframe--get-frame-name frame))
    ))

(provide 'nameframe-eyebrowse)

;;; nameframe-eyebrowse.el ends here
