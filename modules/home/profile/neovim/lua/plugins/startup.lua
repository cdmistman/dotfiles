return {
	'startup.nvim',
	lazy = false,

	dependencies = {
		'telescope.nvim',
	},

	opts = {
		--		header = {
		--			type = "text",
		--			oldfiles_directory = false,
		--			align = "center",
		--			fold_section = false,
		--			title = "Something",
		--			margin = 1,
		--			content = {
		--				"hi",
		--				"there", -- If I delete this, I get the error.
		--			},
		--			highlight = "Normal",
		--			default_color = "",
		--			oldfiles_amount = 0,
		--    },
		--    parts = {"header"},
	},
}
