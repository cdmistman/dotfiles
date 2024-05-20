local M = {}

---@class VanPluginSpec
---@field [1] string
---@field enabled? boolean whether the plugin should be prevented from loading
---@field lazy? boolean whether the plugin should be loaded lazily or eagerly
---@field event? string|string[]|(fun(self: VanPlugin)) the event to trigger on for initialization
---@field pattern? string|string[] the pattern to use for `nvim_create_autocmd`. note that this breaks dependency resolution for now lmao
---@field dependencies? string[]|VanPlugin[] the plugins this plugin requires to be initialized before this plugin may be initialized
---@field init? fun(self: VanPlugin) always executed on startup
---@field opts? table|(fun(self: VanPlugin, opts: table)) options to initialize the plugin
---@field config? boolean|(fun(self: VanPlugin, opts: table|nil)) executed to load the plugin.
---@field main? string the main module to load
---@field post_setup_hook? fun(self: VanPlugin) executed after the plugin has been loaded

---@class VanPlugin: VanPluginSpec
---@field __src VanPluginSpec
---@field node NodeID
---@field group integer
---
---@field enabled boolean
---@field lazy boolean
---@field config boolean|(fun(self: VanPlugin, opts: table|nil))
---@field main string
local VanPlugin = {}

---Validate the plugin spec
---@param graph Graph
function VanPlugin:validate(graph)
	if self.enabled == nil then
		self.enabled = true
	end

	if self.lazy == nil then
		self.lazy = true
	end

	if self.config == nil then
		self.config = true
	end

	if self.config then
		if self.main == nil then
			local top = self[1]:match('(.*)%..*')
			if top ~= nil then
				self.main = top
			else
				self.main = self[1]
			end
		end

		if not self.main then
			error('could not guess main module for plugin ' .. self[1])
		end
	end

	if not self.enabled then
		for _, _, dep in graph:iter_dependents(self.node) do
			---@cast dep VanPlugin
			if dep.enabled then
				error('plugin ' .. dep[1] .. ' depends on disabled plugin ' .. self[1])
			end
		end
	end

	if not self.lazy then
		for _, _, dep in graph:iter_dependencies(self.node) do
			---@cast dep VanPlugin
			if dep.lazy then
				error('eager plugin ' .. self[1] .. ' depends on lazy plugin ' .. dep[1])
			end
		end
	end
end

---Initializes the plugin as a lazily-loaded one. Generally relies
---on being called topo-sorted.
---@param graph Graph
function VanPlugin:lazy_load(graph)
	local isLoaded = false

	local initCallback = function()
		if isLoaded then return end
		isLoaded = true
		self:load(graph)
		vim.api.nvim_exec_autocmds('User', {
			group = self.group,
		})
	end

	local total_deps = 0
	local loaded_deps = 0
	for _, _, dep in graph:iter_dependencies(self.node) do
		---@cast dep VanPlugin
		if dep.lazy then
			total_deps = total_deps + 1
			vim.api.nvim_create_autocmd('User', {
				group = dep.group,
				once = true,
				nested = true,
				callback = function()
					loaded_deps = loaded_deps + 1
					if loaded_deps == total_deps then
						initCallback()
					end
				end,
			})
		end
	end

	local event = self.event
	if type(event) == 'function' then
		event = event(self)
	end

	if type(event) == 'string' then
		local ev = { event }
		---@cast ev Array<string>
		event = ev
	end

	if event then
		local actualEvents = {}
		local isVeryLazy = false
		for _, ev in ipairs(event) do
			if ev == 'VeryLazy' then
				isVeryLazy = true
			else
				actualEvents[#actualEvents + 1] = ev
			end
		end

		if isVeryLazy then
			vim.api.nvim_create_autocmd('User', {
				pattern = 'VeryLazy',
				once = true,
				callback = initCallback,
			})

			return
		else
			vim.api.nvim_create_autocmd(actualEvents, {
				once = true,
				callback = initCallback,
			})
		end
	end
end

---Initializes the plugin.
---@param graph Graph
function VanPlugin:load(graph)
	if not self.enabled then
		-- vim.notify('plugin ' .. self[1] .. ' is disabled', vim.log.levels.DEBUG)
		return
	end

	for _, _, dep in graph:iter_dependencies(self.node) do
		---@cast dep VanPlugin
		if not dep.enabled then
			vim.notify(
				'plugin ' .. self[1] .. ' is disabled because ' .. dep[1] .. ' is.',
				vim.log.levels.WARN
			)
			return
		end
	end

	---@type table|nil
	local opts
	if not self.opts then
		opts = nil
	elseif type(self.opts) == 'function' then
		opts = self:opts()
	else
		local my_opts = self.opts
		---@cast my_opts table
		opts = my_opts
	end

	if opts ~= nil then
		self.opts = opts
	end

	local config = self.config
	if config == true or config == nil then
		config = function()
			require(self.main).setup(opts)
		end
	end

	if config then config(self, opts) end

	if self.post_setup_hook then
		self:post_setup_hook()
	end
end

---Creates a new VanPlugin from the given spec
---@param spec VanPluginSpec|string
---@param graph Graph
---@return VanPlugin
function M.new(spec, graph)
	if type(spec) == 'string' then
		spec = { spec }
	end

	for id, node in graph:iter_nodes() do
		---@cast node VanPlugin
		if node[1] == spec[1] then
			if node.__src == spec then
				vim.notify_once(
					'do not setup vanillin more than once',
					vim.log.levels.ERROR
				)
				return node
			end

			table.remove(spec, 1)
			local self = vim.tbl_deep_extend('error', node, spec)
			setmetatable(self, { __index = VanPlugin });
			graph:set_node(id, self)
			self.node = id

			for _, dep in ipairs(spec.dependencies or {}) do
				---@cast dep Array<string|VanPluginSpec>
				local dep_id = M.new(dep, graph).node
				graph:new_edge(self.node, dep_id)
			end

			return node
		end
	end

	local self = vim.deepcopy(spec)
	setmetatable(self, { __index = VanPlugin });
	---@cast self VanPlugin
	self.group = vim.api.nvim_create_augroup('plugin' .. self[1], {})

	local node = graph:new_node(self)
	self.node = node

	for _, dep in ipairs(spec.dependencies or {}) do
		---@cast dep Array<string|VanPluginSpec>
		local dep_id = M.new(dep, graph).node
		graph:new_edge(self.node, dep_id)
	end

	self.__src = spec
	return self
end

return M
