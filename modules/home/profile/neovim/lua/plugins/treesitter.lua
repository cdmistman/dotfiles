return {
	'nvim-treesitter',
	event = 'UIEnter',
	config = true,

	main = 'nvim-treesitter.configs',
	opts = {
		highlight = {
			enable = true,
		},
	},
}
