-- courtesy of https://github.com/anuvyklack/hydra.nvim/blob/master/lua/hydra/lib/class.lua

---@param parent table?
---@return table
local function class(parent)
	local class = {}
	class.__index = class
	-- class.Super = parent

	local meta_class = {}
	meta_class.__index = parent

	function meta_class:__call(...)
		local obj = setmetatable({}, class)
		if type(class.initialize) == 'function' then
			return obj, obj:initialize(...)
		else
			return obj
		end
	end

	return setmetatable(class, meta_class)
end

---I'm going to hell.
---@generic T
---@param parent? T
---@return { __call: fun(): number }
local function class2(parent)
	---@overload ()
	local klass = { Super = parent }

	local function constructor(...)
		local obj = {}

		if parent ~= nil then
		end
	end

	return klass
end

local x = class2()
local y = x()

return class
