local M = {
	'neo-tree.nvim',
	event = 'VeryLazy',

	dependencies = {
		'nui.nvim',
		'nvim-web-devicons',
		'plenary.nvim',
	},

	opts = {
		window = {
			position = 'float',
		},
	},
}

function M:post_setup_hook(neotree)
	local wk = require('which-key')

	wk.register({
		["<leader>ft"] = { "<cmd>Neotree toggle<cr>", "filetree" },
	})
end

return M

