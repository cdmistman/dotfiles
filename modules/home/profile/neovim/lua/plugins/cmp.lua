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
		['<Tab>'] = cmp.mapping(function(fallback)
			-- https://github.com/zbirenbaum/copilot-cmp#tab-completion-configuration-highly-recommended
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			else
				fallback()
			end
		end),
		['\\'] = cmp.mapping(function(fallback)
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
	}
end

function M:post_setup_hook()
	vim.g.lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
end

return M

