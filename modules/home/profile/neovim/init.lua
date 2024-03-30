vim.g.editorconfig = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

local log = require('log')
local Util = require('util')

local plugins = {}

local function addPlugin(cfg)
	if type(cfg) ~= 'table' then
		log.err('plugin config should be a table')
		return
	end

	local pluginName = cfg[1]
	if pluginName == nil then
		log.err('not loading, option [1] not specified.')
		return
	end

	if plugins[pluginName] ~= nil then
		log.err('already defined!')
		return
	end

	plugins[pluginName] = cfg

	local dependencies = {}
	for ii, dep in ipairs(cfg.dependencies or {}) do
		if type(dep) == 'table' then
			addPlugin(dep)
			dependencies[ii] = dep[1]
		elseif type(dep) == 'string' then
			dependencies[ii] = dep
		else
			log.err('unrecognized dependency type: ' .. vim.inspect(dep))
		end
	end

	local setupPlugin = function(ev)
		if ev ~= nil then
			log.debug('setting up plugin ' .. pluginName .. ' for event ' .. ev.event .. ' : ' .. vim.inspect(ev))
		else
			log.debug('setting up plugin ' .. pluginName)
		end

		if #dependencies > 0 then
			vim.api.nvim_exec_autocmds('User', {
				pattern = dependencies,
			})
		end

		if type(cfg['pre_setup_hook']) == 'function' then
			cfg:pre_setup_hook()
		end

		local module = nil
		if cfg['opts'] ~= nil or (cfg['config'] ~= false and cfg['config'] ~= nil) then
			local main = cfg.main or pluginName
			main = main:match('(.*)%..*') or main
			module = require(main)

			local opts = cfg['opts'] or {}
			if type(opts) == 'function' then
				opts = cfg:opts(module)
			end

			if type(cfg['config']) == 'function' then
				cfg:config(opts, main)
			else
				module.setup(opts)
			end
		end

		if type(cfg['post_setup_hook']) == 'function' then
			cfg:post_setup_hook(module)
		end
	end

	if cfg['lazy'] == false then
		setupPlugin()
		return
	end

	vim.api.nvim_create_autocmd({'User'}, {
		pattern = pluginName,
		once = true,
		nested = true,
		callback = setupPlugin,
	})

	if cfg['event'] == nil then
		log.debug('no events')
		return
	end

	local events = cfg.event
	if type(events) == 'string' then
		events = { events }
	elseif type(events) ~= 'table' then
		log.err('option \'events\' should be a table or a string')
		return
	end
	log.debug('processing events: ' .. vim.inspect(events))

	local is_very_lazy = false
	local shift = 0

	for ii, ev in ipairs(events) do
		if ev == 'VeryLazy' then
			is_very_lazy = true
			shift = shift + 1
		end

		events[ii] = nil
		events[ii - shift] = ev
	end

	if is_very_lazy then
		-- this gets set by the last part of the for loop
		events[0] = nil
		vim.api.nvim_create_autocmd('User', {
			pattern = 'VeryLazy',
			once = true,
			callback = function()
				vim.api.nvim_exec_autocmds('User', {
					pattern = pluginName,
				})
			end,
		})
	end

	log.debug('events for ' .. pluginName .. ': ' .. vim.inspect(events))
	if #events > 0 then
		vim.api.nvim_create_autocmd(events, {
			once = true,
			callback = function()
				vim.api.nvim_exec_autocmds('User', {
					pattern = pluginName,
				})
			end,
		})
	end
end

local thisdir = debug.getinfo(1, 'S').source:sub(2):match('(.*/)')
Util.walkmods(
	thisdir .. "lua/plugins",
	function(modname, modpath)
		log.debug('loading config ' .. modname .. ' at ' .. modpath)
		addPlugin(require(modname))
	end,
	'plugins'
)

vim.schedule(
	function()
		vim.api.nvim_exec_autocmds('User', {
			pattern = 'VeryLazy',
		})
	end
)

