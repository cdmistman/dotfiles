return {
	'formatter.nvim',
	main = 'formatter',
	event = 'VeryLazy',

	opts = function()
		local filetypes = require('formatter.filetypes');

		return {
			logging = true,
			log_level = vim.log.levels.WARN,

			['*'] = filetypes.any.remove_trailing_whitespace,

			filetype = {
				html = filetypes.html.prettierd,
				rust = filetypes.rust.rustfmt,
			},
		}
	end,
}
