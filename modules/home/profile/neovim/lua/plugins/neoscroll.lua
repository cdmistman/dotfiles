return {
	'neoscroll.nvim',
	event = 'VeryLazy',

	opts = {
		-- TODO: for some reason which-key isn't showing what prefix z means (nor some others???)
		mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
	},
}
