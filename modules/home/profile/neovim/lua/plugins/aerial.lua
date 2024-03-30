return {
	'aerial.nvim',
	event = 'VeryLazy',

	dependencies = {
		'nvim-web-devicons',
		'nvim-lspconfig',
		'rust-tools',
	},

	opts = {
		float = {
			relative = 'win',
		},
		layout = {
			default_direction = 'float'
		},
	},
}

