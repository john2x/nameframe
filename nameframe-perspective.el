;;; nameframe-perspective.el --- Nameframe integration with perspective.el

;; Author: John Del Rosario <john2x@gmail.com>
;; URL: https://github.com/john2x/nameframe
;; Version: 0.2.0-beta
;; Package-Requires: ((nameframe "0.2.0-beta") (perspective "1.12"))

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
;; switch to a perspective after creating a frame.

;; To use this library, put this file in your Emacs load path,
;; and call (nameframe-perspective-init).

;;; Code:

(require 'nameframe)
(require 'perspective)

(defun nameframe-perspective--persp-switch-after-advice (frame-name)
  "Switch to a perspective named FRAME-NAME."
  (persp-switch frame-name))

;;;###autoload
(defun nameframe-perspective-init ()
  "Advice `nameframe-make-frame' to switch perspective after making a frame."
  (advice-add 'nameframe-make-frame :after #'nameframe-perspective--persp-switch-after-advice))

(provide 'nameframe-perspective)

;;; nameframe-perspective.el ends here
