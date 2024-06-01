local fs = require('vanillin2.util.fs')

local M = {}

---Iterate over all of the modules in a directory.
---
---Based on https://github.com/folke/lazy.nvim/blob/96584866b9c5e998cbae300594d0ccfd0c464627/lua/lazy/core/util.lua#L207-L221.
---@generic T
---@param root string
---@param modname string
---@param opts? { recursive?: boolean }
---@return fun(state: T): string|nil, string|nil
---@return T
function M.walk(root, modname, opts)
	opts = opts or {}
	opts.recursive = opts.recursive or false

	modname = modname and (modname:gsub('%.$', '') .. '.') or ''
	local next_path, ls_state = fs.ls(root)

	---@class State
	---@field q fs.State[]
	---@field curr fs.State|nil

	---@param state State
	---@return string|nil modname
	---@return string|nil modpath
	local function next_mod(state)
		local curr = state.curr or state.q[#state.q]
		if curr == nil then
			return nil, nil
		end

		state.curr = curr

		local fname, name, ty = next_path(curr)
		if fname == nil then
			return nil, nil
		end

		if name == "init.lua" then
			return modname:gsub('%.$', ''), fname
		elseif (type == "file" or type == "link") and name:sub(-4) == ".lua" then
			return modname .. name:sub(1, -5), fname
		elseif type == "directory" and opts.recursive then
			_, state.q[#state.q + 1] = fs.ls(fname)
		end
	end

	return next_mod, { q = {}, curr = ls_state }
end

return M
