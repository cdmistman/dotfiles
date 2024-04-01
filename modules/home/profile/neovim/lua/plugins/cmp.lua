local M = {
	'nvim-cmp',
	main = 'cmp',
	event = 'VeryLazy',

	dependencies = {
		{
			'cmp-nvim-lsp',
		},
		{
			'copilot-cmp',
			dependencies = { 'copilot.lua' },
			main = 'copilot_cmp',
			config = true,
		}
	},
}

local function has_words_before()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line-1, line, true)[1]:sub(col, col):match('%s') == nil
end

function M:opts(cmp)
	local mapping = {
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
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
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
			elseif luasnip.jumpable(-1) then
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

	local snippet = {
		expand = function(args)
			vim.fn['vsnip#anonymous'](args.body)
		end,
	}

	local sources = cmp.config.sources({
		{ name = 'copilot' },
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' }
	})

	return {
		mapping = mapping,
		snippet = snippet,
		sources = sources,
		window = {},
	}
end

function M:post_setup_hook()
	vim.g.lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
end

return M

