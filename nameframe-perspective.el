;;; nameframe-perspective --- Nameframe integration with perspective.el

;; Author: John Del Rosario <john2x@gmail.com>
;; URL: https://github.com/john2x/nameframe
;; Version: 0.1.0-alpha
;; Package-Requires: ((nameframe "0.1.0-alpha") (perspective "1.12"))

;;; Commentary:

;; This package advises the `nameframe-make-frame' function to
;; switch to a perspective after creating a frame.

;; To use this library, put this file in your Emacs load path,
;; and call (require 'nameframe-perspective).

;;; Code:

(require 'nameframe)
(require 'perspective)

(defun nameframe-perspective--persp-switch-after-advice (frame-name)
  "Switch to a perspective named FRAME-NAME."
  (persp-switch frame-name))

(advice-add 'nameframe-make-frame :after #'nameframe-perspective--persp-switch-after-advice)

(provide 'nameframe-perspective)

;;; nameframe-perspective.el ends here
