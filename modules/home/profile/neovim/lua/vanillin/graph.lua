local M = {}

---@class EdgeID: number
---@class NodeID: number
---@class Edge: { source: NodeID, dest: NodeID }

---@class Graph
---@field nodes table<NodeID, any> the nodes of the graph
---@field edges table<EdgeID, Edge> the nodes of the graph
local Graph = {}

---Creates a new Graph
---@return Graph
function M.new()
	local self = setmetatable({}, { __index = Graph })

	self.nodes = {}
	self.edges = {}

	return self
end

---Initializes a new node in the graph with the given data. Returns
---the id of the new node.
---@param data any the data of the node
---@return NodeID
function Graph:new_node(data)
	local id = #self.nodes + 1
	---@cast id NodeID
	self.nodes[id] = data
	return id
end

---Returns the data of a node in the graph.
---@param id NodeID
---@return any|nil
function Graph:node(id)
	return self.nodes[id] or nil
end

---Sets the node with the given id to the given data
---@param id NodeID
---@param data any|nil
function Graph:set_node(id, data)
	self.nodes[id] = data
end

---Initializes a new directed edge in the graph between the given
---node ids. Returns the id of the new edge.
---@param source NodeID the source node id
---@param dest NodeID the destination node id
---@return EdgeID
function Graph:new_edge(source, dest)
	local id = #self.edges + 1
	---@cast id EdgeID
	self.edges[id] = { source = source, dest = dest }
	return id
end

---Returns the data of a edge in the graph.
---@param id EdgeID
---@return Edge
function Graph:edge(id)
	return self.edges[id]
end

