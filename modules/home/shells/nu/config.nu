# Default file at https://github.com/nushell/nushell/blob/main/crates/nu-utils/src/sample_config/default_config.nu
let-env config = {
	# TODO: theming
	# color_config: null,

	edit_mode: "vi",
	render_right_prompt_on_last_line: true,
	show_banner: false,

	completions: {
		algorithm: "fuzzy",
		external: {
			# TODO: use skim
			# completer: null,
			# External completer example
			# let carapace_completer = {|spans|
			# 	carapace $spans.0 nushell $spans | from json
			# }
		}
	}

	history: {
		file_format: "sqlite",
		sync_on_enter: false,
	}

	menus: [
		# TODO:
	]

	rm: {
		always_trash: false
	}

	table: {
		# TODO: what does this do???
		# show_empty: false
	}
}

def load [arg, --raw (-r)] {
	if $raw {
		open -r $arg
	} else {
		open $arg
	}
}
# TODO: after 0.77.1, use just `alias` https://github.com/nushell/nushell/pull/8557
old-alias open = ^open

alias k = clear
def kn [] { clear; printf "\e[3J" }

alias l = lsd -AL --group-directories-first
alias tree = l --tree

# let-env nu = ($nu)
