;;; py-absolufy-imports.el --- Use absolufy-imports to make python imports absolute or relative
;;
;; Copyright (C) 2022 Kamyab Taghizadeh <kamyab.zad@gmail.com>
;;
;; Author: Kamyab Taghizadeh <kamyab.zad@gmail.com>
;; Homepage: https://github.com/kamyabzad/py-absolufy-imports
;; Keywords: languages tools
;; Package-Requires: ((emacs "25.1"))
;;
;; Version: 0.0.1
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; An Emacs interface for absolufy-imports package.
;;
;;; Code:

(require 'cl-extra)

(defgroup py-absolufy-imports nil
  "Use absolufy-imports to make python imports absolute or relative."
  :group 'convenience
  :prefix "py-absolufy-imports-")

(defcustom py-absolufy-imports-root-indicators '(".python-root" "manage.py")
  "Filenames used to indicate the root directory."
  :group 'py-absolufy-imports
  :type '(repeat string))

(defun py-absolufy-imports--find-root (filename)
  "Find the root directory of python code based on an indicator FILENAME."
  (let ((path (locate-dominating-file "." filename)))
    (when path (expand-file-name path))))

(defun py-absolufy-imports--find-first-root ()
  "Find the root directory of python code based on the first found indicator."
  (cl-some #'py-absolufy-imports--find-root py-absolufy-imports-root-indicators))

(defun py-absolufy-imports--call-process-absolufy (root-directory filename)
  "Call absolufy-imports binary to convert relative imports in ROOT-DIRECTORY FILENAME to absolute imports."
  (call-process "absolufy-imports" nil nil nil "--application-directories" root-directory filename))

(defun py-absolufy-imports--call-process-relativify (root-directory filename)
  "Call absolufy-imports binary to convert absolute imports in ROOT-DIRECTORY FILENAME to relative imports."
  (call-process "absolufy-imports" nil nil nil "--application-directories" root-directory "--never" filename))

(defun py-absolufy-imports-buffer ()
  "Absolufy the imports in current buffer."
  (interactive)
  (if (not buffer-file-name) (message "Buffer is not visiting any file!")
    (let ((root-directory (py-absolufy-imports--find-first-root)))
      (if root-directory  (py-absolufy-imports--call-process-absolufy root-directory buffer-file-name)
        (message "Couldn't find root directory!")))))

(defun py-absolufy-imports-relativify-buffer ()
  "Make all the first party imports in current buffer relative."
  (interactive)
  (if (not buffer-file-name) (message "Buffer is not visiting any file!")
    (let ((root-directory (py-absolufy-imports--find-first-root)))
      (if root-directory (py-absolufy-imports--call-process-relativify root-directory buffer-file-name)
        (message "Couldn't find root directory!")))))

(provide 'py-absolufy-imports)
;;; py-absolufy-imports.el ends here
