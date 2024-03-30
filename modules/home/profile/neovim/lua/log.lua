local M = {}

function M.trace(msg)
	-- vim.notify('trac: ' .. msg, vim.log.levels.TRACE)
end

function M.debug(msg)
	-- vim.notify('dbug: 'msg, vim.log.levels.DEBUG)
end

function M.info(msg)
	vim.notify('info: ' .. msg, vim.log.levels.INFO)
end

function M.warn(msg)
	vim.notify('warn: ' .. msg, vim.log.levels.WARN)
end

function M.err(msg)
	vim.notify('err:  ' .. msg, vim.log.levels.ERROR)
end

return M

