local Graph = require('vanillin2.graph')

local M = {}

--- source: https://github.com/folke/lazy.nvim/blob/96584866b9c5e998cbae300594d0ccfd0c464627/lua/lazy/core/util.lua#L207-L221
---@param root string
---@param fn fun(modname:string, modpath:string)
---@param modname? string
---@param opts? { recursive?: boolean }
local function walkmods(root, fn, modname, opts)
	modname = modname and (modname:gsub("%.$", "") .. ".") or ""
	M.ls(root, function(path, name, type)
		if name == "init.lua" then
			fn(modname:gsub("%.$", ""), path)
		elseif (type == "file" or type == "link") and name:sub(-4) == ".lua" then
			fn(modname .. name:sub(1, -5), path)
		elseif type == "directory" and opts and opts.recursive then
			M.walkmods(path, fn, modname .. name .. ".")
		end
	end)
end

function M.setup()
	local dir = vim.fn.stdpath('config')
	local graph = Graph()
	---@cast graph vanillin.Graph

	walkmods(
		dir .. '/lua/plugins',
		function(modname, modpath)
		end
	)
end

return M
