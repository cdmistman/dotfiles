(defun path/join (start &rest components)
  (seq-reduce
   (lambda (init el)
     (concat (file-name-as-directory init) el))
   components
   start))
