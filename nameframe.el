;;; nameframe --- Manage frames by name.

;; Author: John Del Rosario <john2x@gmail.com>
;; URL: https://github.com/john2x/nameframe
;; Version: 0.1.0-alpha

;;; Commentary:

;; This package defines utility functions for managing frames by their names.

;;; Code:

(defun nameframe-frame-alist ()
  "Return an alist of named frames."
  (nameframe--build-frames-alist-from-frame-list (frame-list)))

(defun nameframe-make-frame (frame-name)
  "Make a new frame with name FRAME-NAME."
  (make-frame `((name . ,frame-name))))

(defun nameframe-frame-exists-p (frame-name &optional frame-alist)
  "Check if a frame with FRAME-NAME exists.
If FRAME-ALIST is non-nil, then it is used instead of calling
`nameframe-frame-alist'."
  (and (nameframe-get-frame frame-name frame-alist) t))

(defun nameframe-get-frame (frame-name &optional frame-alist)
  "Return the frame with FRAME-NAME if it exists, or nil.
If FRAME-ALIST is non-nil, then it is used instead of calling
`nameframe-frame-alist'."
  (let ((frame-alist (or frame-alist (nameframe-frame-alist))))
    (cdr (assoc frame-name frame-alist))))

;;;###autoload
(defun nameframe-switch-frame (frame-name)
  "Interactively switch to an existing frame with name FRAME-NAME."
  (interactive
   (list (completing-read "Switch to frame: " (mapcar 'car (nameframe-frame-alist)))))
  ;; is it possible that `nameframe-frame-alist' would return a different value
  ;; from the previous call done in the `interactive' form above?
  (let* ((frame-alist (nameframe-frame-alist))
         (frame (nameframe-get-frame frame-name frame-alist)))
    (when frame
      (select-frame-set-input-focus frame))))

;;;###autoload
(defun nameframe-create-frame (frame-name)
  "Interactively create a frame with name FRAME-NAME and switch to it."
  (interactive "sCreate frame named: ")
  (let* ((frame-alist (nameframe-frame-alist))
         (frame (nameframe-get-frame frame-name frame-alist)))
    (if (not frame)
        (let ((frame (nameframe-make-frame frame-name))
              (buffer-name "*scratch*"))
          (if (not (get-buffer buffer-name))
              (with-current-buffer (get-buffer-create buffer-name)
                (funcall initial-major-mode))
            (switch-to-buffer (get-buffer buffer-name))))
      (select-frame-set-input-focus frame))))

(defun nameframe--build-frames-alist-from-frame-list (frame-list)
  "Return an alist of name-frame pairs from a FRAME-LIST (i.e. returned value of the `frame-list' function)."
  (mapcar (lambda (f) `(,(cdr (assq 'name (frame-parameters f))) . ,f)) frame-list))

(provide 'nameframe)

;;; nameframe.el ends here
