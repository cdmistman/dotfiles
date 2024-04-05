return {
	'nvim-treesitter-context',
	event = 'UIEnter',
	main = 'treesitter-context',

	opts = {
		multiline_threshold = 2,
		trim_scope = 'inner',
		mode = 'topline'
	}
}
