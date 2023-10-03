vim.g.editorconfig = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

local which_key = require('which-key')
which_key.setup()

require('auto-save').setup()

require('bufferline').setup()

local cmp = require('cmp')
cmp.setup({
	-- TODO: use whichkey instead
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
	}),
	snipped = {
		expand = function(args)
			vim.fn['vsnip#anonymous'](args.body)
		end
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' }
	}, {
		name = 'buffer',
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
})

require('Comment').setup()

do
	local lsp = require('lspconfig')
	local capabilities = require('cmp_nvim_lsp').default_capabilities()

	local on_attach = function(client, buffer)
		which_key.register({
			g = {
				name = "Go",
				["."] = {
					"<cmd>lua vim.lsp.buf.definition()<cr>",
					"Definition",
				},
				d = {
					"<cmd>lua vim.lsp.buf.declaration()<cr>",
					"Declaration",
				},
				D = {
					"<cmd>lua vim.lsp.buf.type_definition()<cr>",
					"Type definition",
				},
				h = {
					"<cmd>lua vim.lsp.buf.hover()<cr>",
					"Hover",
				},
				i = {
					"<cmd>lua vim.lsp.buf.implementation()<cr>",
					"Implementation",
				},
				r = {
					"<cmd>lua vim.lsp.buf.references()<cr>",
					"References",
				},
				s = {
					"<cmd>lua vim.lsp.buf.signature_help()<cr>",
					"Signature help",
				},
				n = {
					"<cmd>lua vim.lsp.diagnostic.goto_next()<cr>",
					"Next diagnostic",
				},
				p = {
					"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
					"Previous diagnostic",
				},
			},

			["<leader>c"] = {
				name = "Code",
				a = {
					"<cmd>lua vim.lsp.buf.code_action()<cr>",
					"Code action",
				},
				f = {
					"<cmd>lua vim.lsp.buf.formatting()<cr>",
					"Format",
				},
				r = {
					"<cmd>lua vim.lsp.buf.rename()<cr>",
					"Rename",
				},
			},
		}, {
			buffer = buffer,
		})
	end

	opts = {
		capabilities = capabilities,
		on_attach = on_attach,
	}

	lsp.nil_ls.setup(opts)
	lsp.tsserver.setup(opts)

	require('rust-tools').setup({
		capabilities = capabilities,
		on_attach = on_attach,
		server = {
			settings = {
				['rust-analyzer'] = {
					check = {
						extraArgs = { "--target-dir", "target/rust-analyzer/check" },
					},
				},
			},
		},
	})
end

require('neoscroll').setup()
-- TODO: keymaps

require('neo-tree').setup({
	sort_case_insensitive = true,
	default_component_configs = {
		indent = {
			indent_size = 1,
		},
	},
	window = {
		position = "left",
	},
})

require('noice').setup()

require('telescope').setup()
which_key.register({
	["<leader>f"] = {
		name = "Find",
		f = {
			"<cmd>lua require('telescope.builtin').find_files()<cr>",
			"Files",
		},
		g = {
			"<cmd>lua require('telescope.builtin').live_grep()<cr>",
			"Grep",
		},
		b = {
			"<cmd>lua require('telescope.builtin').buffers()<cr>",
			"Buffers",
		},
		h = {
			"<cmd>lua require('telescope.builtin').help_tags()<cr>",
			"Help",
		},
	},
})

require('treesitter-context').setup()

require('twilight').setup()
vim.api.nvim_create_autocmd({ "UIEnter" }, {
	command = "TwilightEnable",
})
