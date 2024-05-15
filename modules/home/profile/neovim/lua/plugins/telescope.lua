return {
	'telescope.nvim',
	event = 'VeryLazy',

	dependencies = {
		'which-key.nvim'
	},

	opts = {
		extensions = {
			'aerial',
		},
	},

	post_setup_hook = function()
		local builtin = require('telescope.builtin')
		local extensions = require('telescope').extensions

		-- TODO: hydra-ify
		require('which-key').register({
			['<leader>f'] = {
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
