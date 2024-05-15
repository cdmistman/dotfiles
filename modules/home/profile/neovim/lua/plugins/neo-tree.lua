return {
	'neo-tree.nvim',
	event = 'VeryLazy',

	dependencies = {
		'nui.nvim',
		'nvim-web-devicons',
		'plenary.nvim',
	},

	opts = {
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
			},
			group_empty_dirs = true,
		},
	},
}
