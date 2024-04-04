return {
	'bufferline.nvim',
	event = 'UIEnter',
	opts = {
		options = {
			always_show_bufferline = true,
			diagnostics = 'nvim_lsp',
			mode = 'tabs',
		},
	},
}

