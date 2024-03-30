return {
	'tokyonight.nvim',
	lazy = false,

	opts = {
		style = 'night',
	},

	post_setup_hook = function()
		vim.cmd([[colorscheme tokyonight]])
	end
}
