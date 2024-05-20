local M = {
	'nvim-lspconfig',
	main = 'lspconfig',
	dependencies = { 'nvim-treesitter' },
}

function M:init()
	-- rustaceanvim doesn't use setup() args
	vim.g.rustaceanvim = {
		tools = {
			enable_clippy = true,
			reload_workspace_from_cargo_toml = true,
			-- TODO: hover_actions = true,
			-- TODO: float_win_config = {}
		},
		server = {
			capabilities = self.capabilities,
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

function M:config(opts)
	local cmp = require('cmp_nvim_lsp')

	local lsp = require(self.main)

	for lsName, lsConfig in pairs(opts) do
		lsConfig.capabilities = cmp.default_capabilities()
		lsp[lsName].setup(lsConfig)
	end

	local augroup = vim.api.nvim_create_augroup('UserLspConfig', {})
	vim.api.nvim_create_autocmd('LspAttach', {
		group = augroup,
		---@param ev { buf: integer, data: { client_id: integer } }
		callback = function(ev)
			local bufnr = ev.buf
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if client == nil then
				vim.notify('no client attached for LspAttach event :(')
				return
			end

			require('lsp-format').on_attach(client, bufnr)
			self:on_attach(ev)
		end,
	})
end

function M:opts()
	local util = require('lspconfig.util')

	local opts = {}

	for _, lsName in ipairs({
		'biome',
		'clangd',
		'cssls',
		'graphql',
		'hls',
		-- 'jsonls',
		'marksman',
		'nixd',
		'nushell',
		'svelte',
		'taplo',
		'templ',
		'tsserver',
		'zls'
	}) do
		opts[lsName] = {}
	end

	opts.eslint = {
		on_attach = function(_, bufnr)
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				command = "EslintFixAll",
			})
		end
	}

	opts.gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				gofumpt = true,
				-- TODO: local = '~/path/to/project',
				-- navigation = {
				importShortcut = "Definition"
				-- },
			},
		},
		on_attach = function(args)
			self:on_attach(args)
		end
	}

	opts.html = {
		filetypes = { 'html' }
	}

	opts.htmx = {
		filetypes = { 'html', 'templ' }
	}

	opts.lua_ls = {
		on_init = function(client)
			local path = client.workspace_folders[1].name
			if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
				return
			end

			client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT'
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					-- library = {
					-- 	vim.env.VIMRUNTIME
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
					-- },
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
					library = vim.api.nvim_get_runtime_file("", true)
				}
			})
		end,
		settings = {
			Lua = {}
		}
	}

	local tailwindRootDir = {}
	for _, fileName in ipairs({ 'tailwind.config', 'postcss.config' }) do
		for _, ext in ipairs({ 'js', 'cjs', 'mjs', 'ts' }) do
			table.insert(tailwindRootDir, fileName .. ext)
			table.insert(tailwindRootDir, '.' .. fileName .. '.' .. ext)
		end
	end

	opts.tailwindcss = {
		root_dir = util.root_pattern(unpack(tailwindRootDir)),
		filetypes = { 'templ', 'html' },
		init_options = {
			includeLanguages = { templ = "html" },
		},
	}

	return opts
end

---@param bufnr integer
---@param client vim.lsp.Client
function M:on_attach(bufnr, client)
	local buf_write_actions = {}

	-- if client.server_capabilities.documentFormattingProvider then
	-- 	vim.notify('enabling format on save for ' .. client.name)
	-- 	table.insert(buf_write_actions, function()
	-- 	end)
	-- end

	-- local bufnr = args.buf
	-- local client = vim.lsp.get_client_by_id(args.data.client_id)
	-- if client == nil then
	-- 	vim.notify('no client attached for lspattach event :(')
	-- 	return
	-- end
	--
	-- local do_format = false
	-- if client.capabilities.textDocument.formatting

	-- vim.notify(
	-- 	'just got attached!\nself = ' ..
	-- 	vim.inspect(self) ..
	-- 	'\nclient = ' .. vim.inspect(client) .. '\nbufnr = ' .. vim.pretty_print(bufnr)
	-- )

	-- local function code_format()
	-- 	vim.lsp.buf.format({
	-- 		async = true,
	-- 	})
	-- end

	-- wk.register({
	-- 	g = {
	-- 		d = { vim.lsp.buf.definition, 'definition' },
	-- 		D = { vim.lsp.buf.declaration, 'declaration' },
	-- 		i = { vim.lsp.buf.implementation, 'implementation' },
	-- 		r = { vim.lsp.buf.references, 'references' },
	-- 	},
	-- }, {
	-- 	buffer = ev.buf,
	-- })
	--
	-- wk.register({
	-- 	c = {
	-- 		a = { vim.lsp.buf.code_action, 'action', mode = { 'n', 'v' } },
	-- 		d = {
	-- 			name = '+diagnostic',
	-- 			n = { vim.diagnostic.goto_next, 'next' },
	-- 			N = { vim.diagnostic.goto_prev, 'previous' },
	-- 			H = { vim.diagnostic.open_float, 'show' },
	-- 		},
	-- 		f = { code_format, 'format' },
	-- 		l = { vim.lsp.codelens.refresh, 'codelens' },
	-- 		r = { vim.lsp.buf.rename, 'rename' },
	-- 	},
	-- 	g = {
	-- 		d = { vim.lsp.buf.definition, 'definition' },
	-- 		D = { vim.lsp.buf.declaration, 'declaration' },
	-- 		i = { vim.lsp.buf.implementation, 'implementation' },
	-- 		r = { vim.lsp.buf.references, 'references' },
	-- 	},
	-- 	H = { vim.lsp.buf.hover, 'hover' },
	-- }, {
	-- 	prefix = '<leader>',
	-- 	buffer = ev.buf,
	-- })
end

function M:on_attach_go(ev)
	vim.opt.tabstop = 4
	vim.api.nvim_create_autocmd('BufWritePre', {
		buffer = ev.buf,
		callback = function()
			local params = vim.lsp.util.make_range_params()
			params.context = { only = { "source.organizeImports" } }
			-- buf_request_sync defaults to a 1000ms timeout. Depending on your
			-- machine and codebase, you may want longer. Add an additional
			-- argument after params if you find that you have to write the file
			-- twice for changes to be saved.
			-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
			for cid, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					if r.edit then
						local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
						vim.lsp.util.apply_workspace_edit(r.edit, enc)
					end
				end
			end
			vim.lsp.buf.format({ async = false })
		end,
	})
end

return M
