---@module 'vanillin2.edge'
---@module 'vanillin2.node'

local class = require('vanillin2.util.class')

---@class vanillin.Graph
---@field nodes table<string, vanillin.Node>
---@field edges table<string, vanillin.Edge>
local Graph = class()

function Graph:initialize()
	self.nodes = {}
	self.edges = {}
end

return Graph
