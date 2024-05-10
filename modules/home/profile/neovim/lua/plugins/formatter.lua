return {
	'formatter.nvim',
	main = 'formatter',
	event = 'VeryLazy',

	opts = function()
		local filetypes = require('formatter.filetypes');

		vim.api.nvim_create_augroup("__formatter__", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = "__formatter__",
			command = ":FormatWrite",
		})

		return {
			logging = true,
			log_level = vim.log.levels.WARN,

			['*'] = filetypes.any.remove_trailing_whitespace,

			filetype = {
				go = {
					filetypes.go.gofmt,
					filetypes.go.goimports,
				},
				html = filetypes.html.prettierd,
				rust = filetypes.rust.rustfmt,
				zig = filetypes.zig.zigfmt,
			},
		}
	end,
}
