-- TODO:
local function get_selection_window(picker, entry)
end

return {
	'telescope.nvim',
	event = 'VeryLazy',

	dependencies = {
		'which-key.nvim'
	},

	opts = {
		defaults = {
			dynamic_preview_title = true,
			prompt_title = false,
			results_title = false,
			scroll_strategy = 'limit',
			use_less = false,
		},

		extensions = {
			'aerial',
		},

		pickers = {
			help_tags = {
				mappings = {
					n = {
						['<CR>'] = 'select_vertical',
					},
					i = {
						['<CR>'] = 'select_vertical',
					}
				},
			},
		},
	},

	post_setup_hook = function()
		local builtin = require('telescope.builtin')
		local extensions = require('telescope').extensions

		require('which-key').register({
			['<leader>f'] = {
				name = '+ find',
				['/'] = { builtin.current_buffer_fuzzy_find, 'current buffer' },
				['?'] = { builtin.help_tags, 'help' },
				[':'] = { builtin.commands, 'Commands' },
				b = { builtin.buffers, 'Buffers' },
				d = { builtin.diagnostics, 'Diagnostics' },
				f = { builtin.find_files, 'File' },
				g = { builtin.live_grep, 'Grep' },
				j = { builtin.jumplist, 'Jumplist' },
				m = { builtin.marks, 'Marks' },
				q = { builtin.quickfix, 'Quickfix' },
				Q = { builtin.quickfixhistory, 'Quickfix history' },
				r = { builtin.registers, 'Registers' },
				s = { extensions.aerial.aerial, 'Symbols' },
				S = { builtin.treesitter, 'treeSitter' },
				t = { builtin.tags, 'Tags' },
			},
		})
	end
}
