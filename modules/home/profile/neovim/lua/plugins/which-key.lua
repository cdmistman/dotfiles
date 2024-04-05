local M = {
	'which-key.nvim',
	lazy = false,

	opts = {},
}

function M:pre_setup_hook()
	vim.o.timeout = true
	vim.o.timeoutlen = 300
end

-- TODO: it's so much more natural to do verb-noun
function M:post_setup_hook(wk)
	wk.register({
		f = { name = '+file' },
		p = { name = '+project' },
	}, {
		prefix = '<leader>',
	})

	wk.register({
		name = '+buffer',
		n = { '<cmd>bn<cr>', 'next' },
		p = { '<cmd>bp<cr>', 'previous' },
		d = { '<cmd>bd<cr>', 'delete' },
	}, {
		prefix = '<leader>b',
	})

	wk.register({
		name = '+help',
		d = { '<cmd>helpc<cr>', 'close' },
		k = { '<cmd>WhichKey<cr>', 'keybindings' },
	}, {
		prefix = '<leader>h',
	})

	wk.register({
		name = '+window',
		h = { '<cmd>wincmd h<cr>', 'left' },
		j = { '<cmd>wincmd j<cr>', 'down' },
		k = { '<cmd>wincmd k<cr>', 'up' },
		l = { '<cmd>wincmd l<cr>', 'right' },
		S = { '<cmd>split<cr>', 'split' },
		s = { '<cmd>vsplit<cr>', 'vsplit' },
		d = { '<cmd>close<cr>', 'close' },
	}, {
		prefix = '<leader>w',
	})
end

return M
