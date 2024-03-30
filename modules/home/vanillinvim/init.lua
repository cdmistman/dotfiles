local M = {
};







local plugins = {}

local function addPlugin(cfg)
end

local configFiles = vim.api.nvim_get_runtime_file('user/*', true)
for _, configFile in ipairs(configFiles) do
	local module = require(configFile)
end

-- local modules = vim.
-- vim.loader.enable()
-- local configs = vim.loader.find('config', {})

return M;
