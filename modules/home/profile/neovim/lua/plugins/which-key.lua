return {
	'which-key.nvim',
	lazy = false,
	opts = {},

	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,

	post_setup_hook = function()
		require('which-key').register({
			['<leader>'] = {
				name = '+more',
				f = { name = '+file' },
				p = { name = '+project' },

				b = {
					name = '+buffer',
					n = { '<cmd>bn<cr>', 'next' },
					p = { '<cmd>bp<cr>', 'previous' },
					d = { '<cmd>bd<cr>', 'delete' },
				},

				w = {
					name = '+window',
					h = { '<cmd>wincmd h<cr>', 'left' },
					j = { '<cmd>wincmd j<cr>', 'down' },
					k = { '<cmd>wincmd k<cr>', 'up' },
					l = { '<cmd>wincmd l<cr>', 'right' },
					S = { '<cmd>split<cr>', 'split' },
					s = { '<cmd>vsplit<cr>', 'vsplit' },
					d = { '<cmd>close<cr>', 'close' },
				}
			}
		})
	end
}
