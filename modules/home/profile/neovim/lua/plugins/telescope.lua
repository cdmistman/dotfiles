local M = {
	'telescope.nvim',
	event = 'VeryLazy',

	opts = {},
}

function M:post_setup_hook()
	local builtins = require('telescope.builtin')
	local wk = require('which-key')

	wk.register(
		{
			ff = { builtins.find_files, 'find' },
			ps = { builtins.live_grep, 'grep' },
			bf = { builtins.buffers, 'find' },
			hf = { builtins.help_tags, 'find' },
		}, {
			prefix = '<leader>',
		}
	)
end

return M

