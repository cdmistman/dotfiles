local M = {
	'neo-tree.nvim',
	event = 'VeryLazy',

	dependencies = {
		'nui.nvim',
		'nvim-web-devicons',
		'plenary.nvim',
	},

	opts = {},
}

function M:post_setup_hook()
	local wk = require('which-key')

	-- TODO: make neotree work with :n and :p
	-- TODO: fix neotree bindings
	wk.register({
		["<leader>ft"] = { "<cmd>Neotree toggle left<cr>", "tree" },
	})
end

return M
