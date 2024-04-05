local M = {}

--- source: https://github.com/folke/lazy.nvim/blob/96584866b9c5e998cbae300594d0ccfd0c464627/lua/lazy/core/util.lua#L174-L194
---@alias FileType "file"|"directory"|"link"
---@param path string
---@param fn fun(path: string, name:string, type:FileType):boolean?
function M.ls(path, fn)
	local handle = vim.loop.fs_scandir(path)
	while handle do
		local name, t = vim.loop.fs_scandir_next(handle)
		if not name then
			break
		end

		local fname = path .. "/" .. name

		-- HACK: type is not always returned due to a bug in luv,
		-- so fecth it with fs_stat instead when needed.
		-- see https://github.com/folke/lazy.nvim/issues/306
		if fn(fname, name, t or vim.loop.fs_stat(fname).type) == false then
			break
		end
	end
end

--- source: https://github.com/folke/lazy.nvim/blob/96584866b9c5e998cbae300594d0ccfd0c464627/lua/lazy/core/util.lua#L207-L221
---@param root string
---@param fn fun(modname:string, modpath:string)
---@param modname? string
function M.walkmods(root, fn, modname)
	modname = modname and (modname:gsub("%.$", "") .. ".") or ""
	M.ls(root, function(path, name, type)
		if name == "init.lua" then
			fn(modname:gsub("%.$", ""), path)
		elseif (type == "file" or type == "link") and name:sub(-4) == ".lua" then
			fn(modname .. name:sub(1, -5), path)
		elseif type == "directory" then
			M.walkmods(path, fn, modname .. name .. ".")
		end
	end)
end

return M
