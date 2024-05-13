local M = {}

local util = require('vanillin.util')
local Graph = require('vanillin.graph')
local VanPlugin = require('vanillin.plugin')

function M.setup()
	local dir = vim.fn.stdpath('config')
	local graph = Graph.new()

	util.walkmods(
		dir .. '/lua/plugins',
		function (modname, modpath)
			local plugin = require('plugins.' .. modname)
			if not plugin[1] then
				vim.notify(
					'plugin "' .. modname .. '" at ' .. modpath .. ' has no name, skipping: ' .. vim.inspect(plugin)
				)
			else
				VanPlugin.new(plugin, graph)
			end
		end
	)

	local eager = graph:subgraph()
	local lazy = graph:subgraph()

	local maxPluginID = 0
	for id, plugin in graph:iter_nodes() do
		maxPluginID = math.max(maxPluginID, id)
		---@cast plugin VanPlugin
		plugin:validate(graph)
	end

	for node, plugin in graph:iter_nodes() do
		if plugin.lazy == true then
			eager:remove_node(node)
		else
			lazy:remove_node(node)
		end
	end

	for _, plugin in graph:toposort() do
		---@cast plugin VanPlugin
		if type(plugin['init']) == 'function' then
			plugin:init()
		end
	end

	for id, plugin in lazy:toposort() do
		---@cast plugin VanPlugin
		plugin:lazy_load(graph)
	end

	for id, plugin in eager:toposort() do
		---@cast plugin VanPlugin
		plugin:load(graph)
	end

	vim.schedule(
		function()
			vim.api.nvim_exec_autocmds('User', {
				pattern = 'VeryLazy',
			})
		end
	)
end

return M
