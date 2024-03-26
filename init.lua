-- vim: set foldmethod=marker foldenable:

-- General Options {{{

vim.g.mapleader = " "
vim.opt.backup = false
vim.opt.completeopt = { "menuone", "noinsert" }
vim.opt.foldenable = false
vim.opt.foldmethod = "syntax"
vim.opt.formatoptions:remove({ "o" })
vim.opt.guicursor = "a:block-nCursor"
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.list = true
vim.opt.listchars = { tab = "> ", trail = "-", extends = ">", precedes = "<", nbsp = "+" }
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.pastetoggle = "<F10>"
vim.opt.relativenumber = true
vim.opt.scrolloff = 2
vim.opt.shortmess:append("c")
vim.opt.showmode = false
vim.opt.sidescrolloff = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.title = true
vim.opt.undofile = true
vim.opt.wildignore =
	{ ".hg", ".svn", ".git", "*~", "*.png", "*.jpg", "*.gif", "Thumbs.db", "*.min.js", "*.swp", "*.exe" }
vim.opt.wildmode = { "longest", "full" }
vim.opt.wrap = false
vim.opt.writebackup = false

vim.opt.cindent = false
vim.opt.expandtab = false
vim.opt.shiftwidth = 0
vim.opt.smartindent = false
vim.opt.smarttab = false
vim.opt.tabstop = 4

if vim.fn.has("win32") == 1 then
	vim.opt.path = ".\\**"
else
	vim.opt.path = vim.fn.getcwd() .. "/**"
end

if vim.fn.has("termguicolors") then
	vim.opt.termguicolors = true
end

if vim.fn.executable("rg") then
	vim.opt.grepprg = "rg --no-heading --vimgrep"
	vim.opt.grepformat = "%f:%l:%c:%m"
end

-- }}} General Options
-- Netrw {{{

-- https://github.com/nvim-tree/nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.netrw_list_hide = "\\.git/$,\\.hg/$,\\.svn/$"
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 3

-- }}} Netrw
-- Functions and Autogroups {{{

function _G.dbg(arg)
	print(vim.inspect(arg))
end

local buffercleanupid = vim.api.nvim_create_augroup("BufferCleanup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = buffercleanupid,
	desc = "Remove unwanted whitespaces",
	callback = function()
		local b = require("buffer")
		b.trim()
	end,
})

local newtemplateid = vim.api.nvim_create_augroup("NewTemplateFile", { clear = true })
vim.api.nvim_create_autocmd("BufNewFile", {
	group = newtemplateid,
	desc = "Fill new buffer with template",
	callback = function()
		local b = require("buffer")
		b.writeskeleton()
	end,
})

-- }}} Functions and Autogroups
-- Keymaps {{{

local noremap = { noremap = true }
local noremapsilent = { noremap = true, silent = true }

-- Toggle 'wrap' option
vim.keymap.set("n", "<Leader>w", function()
	vim.wo.wrap = not vim.wo.wrap
end, noremapsilent)

-- Open vimrc in a new split, picked based on current terminal size
vim.keymap.set("n", "<Leader>v", function()
	require("window").opensplit(vim.env.MYVIMRC)
end, noremapsilent)

-- Open vimrc on top of the current buffer
vim.keymap.set("n", "<Leader>V", function()
	require("window").open(vim.env.MYVIMRC)
end, noremapsilent)

-- Switch between open buffers
vim.keymap.set("n", "<Leader>j", vim.cmd.bnext, noremapsilent)
vim.keymap.set("n", "<Leader>k", vim.cmd.bprev, noremapsilent)

-- Sort selected lines
vim.keymap.set("v", "<Leader>s", ":sort<CR>", noremapsilent)

-- Toggle between relativenumber and norelativenumber
vim.keymap.set("n", "<Leader>n", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end, noremapsilent)

-- Place current file in the system clipboard
vim.keymap.set("n", "<Leader>y", "<Cmd>%y+<CR>", noremap)

-- Open file browser
vim.keymap.set("n", "<Leader>p", "<Cmd>Vexplore<CR>", noremap)

-- }}} Keymaps
-- Plugins {{{

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazyopts = {
	ui = {
		icons = {
			cmd = "",
			config = "",
			event = "",
			ft = "",
			init = "",
			keys = "",
			plugin = "",
			runtime = "",
			source = "",
			start = "",
			task = "",
			lazy = "",
		},
	},
}

require("lazy").setup("plugins", lazyopts)

-- }}} Plugins
