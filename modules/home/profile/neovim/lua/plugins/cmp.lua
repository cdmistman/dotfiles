--[[TODO: filter out functions marked deprecated???]]

local M = {
	'nvim-cmp',
	main = 'cmp',
	lazy = false,

	dependencies = {
		-- {
		-- 	'cmp-nvim-lsp',
		-- 	config = false,
		-- },
		{
			'copilot-cmp',
			dependencies = { 'copilot.lua' },
			main = 'copilot_cmp',
			config = true,
		},
	},
}

local function has_words_before()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

function M:opts()
	local cmp = require(self.main)
	local lspkind = require('lspkind')

	local opts = {}

	-- opts.formatting = {
	-- 	format = lspkind.cmp_format({
	-- 		mode = 'symbol',
	-- 		menu = {
	-- 			luasnip = '[Snip]',
	-- 			nvim_lsp = '[LSP]',
	-- 		},
	-- 	})
	-- }

	opts.mapping = {
		['<CR>'] = cmp.mapping({
			i = function(fallback)
				if cmp.visible() and cmp.get_selected_entry() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
				else
					fallback()
				end
			end,
			s = cmp.mapping.confirm({ select = true }),
			c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
		}),

		['<C-Space>'] = cmp.mapping.complete(),

		-- super tab mapping per https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
		['<Tab>'] = cmp.mapping(function(fallback)
			local luasnip = require('luasnip');
			-- https://github.com/zbirenbaum/copilot-cmp#tab-completion-configuration-highly-recommended
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<S-Tab>'] = cmp.mapping(function(fallback)
			local luasnip = require('luasnip')
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<BS>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.close()
			else
				fallback()
			end
		end),
	}

	opts.snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	}

	opts.sources = cmp.config.sources({
		{ name = 'copilot' },
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' }
	})

	-- cmp.setup.cmdline('/', {
	-- 	mapping = cmp.mapping.preset.cmdline(),
	-- 	sources = {
	-- 		{ name = 'buffer' }
	-- 	}
	-- })
	--
	-- cmp.setup.cmdline(':', {
	-- 	mapping = cmp.mapping.preset.cmdline(),
	-- 	sources = cmp.config.sources({
	-- 		{ name = 'path' }
	-- 	}, {
	-- 		{ name = 'cmdline' }
	-- 	}),
	-- 	matching = { disallow_symbol_nonprefix_matching = false }
	-- })
	--
	-- opts.view = {
	-- 	entries = {
	-- 		name = 'custom',
	-- 		selection_order = 'near_cursor',
	-- 	},
	-- }

	opts.window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	}

	opts.experimental = {
		ghost_text = true,
	}

	return opts
end

function M.post_setup_hook()
	vim.api.nvim_create_autocmd('BufEnter', {
		callback = function()
			-- vim.o.omnifunc =
		end
	})
end

return M
