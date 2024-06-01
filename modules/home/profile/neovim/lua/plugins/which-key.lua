return {
	'which-key.nvim',

	dependencies = {
		'neo-tree.nvim'
	},

	opts = {},

	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,

	post_setup_hook = function()
		require('which-key').register({
			g = {
				name = '+go',
				noremap = false,
				B = {
					name = '+buffer',
					noremap = false,
					-- l = { }, TODO: buffer list
					n = { '<cmd>bn<cr>', 'next' },
					p = { '<cmd>bp<cr>', 'previous' },
				},
				F = { "<cmd>Neotree toggle left<cr>", "list" },
			},

			['<leader>'] = {
				name = '+more',
				noremap = false,

				f = {
					name = '+find',
				},

				w = {
					name = '+window',
					h = { '<cmd>wincmd h<cr>', 'left' },
					j = { '<cmd>wincmd j<cr>', 'down' },
					k = { '<cmd>wincmd k<cr>', 'up' },
					l = { '<cmd>wincmd l<cr>', 'right' },

					s = { '<cmd>vsp<cr>', 'split' },
					S = { '<cmd>sp<cr>', 'horizontal split' },

					d = { '<cmd>close<cr>', 'close' },
				}
			}
		})
	end
}
