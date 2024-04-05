-- TODO: jsregex
return {
	'LuaSnip',
	main = 'luasnip',
	event = 'VeryLazy',

	post_setup_hook = function()
		require("luasnip.loaders.from_snipmate").lazy_load()
	end
};
