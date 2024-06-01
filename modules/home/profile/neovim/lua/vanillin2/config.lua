local class = require('vanillin2.util.class')

---@class vanillin.Config
---@field id string
---@field enabled boolean
local Config = class()

---@class vanillin.ConfigOpts
---@field [1] string
---@field enabled? boolean
---@field lazy? boolean
---@field event? string|string[]
---@field dependencies? Array<string|vanillin.ConfigOpts>
---@field init? fun(self: vanillin.Node)
---@field opts? table|(fun(self: vanillin.Node, opts: table): table|nil)
---@field config? boolean|(fun(self: vanillin.Node, opts: table))
---@field main? string

---Intialize a user's configuration
---@param opts vanillin.ConfigOpts
function Config:initialize(opts)
	if not opts[1] or type(opts[1]) ~= 'string' then
		error('')
	end
end

return Config
