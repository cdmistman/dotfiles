local M = {
	'nvim-lspconfig',
	main = 'lspconfig',
	lazy = false,

	dependencies = {
		'nvim-cmp',
	},
}

function M:init()
	-- rustaceanvim doesn't use setup() args
	vim.g.rustaceanvim = {
		tools = {
			enable_clippy = true,
		},
		server = {
			capabilities = vim.g.lsp_capabilities or vim.lsp.protocol.make_client_capabilities(),
			default_settings = {
				['rust-analyzer'] = {
					cargo = {
						extraArgs = { '--target-dir', 'target/rust-analyzer' },
					},
					files = {
						excludeDirs = {
							'.direnv',
							'.git',
							'.jj',
							'result',
						},
					},
				},
			},
		},
	}
end

local function buf_load_lsp_keymap(ev)
	local wk = require('which-key')

	local function code_format()
		vim.lsp.buf.format({
			async = true,
		})
	end

	wk.register({
		g = {
			d = { vim.lsp.buf.definition, 'definition' },
			D = { vim.lsp.buf.declaration, 'declaration' },
			i = { vim.lsp.buf.implementation, 'implementation' },
			r = { vim.lsp.buf.references, 'references' },
		},
	}, {
		buffer = ev.buf,
	})

	wk.register({
		c = {
			a = { vim.lsp.buf.code_action, 'action', mode = { 'n', 'v' } },
			d = {
				name = '+diagnostic',
				n = { vim.diagnostic.goto_next, 'next' },
				N = { vim.diagnostic.goto_prev, 'previous' },
				H = { vim.diagnostic.open_float, 'show' },
			},
			f = { code_format, 'format' },
			l = { vim.lsp.codelens.refresh, 'codelens' },
			r = { vim.lsp.buf.rename, 'rename' },
		},
		g = {
			d = { vim.lsp.buf.definition, 'definition' },
			D = { vim.lsp.buf.declaration, 'declaration' },
			i = { vim.lsp.buf.implementation, 'implementation' },
			r = { vim.lsp.buf.references, 'references' },
		},
		H = { vim.lsp.buf.hover, 'hover' },
	}, {
		prefix = '<leader>',
		buffer = ev.buf,
	})
end

function M:config(opts)
	local cmp = require('cmp_nvim_lsp')

	local lsp = require(self.main)

	for lsName, lsConfig in pairs(opts) do
		lsConfig.capabilities = cmp.default_capabilities()
		lsp[lsName].setup(lsConfig)
	end

	vim.api.nvim_create_autocmd('LSPAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = buf_load_lsp_keymap,
	})
end

function M.opts()
	local pathlib = require('plenary.path')
	local util = require('lspconfig.util')

	local opts = {}

	local basic = { 'biome', 'clangd', 'cssls', 'eslint', 'gopls', 'graphql', 'hls', 'html', 'jsonls', 'marksman', 'nixd', 'nushell', 'svelte', 'taplo', 'tsserver', 'zls' }

	for _, lsName in ipairs(basic) do
		opts[lsName] = {}
	end

	opts.lua_ls = {
		on_init = function(client)
			local path = pathlib.new(client.workspace_folders[1].name)
			if path:joinpath('.luarc.json'):exists() or path:joinpath('.luarc.jsonc'):exists() then
				return true
			end
			client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
				Lua = {
					runtime = {
						version = 'LuaJIT',
					},
					workspace = {
						checkThirdParty = false,
						library = vim.api.nvim_get_runtime_file('', true),
					},
				}
			})
			client.notify('workspace/didChangeConfiguration', {
				settings = client.config.settings,
			})
			return true
		end,
	}

	opts.tailwindcss = {
		root_dir = util.root_pattern(
			'tailwind.config.js',
			'tailwind.config.cjs',
			'tailwind.config.mjs',
			'tailwind.config.ts',
			'postcss.config.js',
			'postcss.config.cjs',
			'postcss.config.mjs',
			'postcss.config.ts'
		),
	}

	return opts
end


return M
