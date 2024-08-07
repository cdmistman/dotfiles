vim.g.editorconfig = true
vim.g.mapleader = ' '
-- TODO: i should set some buffer-local mappings
vim.g.maplocalleader = '\\'
vim.g.loaded_node_provider = false
vim.g.loaded_python3_provider = false
vim.g.loaded_ruby_provider = false

-- TODO: include lines seem handy, needs buffer-local handling
-- TODO: set some more options
-- TODO: for some reason /matching highlighting is broken when lsps are loading
vim.opt.backupdir = vim.env.XDG_STATE_HOME .. '/nvim/backup//'
vim.opt.cursorline = true
vim.opt.gdefault = true
vim.opt.hlsearch = false
vim.opt.list = true
vim.opt.listchars = { lead = '␣', tab = '> ' }
vim.opt.magic = false
vim.opt.number = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.signcolumn = 'yes'
vim.opt.sol = true
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.updatetime = 500
vim.opt.wrapscan = false

require('vanillin').setup()
