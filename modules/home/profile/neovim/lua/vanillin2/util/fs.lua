local class = require('vanillin2.util.class')

local M = {}

M.Walker = class()

function M.Walker:initialize()
end

return M

-- local M = {}
--
--
--
-- ---@class fs.WalkState
-- ---@field curr unknown
-- ---@field q unknown[]
--
-- ---Initializes a walking iterator
-- ---@param path any
-- ---@return table
-- function M.walk_init(path)
-- 	return {}
-- end
--
-- ---Return the next iteration from walking through a path
-- ---@param state fs.WalkState
-- function M.walk_next(state)
-- end
--
-- ---@class fs.State an opaque state type
--
-- ---Iterate over all of the paths in a given path. Note that the function
-- ---return type is for convenience - in reality, if the first return value
-- ---is nil, then the rest of the values are as well.
-- ---
-- ---Based on https://github.com/folke/lazy.nvim/blob/96584866b9c5e998cbae300594d0ccfd0c464627/lua/lazy/core/util.lua#L174-L194.
-- ---@param path string
-- ---@param opts? { recursive?: boolean }
-- ---@return fun(state: fs.State): string|nil, string, string
-- ---@return fs.State
-- function M.ls(path, opts)
-- 	opts = opts or {}
-- 	opts.recursive = opts.recursive or false
--
-- 	---@type fs.State
-- 	local handle = vim.uv.fs_scandir()
--
-- 	---@param state fs.State
-- 	---@return string|nil fname the path starting with `path` of the dirent
-- 	---@return string|nil basename the basename of the dirent
-- 	---@return string|nil ty the dirent kind
-- 	local function next_path(state)
-- 		---@type string|nil, string
-- 		local name, ty = vim.uv.fs_scandir_next(state)
-- 		if not name then
-- 			return nil, nil, nil
-- 		end
--
-- 		local fname = path .. '/' .. name
-- 		-- note that the return type should always be nil since the fname
-- 		-- should always exist
-- 		ty = ty or vim.uv.fs_stat(fname).type
--
-- 		return fname, name, ty
-- 	end
--
-- 	return next_path, handle
-- end
--
-- return M
