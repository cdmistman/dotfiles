(defvar html-ts-font-lock-rules
  (let ((deprecated-tags '(;; source: https://developer.mozilla.org/en-US/docs/Web/HTML/Element
			   "acronym"
			   "big"
			   "center"
			   "content"
			   "dir"
			   "font"
			   "frame"
			   "frameset"
			   "image"
			   "marquee"
			   "menuitem"
			   "nobr"
			   "noembed"
			   "noframes"
			   "param"
			   "plaintext"
			   "rb"
			   "rtc"
			   "shadow"
			   "strike"
			   "tt"
			   "xmp"))
	(html-elements '(;; source: https://developer.mozilla.org/en-US/docs/Web/HTML/Element
			 ; main root
			 "html"

			 ; document metadata
			 "base"
			 "head"
			 "link"
			 "meta"
			 "style"
			 "title"

			 ; sectioning root
			 "body"

			 ; content sectioning
			 "address"
			 "article"
			 "aside"
			 "footer"
			 "h1"
			 "h2"
			 "h3"
			 "h4"
			 "h5"
			 "h6"
			 "header"
			 "hgroup"
			 "main"
			 "nav"
			 "section"
			 "search"

			 ; text content
			 "blockquote"
			 "dd"
			 "div"
			 "dl"
			 "dt"
			 "figcaption"
			 "figure"
			 "hr"
			 "li"
			 "menu"
			 "ol"
			 "p"
			 "pre"
			 "ul"

			 ; inline text semantics
			 "a"
			 "abbr"
			 "b"
			 "bdi"
			 "bdo"
			 "br"
			 "cite"
			 "code"
			 "data"
			 "dfn"
			 "em"
			 "i"
			 "kbd"
			 "mark"
			 "q"
			 "rp"
			 "rt"
			 "ruby"
			 "s"
			 "samp"
			 "small"
			 "span"
			 "strong"
			 "sub"
			 "sup"
			 "time"
			 "u"
			 "var"
			 "wbr"

			 ; image and multimedia
			 "area"
			 "audio"
			 "img"
			 "map"
			 "track"
			 "video"

			 ; embedded content
			 "embed"
			 "iframe"
			 "object"
			 "picture"
			 "portal"
			 "source"

			 ; svg and mathml
			 "math"
			 "svg"

			 ; scripting
			 "canvas"
			 "noscript"
			 "script"

			 ; demarcating edits
			 "del"
			 "ins"
 
			 ; table content
			 "caption"
			 "col"
			 "colgroup"
			 "table"
			 "tbody"
			 "td"
			 "tfoot"
			 "th"
			 "thead"
			 "tr"

			 ; forms
			 "button"
			 "datalist"
			 "fieldset"
			 "form"
			 "input"
			 "label"
			 "legend"
			 "meter"
			 "optgroup"
			 "options"
			 "output"
			 "progress"
			 "select"
			 "textarea"

			 ; interactive elements
			 "details"
			 "dialog"
			 "summary"

			 ; web components
			 "slot"
			 "template")))

    '(:language html
		:override t
		:feature delimiter
		(["<!" "</" "<" ">" "/>"] @font-lock-bracket-face)

		:language html
		:override t
		:feature comment
		((comment) @font-lock-comment-face)

		:language html
		:feature attribute
		((attribute (attribute_name) @font-lock-property-name-face
			    (quoted_attribute_value) @font-lock-string-face))

		:language html
		:feature tag
		((element [(start_tag (tag_name) @font-lock-function-call-face)
			   (end_tag (tag_name) @font-lock-function-call-face)
			   (self_closing_tag (tag_name) @font-lock-builtin-face)])
		 ,(cons ':not-any-of? '@font-lock-function-call-face (cons deprecated-tags html-elements)))

		:language html
		:feature tag
		:override t
		((element
		  [(start_tag (tag_name) @font-lock-warning-face)
		   (end_tag (tag_name) @font-lock-warning-face)]
		  ,(const ':any-of? @font-lock-warning-face deprecated-tags)))))

    ;; :language html
    ;; :feature tag
    ;; :override t
    ;; ((script_element
    ;;   [(start_tag (tag_name) @font-lock-builtin-face)
    ;;    (end_tag (tag_name) @font-lock-builtin-face)]
    ;;   (:any-of? @font-lock-builtin-face

(defvar html-ts-indent-rules
  `((html
     ((parent-is "element") parent 2)
     ((node-is ,(regexp-opt '("element" "self_closing_tag"))) parent 2))))

(defun html-ts-setup ()
  "Set up tree-sitter support for html-ts-mode."

  ; font locking
  (setq-local treesit-font-lock-feature-list
	      '((comment)
		(constant tag attribute)
		(declaration)
		(delimiter)))
  (setq-local treesit-font-lock-settings
	      (apply #'treesit-font-lock-rules
		     html-ts-font-lock-rules))

  ; indentation
  ;(setq-local treesit-simple-indent-rules html-ts-indent-rules)

  (treesit-major-mode-setup))

(define-derived-mode html-ts-mode sgml-mode "HTML[ts]"
  "Major mode for editing HTML files with tree-sitter."
  :syntax-table sgml-mode-syntax-table

  (setq-local font-lock-defaults nil)
  (when (treesit-ready-p 'html)
    (treesit-parser-create 'html)
    (html-ts-setup)))
