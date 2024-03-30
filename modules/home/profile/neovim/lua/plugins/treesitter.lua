return {
	'nvim-treesitter',
	event = 'UIEnter',
	config = true,

	post_setup_hook = function()
		require('nvim-treesitter.configs').setup({
			highlight = {
				enable = true,
			},
		})
	end
}

