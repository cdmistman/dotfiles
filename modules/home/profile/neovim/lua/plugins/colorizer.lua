return {
	'nvim-colorizer.lua',
	main = 'colorizer',

	opts = {
		user_default_options = {
			tailwind = 'lsp',
		},
		filetypes = {
			html = {
				tailwind = 'both',
			},
		},
	},
}
