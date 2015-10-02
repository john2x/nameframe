;;; nameframe-projectile --- Nameframe integration with Projectile

;; Author: John Del Rosario <john2x@gmail.com>
;; URL: https://github.com/john2x/nameframe
;; Version: 0.1.0-alpha
;; Package-Requires: ((nameframe "0.1.0-alpha") (projectile "0.13.0"))

;;; Commentary:

;; This package defines a function to replace Projectile's
;; `projectile-switch-project' which will create/switch to a named frame
;; of the target project.

;; To use this library, put this file in your Emacs load path,
;; and call (require 'nameframe-projectile).

;;; Credits:

;; The `nameframe-projectile-switch-project' function was copied from
;; `persp-projectile.el' (https://github.com/bbatsov/projectile/blob/master/persp-projectile.el)

;;; Code:

(require 'nameframe)
(require 'projectile)

;;;###autoload
(defun nameframe-projectile-switch-project (project)
  "Switch to a projectile PROJECT or frame we have visited before.
If the frame of corresponding project does not exist, this
function will call `nameframe-make-frame' to create one and switch to
that before `projectile-switch-project' invokes `projectile-switch-project-action'.
Otherwise, this function will switch to an existing frame of the project
unless we're already in that frame."
  (interactive (list (projectile-completing-read "Switch to project: "
                                                 (projectile-relevant-known-projects))))
  (let* ((name (file-name-nondirectory (directory-file-name project)))
         (curr-frame (selected-frame))
         (frame-alist (nameframe-frame-alist))
         (frame (nameframe-get-frame name frame-alist)))
    (cond
     ;; project-specific frame already exists
     ((and frame (not (equal frame curr-frame)))
      (select-frame-set-input-focus frame))
     ;; project-specific frame doesn't exist
     ((not frame)
      (progn (nameframe-make-frame name)
             (projectile-switch-project-by-name project))))))

;;;###autoload
(defun nameframe-projectile-init ()
  "Override Projectile's mapping of `projectile-switch-project' to use `nameframe-projectile-switch-project'."
  (interactive)
  (define-key projectile-mode-map [remap projectile-switch-project] 'nameframe-projectile-switch-project))

(provide 'nameframe-projectile)

;;; nameframe-projectile.el ends here
