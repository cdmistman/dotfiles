return {
	'aerial.nvim',
	enabled = false,

	event = 'VeryLazy',

	dependencies = {
		'nvim-web-devicons',
		'nvim-treesitter',
	},

	opts = {
		layout = {
			placement = 'edge',
			resize_to_content = false,
			preserve_equality = true,
		},

		attach_mode = 'global',
		filter_kind = false,

		on_attach = function(bufnr)
			vim.cmd[[ AerialOpen! ]]

			local wk = require('which-key')
			wk.register({
				buffer = bufnr,
				gs = {
					name = "+symbol",
					l = { '<cmd>AerialOpen<CR>', 'list' },
					-- f = { '<cmd><CR>', 'fuzz' }, TODO: telescope
					n = { '<cmd>AerialNext<CR>', 'next' },
					p = { '<cmd>AerialPrev<CR>', 'prev' },
				},
				['<leader>aa'] = { '<cmd>AerialToggle<CR>', 'Toggle Aerial' }, -- ! right
				['<leader>an'] = { '<cmd>AerialNavToggle<CR>', 'Toggle Aerial Nav' },
			})
		end,
	},
}
