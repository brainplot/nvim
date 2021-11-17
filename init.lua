-- vim: set foldmethod=marker foldenable:

-- General Options {{{

vim.g.mapleader = " "
vim.opt.backup = false
vim.opt.colorcolumn = '+1'
vim.opt.completeopt = { 'menuone', 'noinsert' }
vim.opt.foldenable = false
vim.opt.foldmethod = 'syntax'
vim.opt.formatoptions:remove { 'o' }
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.list = true
vim.opt.listchars = { tab = '> ', trail = '-', extends = '>', precedes = '<', nbsp = '+' }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 2
vim.opt.shortmess:append 'c'
vim.opt.showmode = false
vim.opt.sidescrolloff = 4
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.textwidth = 100
vim.opt.title = true
vim.opt.undofile = true
vim.opt.wildignore = { '.hg', '.svn', '.git', '*~', '*.png', '*.jpg', '*.gif', 'Thumbs.db', '*.min.js', '*.swp', '*.exe' }
vim.opt.wrap = false
vim.opt.writebackup = false

vim.opt.cindent = false
vim.opt.expandtab = false
vim.opt.shiftwidth = 0
vim.opt.smartindent = false
vim.opt.smarttab = false
vim.opt.tabstop = 4

if vim.fn.has('win32') == 1 then
    vim.opt.path = '.\\**'
else
    vim.opt.path = vim.fn.getcwd() .. '/**'
end

vim.cmd([[
    filetype on
    filetype plugin on
    filetype indent on
    syntax enable
]])

if vim.fn.has('termguicolors') then
    vim.opt.termguicolors = true
end

if vim.fn.executable('rg') then
    vim.opt.grepprg = 'rg --no-heading --vimgrep'
    vim.opt.grepformat = '%f:%l:%c:%m'
end

-- }}} General Options
-- Netrw {{{

vim.g.netrw_list_hide = '\\.git/$,\\.hg/$,\\.svn/$'
vim.g.netrw_winsize = 25

-- }}} Netrw
-- Functions and Autogroups {{{

function _G.dbg(arg)
	print(vim.inspect(arg))
end

vim.cmd([[
augroup buffercleanup
	autocmd!
	" Strip out unwanted whitespaces
	autocmd BufWritePre * lua require('buffer').trim()
augroup end

augroup skeleton
	autocmd!
	autocmd BufNewFile *.* silent! execute '0r ' . stdpath('config') . '/templates/skeleton.' . expand('%:e')
augroup end
]])

-- }}} Functions and Autogroups
