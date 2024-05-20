return {
	'telescope.nvim',
	event = 'VeryLazy',

	dependencies = {
		'which-key.nvim'
	},

	opts = {
		defaults = {
			scroll_strategy = 'limit',
			dynamic_preview_title = true,
			results_title = false,
			prompt_title = false,
			use_less = false,
		},

		extensions = {
			'aerial',
		},
	},

	post_setup_hook = function()
		local builtin = require('telescope.builtin')
		local extensions = require('telescope').extensions

		require('which-key').register({
			['<leader>t'] = {
				name = '+find',
				['/'] = { builtin.current_buffer_fuzzy_find, 'current buffer' },
				['?'] = { builtin.help_tags, 'help' },
				b = { builtin.buffers, 'buffers' },
				f = { builtin.find_files, 'file' },
				r = { builtin.live_grep, 'regex' },
				s = { extensions.aerial.aerial, 'symbols' },
			},
		})
	end
}
