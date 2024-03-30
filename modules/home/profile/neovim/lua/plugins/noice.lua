return {
	'noice.nvim',
	event = 'VeryLazy',

	dependencies = {
		'nui.nvim',

		{
			'nvim-notify',
			main = 'notify',
			opts = {
				minimum_width = '25',
				render = 'compact',
				timeout = 3000,
			},
		},
	},

	opts = {
		lsp = {
			override = {
				['vim.lsp.util.convert_input_to_markdown_lines'] = true,
				['vim.lsp.util.stylize_markdown'] = true,
				['cmp.entry.get_documentation'] = true,
			},
		},

		messages = {
			enabled = true,
		},

		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		},
	},
}