---Returns the roots in the graph, that is, those without any inbound edges.
---@return Array<NodeID>
function Graph:roots()
	---@type table<NodeID, boolean>
	local hay = {}
	for _, edge in self:iter_edges() do
		hay[edge.dest] = false
	end

	---@type Array<NodeID>
	local needles = {}
	for node in self:iter_nodes() do
		if not hay[node] then
			needles[#needles + 1] = node
		end
	end

	return needles
end

---Removes a node from the graph, including unlinking any edges.
---@param node NodeID the id of the node to remove
function Graph:remove_node(node)
	self.nodes[node] = nil
	for id, edge in self:iter_edges() do
		if edge.source == node or edge.dest == node then
			self.edges[id] = nil
		end
	end
end

---Returns a clone of the graph in the current state.
---@return Graph
function Graph:subgraph()
	local nodes = {}
	for ii = 0, table.maxn(self.nodes) do
		nodes[ii] = self.nodes[ii]
	end

	local edges = {}
	for ii = 0, table.maxn(self.edges) do
		edges[ii] = self.edges[ii]
	end

	local graph = M.new()
	graph.nodes = nodes
	graph.edges = edges

	return graph
end

---Returns the cardinality of the graph, aka the number of nodes
---in the graph.
---@return integer
function Graph:cardinality()
	local len = 0
	for _ in self:iter_nodes() do
		len = len + 1
	end

	return len
end

---@param self Graph
---@param prev? NodeID
---@return NodeID|nil
---@return any|nil
function Graph:next_source(prev)
	if prev then
		self:remove_node(prev)
	end

	if self:cardinality() == 0 then
		return nil, nil
	end

	local next_roots = self:iter_roots()
	local next_root_id, next_root = next_roots(self, prev)
	if next_root_id and next_root then
		return next_root_id, next_root
	end

	local first_root_id, first_root = next_roots(self)
	if first_root_id and first_root then
		return first_root_id, first_root
	end

	local dbg = ''
	for node, plugin in self:iter_nodes() do
		---@cast plugin VanPlugin
		dbg = dbg .. '\n\t' .. node .. ': ' .. plugin[1]
	end
	dbg = dbg .. '\n'
	for _, edge in self:iter_edges() do
		dbg = dbg .. '\n\t' .. edge.source .. ' -> ' .. edge.dest
	end

	error('graph has a cycle' .. dbg)
end

---Iterator over the nodes such that for all edges from u to v in the graph,
---u comes before v in the iteration.
---@return fun(graph: Graph, prev?: NodeID): NodeID | nil, any | nil
---@return Graph
function Graph:toposort()
	local subgraph = self:subgraph()
	return subgraph.next_source, subgraph
end

---@param self Graph
---@param prev? NodeID
---@return NodeID|nil
---@return any|nil
function Graph:next_node(prev)
	local start = prev or 0
	start = start + 1
	local stop = table.maxn(self.nodes)
	for i = start, stop do
		if self.nodes[i] ~= nil then
			---@cast i NodeID
			return i, self.nodes[i]
		end
	end

	return nil, nil
end

---Iterator over the nodes in the graph.
---@return fun(graph: Graph, prev?: NodeID): NodeID|nil, any|nil
---@return Graph
function Graph:iter_nodes()
	return self.next_node, self
end

---@param self Graph
---@param prev? EdgeID
---@return EdgeID|nil
---@return Edge|nil
function Graph:next_edge(prev)
	local start = prev or 0
	start = start + 1
	local stop = table.maxn(self.edges)
	for i = start, stop do
		local edge = self.edges[i]
		if edge ~= nil then
			---@cast i EdgeID
			return i, edge
		end
	end

	return nil, nil
end

---Iterator over the edges in the graph.
---@return fun(graph: Graph, prev?: EdgeID): EdgeID|nil, Edge|nil
---@return Graph
function Graph:iter_edges()
	return self.next_edge, self
end

---@param self Graph
---@param prev? NodeID
---@return NodeID|nil
---@return Node|nil
function Graph:next_root(prev)
	local next_node = self:iter_nodes()

	do
		::continue::
		local id, node = next_node(self, prev)
		prev = id
		if id == nil then
			return nil, nil
		end

		for _, edge in self:iter_edges() do
			if edge.dest == id then
				goto continue
			end
		end

		return id, node
	end
end

---Iterator over the roots in the graph.
---@return fun(graph: Graph, prev?: NodeID): NodeID|nil, Node|nil
---@return Graph
function Graph:iter_roots()
	return self.next_root, self
end

---Iterator over the dependant nodes (the ones with inward edges from)
---the given node in the graph.
---@param node NodeID
---@return fun(graph: Graph, prev?: EdgeID): EdgeID|nil, NodeID|nil, any|nil
---@return Graph
function Graph:iter_dependents(node)
	---@param graph Graph
	---@param prev? EdgeID
	---@return EdgeID|nil
	---@return NodeID|nil
	---@return any|nil
	local function next_dependent(graph, prev)
		local next_edge = graph:iter_edges()

		do
			::continue::
			local id, edge = next_edge(graph, prev)
			prev = id
			if id == nil or edge == nil then
				return nil, nil, nil
			end

			if edge.dest ~= node then
				goto continue
			end

			local source = edge.source
			local source_node = graph:node(source)
			if source_node == nil then
				goto continue
			end

			return id, source, source_node
		end
	end

	return next_dependent, self
end

---Iterator over the dependancy nodes (the ones with outward edges toward)
---the given node in the graph.
---@param node NodeID
---@return fun(graph: Graph, prev?: EdgeID): EdgeID|nil, NodeID|nil, any|nil
---@return Graph
function Graph:iter_dependencies(node)
	---@param graph Graph
	---@param prev? EdgeID
	---@return EdgeID|nil
	---@return NodeID|nil
	---@return any|nil
	local function next_dependency(graph, prev)
		local next_edge = graph:iter_edges()

		do
			::continue::
			local id, edge = next_edge(graph, prev)
			prev = id
			if id == nil or edge == nil then
				return nil, nil, nil
			end

			if edge.source ~= node then
				goto continue
			end

			local dest = edge.dest
			local dest_node = graph:node(dest)
			if dest_node == nil then
				goto continue
			end

			return id, dest, dest_node
		end
	end

	return next_dependency, self
end

return M
